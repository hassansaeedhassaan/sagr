import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sagr/walkie_talkie/services/livekit_token_service.dart';

/// Lifecycle state of a walkie-talkie session.
enum WalkieState {
  /// Not connected and not trying to.
  idle,

  /// Fetching a token / opening the LiveKit room.
  connecting,

  /// In the room, mic muted unless [WalkieSession.isTalking].
  connected,

  /// LiveKit dropped the signal link and is retrying on its own.
  reconnecting,

  /// Microphone permission was refused.
  micDenied,

  /// Connect failed (no channel, no token, server unreachable, …).
  failed,
}

/// A remote participant on the channel, as rendered by the walkie UI.
class WalkieParticipant {
  final String identity;
  final String name;
  final bool speaking;

  const WalkieParticipant({
    required this.identity,
    required this.name,
    required this.speaking,
  });
}

/// Owns a LiveKit [Room] for one walkie channel and exposes it as a
/// [ChangeNotifier] the walkie screens and the compact push-to-talk button all
/// drive the same way.
///
/// Why a shared object instead of per-screen [Room] plumbing:
///  * `roomOptions` must be passed to the `Room()` constructor — the
///    `room.connect(roomOptions:)` parameter is deprecated and silently
///    ignored by livekit_client 2.4.3, so per-screen copies of that call were
///    running with default options (no speaker routing, no PTT-friendly mute).
///  * Push-to-talk needs `stopAudioCaptureOnMute: false`. With the default
///    (true) every mute tears the capture track down and every unmute
///    republishes it, which on iOS re-negotiates the audio session — hundreds
///    of milliseconds of clipped speech at the start of each transmission.
///  * Reconnect, app-lifecycle muting and teardown are easy to get subtly
///    wrong; one implementation keeps Android and iOS behaving the same.
///
/// The session always joins **muted** and only publishes while
/// [startTalking] is in effect.
class WalkieSession extends ChangeNotifier with WidgetsBindingObserver {
  WalkieSession({required this.channelName, LiveKitTokenService? tokenService})
      : _tokenService = tokenService ?? LiveKitTokenService();

  /// Walkie channel name for the event → maps 1:1 to a LiveKit room.
  final String channelName;

  final LiveKitTokenService _tokenService;

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  bool _disposed = false;
  bool _busy = false;

  WalkieState _state = WalkieState.idle;
  String? _error;
  bool _isTalking = false;
  List<WalkieParticipant> _participants = const [];
  Set<String> _speakers = const {};

  WalkieState get state => _state;

  /// Human-readable reason for [WalkieState.failed]; null otherwise.
  String? get error => _error;

  bool get isTalking => _isTalking;

  /// True while the room is usable — the talk button should be live.
  bool get canTalk => _state == WalkieState.connected;

  /// Remote participants currently on the channel.
  List<WalkieParticipant> get participants => _participants;

  /// Kicks off permission → token → connect. Safe to call repeatedly; overlapping
  /// calls are ignored while one is in flight.
  Future<void> connect() async {
    if (_busy || _disposed) return;
    if (_state == WalkieState.connected || _state == WalkieState.reconnecting) {
      return;
    }
    _busy = true;
    try {
      await _connect();
    } finally {
      _busy = false;
    }
  }

  Future<void> _connect() async {
    if (channelName.isEmpty) {
      _fail('Channel information is unavailable.');
      return;
    }

    _set(WalkieState.connecting, error: null);

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      _set(WalkieState.micDenied);
      return;
    }
    if (_disposed) return;

    final LiveKitTokenResult tk;
    try {
      tk = await _tokenService.fetchToken(channelName);
    } catch (e) {
      _fail(LiveKitTokenService.describeError(e));
      return;
    }
    if (_disposed) return;

    if (tk.token.isEmpty || tk.url.isEmpty) {
      _fail('Channel token is missing.');
      return;
    }

    // Route to the loudspeaker and keep the capture track alive across mutes so
    // push-to-talk toggles are instant. Video knobs stay off — audio only.
    final room = Room(
      roomOptions: const RoomOptions(
        defaultAudioCaptureOptions: AudioCaptureOptions(
          noiseSuppression: true,
          echoCancellation: true,
          autoGainControl: true,
          highPassFilter: true,
          stopAudioCaptureOnMute: false,
        ),
        defaultAudioPublishOptions: AudioPublishOptions(
          dtx: true,
          red: true,
          audioBitrate: AudioPreset.speech,
        ),
        defaultAudioOutputOptions: AudioOutputOptions(speakerOn: true),
      ),
    );

    _listener = room.createListener()
      ..on<ParticipantConnectedEvent>((_) => _refreshParticipants())
      ..on<ParticipantDisconnectedEvent>((_) => _refreshParticipants())
      ..on<TrackPublishedEvent>((_) => _refreshParticipants())
      ..on<TrackUnpublishedEvent>((_) => _refreshParticipants())
      ..on<ParticipantNameUpdatedEvent>((_) => _refreshParticipants())
      ..on<ActiveSpeakersChangedEvent>((e) {
        _speakers = e.speakers.map((p) => p.identity).toSet();
        _refreshParticipants();
      })
      ..on<RoomReconnectingEvent>((_) {
        // LiveKit retries on its own; surface it instead of tearing down.
        _isTalking = false;
        _set(WalkieState.reconnecting);
      })
      ..on<RoomReconnectedEvent>((_) {
        _set(WalkieState.connected);
        _refreshParticipants();
      })
      ..on<RoomDisconnectedEvent>((e) {
        // Reached only after LiveKit gave up (or we asked to leave).
        if (e.reason == DisconnectReason.clientInitiated) return;
        _isTalking = false;
        _participants = const [];
        _speakers = const {};
        _fail('Disconnected from the channel.');
      });

    _room = room;

    try {
      await room.connect(tk.url, tk.token);
      // Join muted — only transmit while the talk button is held.
      await room.localParticipant?.setMicrophoneEnabled(false);
      await Hardware.instance.setSpeakerphoneOn(true);
    } catch (e) {
      await _teardown();
      _fail('Could not connect to the channel.');
      return;
    }

    if (_disposed) {
      await _teardown();
      return;
    }

    WidgetsBinding.instance.addObserver(this);
    _set(WalkieState.connected);
    _refreshParticipants();
  }

  /// Leaves the room and returns to [WalkieState.idle].
  Future<void> disconnect() async {
    await _teardown();
    _isTalking = false;
    _participants = const [];
    _speakers = const {};
    _set(WalkieState.idle, error: null);
  }

  /// Re-runs the whole connect flow after a failure.
  Future<void> retry() async {
    await _teardown();
    await connect();
  }

  Future<void> startTalking() async {
    final lp = _room?.localParticipant;
    if (!canTalk || lp == null || _isTalking) return;
    _isTalking = true;
    _notify();
    try {
      await lp.setMicrophoneEnabled(true);
    } catch (_) {
      _isTalking = false;
      _notify();
    }
  }

  Future<void> stopTalking() async {
    final lp = _room?.localParticipant;
    if (!_isTalking) return;
    _isTalking = false;
    _notify();
    try {
      await lp?.setMicrophoneEnabled(false);
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Never leave a hot mic behind when the app leaves the foreground — the
    // gesture's onTapUp never arrives if the user backgrounds mid-transmission.
    if (state != AppLifecycleState.resumed && _isTalking) {
      stopTalking();
    }
  }

  Future<void> _teardown() async {
    WidgetsBinding.instance.removeObserver(this);
    final listener = _listener;
    final room = _room;
    _listener = null;
    _room = null;
    await listener?.dispose();
    try {
      await room?.disconnect();
    } catch (_) {}
    await room?.dispose();
  }

  void _refreshParticipants() {
    final room = _room;
    if (room == null) return;
    _participants = room.remoteParticipants.values.map((p) {
      return WalkieParticipant(
        identity: p.identity,
        name: p.name.isNotEmpty ? p.name : p.identity,
        speaking: _speakers.contains(p.identity),
      );
    }).toList(growable: false);
    _notify();
  }

  void _fail(String message) {
    _error = message;
    _set(WalkieState.failed);
  }

  void _set(WalkieState state, {String? error = _keep}) {
    _state = state;
    if (!identical(error, _keep)) _error = error;
    _notify();
  }

  static const String _keep = '__keep__';

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_teardown());
    super.dispose();
  }
}
