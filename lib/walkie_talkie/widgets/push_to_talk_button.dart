import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/walkie_talkie/services/livekit_token_service.dart';

/// Compact hold-to-talk (push-to-talk) control for the event walkie channel,
/// backed by LiveKit (WebRTC). Sits on the attendance screen once the employee
/// has checked in: it joins the event's LiveKit room with the mic OFF, then
/// publishes audio only while the button is held. Releasing mutes again.
///
/// Self-contained — owns the Room lifecycle and tears it down on dispose. Fails
/// soft (disabled label) if no channel/token/mic so it never breaks the screen.
class PushToTalkButton extends StatefulWidget {
  /// Walkie channel name for the event → maps 1:1 to a LiveKit room.
  final String channelName;

  const PushToTalkButton({super.key, required this.channelName});

  @override
  State<PushToTalkButton> createState() => _PushToTalkButtonState();
}

enum _PttState { connecting, ready, talking, unavailable }

class _PushToTalkButtonState extends State<PushToTalkButton> {
  final LiveKitTokenService _tokenService = LiveKitTokenService();

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  int _remoteCount = 0;
  _PttState _state = _PttState.connecting;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    if (widget.channelName.isEmpty) {
      _set(_PttState.unavailable);
      return;
    }

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      _set(_PttState.unavailable);
      return;
    }

    try {
      final tk = await _tokenService.fetchToken(widget.channelName);
      if (tk.token.isEmpty || tk.url.isEmpty) {
        _set(_PttState.unavailable);
        return;
      }

      final room = Room();
      _room = room;

      _listener = room.createListener()
        ..on<ParticipantConnectedEvent>((_) => _updateRemotes())
        ..on<ParticipantDisconnectedEvent>((_) => _updateRemotes())
        ..on<RoomDisconnectedEvent>((_) {
          if (mounted) _set(_PttState.unavailable);
        });

      await room.connect(
        tk.url,
        tk.token,
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      // Join muted — only transmit while the button is held.
      await room.localParticipant?.setMicrophoneEnabled(false);

      _updateRemotes();
      if (mounted && _state == _PttState.connecting) _set(_PttState.ready);
    } catch (_) {
      _set(_PttState.unavailable);
    }
  }

  void _updateRemotes() {
    final n = _room?.remoteParticipants.length ?? 0;
    if (mounted) setState(() => _remoteCount = n);
  }

  void _set(_PttState s) {
    if (mounted) setState(() => _state = s);
  }

  Future<void> _startTalking() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    _set(_PttState.talking);
    try {
      await lp.setMicrophoneEnabled(true);
    } catch (_) {
      _set(_PttState.ready);
    }
  }

  Future<void> _stopTalking() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    try {
      await lp.setMicrophoneEnabled(false);
    } catch (_) {}
    if (_state == _PttState.talking) _set(_PttState.ready);
  }

  @override
  void dispose() {
    _listener?.dispose();
    _room?.disconnect();
    _room?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final talking = _state == _PttState.talking;
    final ready = _state == _PttState.ready || talking;
    final unavailable = _state == _PttState.unavailable;

    final Color base = talking
        ? const Color(0xffdc2626)
        : (ready ? AppTheme.brand : AppTheme.textHint);

    final String label = unavailable
        ? 'Walkie-talkie unavailable'.tr
        : talking
            ? 'Release to stop'.tr
            : (ready ? 'Hold to talk'.tr : 'Connecting…'.tr);

    return Column(
      children: [
        GestureDetector(
          onTapDown: ready ? (_) => _startTalking() : null,
          onTapUp: ready ? (_) => _stopTalking() : null,
          onTapCancel: ready ? _stopTalking : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: talking ? base : Colors.transparent,
              border: Border.all(color: base, width: 1.6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: talking
                  ? [
                      BoxShadow(
                        color: base.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  talking ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: talking ? Colors.white : base,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: talking ? Colors.white : base,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (ready && _remoteCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '${_remoteCount} ${'on channel'.tr}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
