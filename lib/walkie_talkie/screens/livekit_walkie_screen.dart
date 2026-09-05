import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/walkie_talkie/services/livekit_token_service.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// LiveKit-backed walkie-talkie screen for an event's public channel.
///
/// Replaces the retired Agora screen on the `/event_walkie_talkie` route and
/// carries the same design as the old `WalkieTalkieScreen2`: a status/channel
/// header, a connected-users list, and a hold-to-talk control. This screen owns
/// the LiveKit [Room] lifecycle directly (the shared [PushToTalkButton] widget
/// is intentionally left for the compact attendance-screen use case).
class LiveKitWalkieScreen extends StatefulWidget {
  const LiveKitWalkieScreen({super.key});

  @override
  State<LiveKitWalkieScreen> createState() => _LiveKitWalkieScreenState();
}

class _LiveKitWalkieScreenState extends State<LiveKitWalkieScreen> {
  final EventController eventController = Get.put(EventController(Get.find()));

  final LiveKitTokenService _tokenService = LiveKitTokenService();
  LiveKitTokenResult? _tokenResult;

  Room? _room;
  EventsListener<RoomEvent>? _listener;

  bool _isInitialized = false;
  bool _isJoined = false;
  bool _isTalking = false;
  bool _permissionDenied = false;
  String? _initError;
  String _connectionStatus = "Disconnected";
  // identity -> display name for the participants currently on the channel.
  final Map<String, String> _remoteUsers = <String, String>{};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    var event = eventController.event;
    // Reached via `Get.toNamed('/event_walkie_talkie', arguments: eventId)`, so
    // the freshly-put controller has no event yet. Load it (getEventInfo reads
    // the eventId from Get.arguments), bounded so a stalled backend can't hang.
    if (event == null || event.channel == null) {
      try {
        await eventController.getEventInfo().timeout(const Duration(seconds: 15));
      } catch (_) {}
      event = eventController.event;
    }
    if (event == null || event.channel == null) {
      if (!mounted) return;
      setState(() {
        _initError = 'Channel information is unavailable.';
      });
      return;
    }

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      if (!mounted) return;
      setState(() {
        _permissionDenied = true;
        _connectionStatus = 'Microphone permission denied';
      });
      return;
    }

    try {
      // Fetch a server-minted LiveKit token (provides room url, token, identity).
      final tokenResult =
          await _tokenService.fetchToken(event.channel!.channelName);
      _tokenResult = tokenResult;
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initError = 'Failed to initialize audio engine: $e';
      });
    }
  }

  Future<void> _joinChannel() async {
    final tokenResult = _tokenResult;
    if (!_isInitialized || tokenResult == null) return;
    if (tokenResult.token.isEmpty || tokenResult.url.isEmpty) {
      Get.snackbar('Error'.tr, 'Channel token is missing'.tr);
      return;
    }

    setState(() {
      _connectionStatus = "Connecting...";
    });

    try {
      final room = Room();
      _room = room;

      _listener = room.createListener()
        ..on<ParticipantConnectedEvent>((_) => _updateRemotes())
        ..on<ParticipantDisconnectedEvent>((_) => _updateRemotes())
        ..on<RoomDisconnectedEvent>((_) {
          if (!mounted) return;
          setState(() {
            _isJoined = false;
            _isTalking = false;
            _connectionStatus = "Disconnected";
            _remoteUsers.clear();
          });
        });

      await room.connect(
        tokenResult.url,
        tokenResult.token,
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      // Join muted — only transmit while the button is held.
      await room.localParticipant?.setMicrophoneEnabled(false);

      if (!mounted) return;
      setState(() {
        _isJoined = true;
        _connectionStatus = "Connected";
      });
      _updateRemotes();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _connectionStatus = 'Connection failed';
      });
      await _teardownRoom();
    }
  }

  Future<void> _leaveChannel() async {
    await _teardownRoom();
    if (!mounted) return;
    setState(() {
      _isJoined = false;
      _isTalking = false;
      _connectionStatus = "Disconnected";
      _remoteUsers.clear();
    });
  }

  Future<void> _teardownRoom() async {
    await _listener?.dispose();
    _listener = null;
    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
  }

  void _updateRemotes() {
    final room = _room;
    if (!mounted || room == null) return;
    setState(() {
      _remoteUsers
        ..clear()
        ..addEntries(room.remoteParticipants.values.map((p) {
          final name = p.name.isNotEmpty ? p.name : p.identity;
          return MapEntry(p.identity, name);
        }));
    });
  }

  Future<void> _changeChannel() async {
    await _leaveChannel();
    Get.toNamed('/event_supervisor_walkie_talkie');
  }

  Future<void> _startTalking() async {
    final lp = _room?.localParticipant;
    if (!_isJoined || lp == null) return;
    setState(() {
      _isTalking = true;
    });
    try {
      await lp.setMicrophoneEnabled(true);
    } catch (_) {
      if (mounted) setState(() => _isTalking = false);
    }
  }

  Future<void> _stopTalking() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    setState(() {
      _isTalking = false;
    });
    try {
      await lp.setMicrophoneEnabled(false);
    } catch (_) {}
  }

  @override
  void dispose() {
    _teardownRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return _MessageScaffold(message: _initError!.tr);
    }
    if (_permissionDenied) {
      return _MessageScaffold(
        message:
            'Microphone permission is required to use the walkie-talkie. Please enable it in your device settings.'
                .tr,
        actionLabel: 'Open Settings'.tr,
        onAction: openAppSettings,
      );
    }

    final event = eventController.event;
    final channel = event?.channel;
    if (event == null || channel == null) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final titleText = event.name ?? channel.displayName ?? channel.channelName;
    final channelLabel = channel.displayName ?? channel.channelName;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Obx(() => eventController.isLoading
            ? AppLoader.inline(color: Colors.white)
            : Text(
                titleText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status'.tr,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _connectionStatus.tr,
                          style: TextStyle(
                            color: _isJoined ? Colors.green : Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Channel'.tr,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          channelLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            _isTalking ? Icons.mic : Icons.mic_off,
                            color: _isTalking ? Colors.green : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isTalking
                                ? 'Transmitting...'.tr
                                : 'Ready to talk'.tr,
                            style: TextStyle(
                              color:
                                  _isTalking ? Colors.green : Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (event.userType == 'supervisor')
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: _changeChannel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 139, 67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                          ),
                          child: Text(
                            'Join Supervisors Channel'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'Connected Users'.tr} (${_remoteUsers.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _remoteUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  color: Colors.grey[600],
                                  size: 60,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _isJoined
                                      ? 'Waiting for other users...'.tr
                                      : 'Join channel to see users'.tr,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _remoteUsers.length,
                            itemBuilder: (context, index) {
                              final entry =
                                  _remoteUsers.entries.elementAt(index);
                              return Card(
                                color: Colors.grey[800],
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(
                                    entry.value,
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(
                                    Icons.volume_up,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                if (!_isJoined)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isInitialized ? _joinChannel : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Join Channel'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (_isJoined) ...[
                  GestureDetector(
                    onTapDown: (_) => _startTalking(),
                    onTapUp: (_) => _stopTalking(),
                    onTapCancel: () => _stopTalking(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _isTalking ? Colors.red : Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isTalking ? Colors.red : Colors.blue)
                                .withOpacity(0.3),
                            blurRadius: _isTalking ? 20 : 10,
                            spreadRadius: _isTalking ? 5 : 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isTalking ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isTalking
                        ? 'Release to stop talking'.tr
                        : 'Hold to talk'.tr,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _leaveChannel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Leave Channel'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageScaffold extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageScaffold({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 60),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
