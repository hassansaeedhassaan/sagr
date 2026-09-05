import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/walkie_talkie/services/walkie_token_service.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

class WalkieTalkieScreen2 extends StatefulWidget {
  @override
  _WalkieTalkieScreen2State createState() => _WalkieTalkieScreen2State();
}

class _WalkieTalkieScreen2State extends State<WalkieTalkieScreen2> {
  final EventController eventController = Get.put(EventController(Get.find()));

  final WalkieTokenService _tokenService = WalkieTokenService();
  WalkieTokenResult? _tokenResult;

  RtcEngine? _engine;
  RtcEngineEventHandler? _eventHandler;
  bool _isJoined = false;
  bool _isTalking = false;
  bool _isInitialized = false;
  bool _permissionDenied = false;
  String? _initError;
  String _connectionStatus = "Disconnected";
  final Map<int, String> _remoteUsers = <int, String>{};

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    var event = eventController.event;
    // Screen is reached via `Get.toNamed('/event_walkie_talkie', arguments: eventId)`,
    // but the freshly-put EventController has no event loaded yet. Fetch it first
    // (getEventInfo reads the eventId from Get.arguments) before reading the channel.
    if (event == null || event.channel == null) {
      // Bound the fetch so a stalled/unreachable backend can't leave the screen
      // spinning forever — fall through to the error message instead.
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
      // Fetch a server-minted Agora token (provides App ID, token and uid).
      final tokenResult = await _tokenService.fetchToken(event.channel!.channelName);
      _tokenResult = tokenResult;

      final engine = createAgoraRtcEngine();
      _engine = engine;

      await engine.initialize(RtcEngineContext(
        appId: tokenResult.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      await engine.enableAudio();
      await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );
      await engine.setDefaultAudioRouteToSpeakerphone(true);
      await engine.enableAudioVolumeIndication(
        interval: 200,
        smooth: 3,
        reportVad: true,
      );
      await engine.muteLocalAudioStream(true);

      final handler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (!mounted) return;
          setState(() {
            _isJoined = true;
            _connectionStatus = "Connected";
          });
          engine.setEnableSpeakerphone(true);
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) {
          if (!mounted) return;
          setState(() {
            _remoteUsers[remoteUid] = 'User $remoteUid';
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          if (!mounted) return;
          setState(() {
            _remoteUsers.remove(remoteUid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          if (!mounted) return;
          setState(() {
            _isJoined = false;
            _connectionStatus = "Disconnected";
            _remoteUsers.clear();
          });
        },
        onError: (ErrorCodeType err, String msg) {
          if (!mounted) return;
          setState(() {
            _connectionStatus = 'Error: $msg';
          });
        },
        onAudioVolumeIndication: (RtcConnection connection,
            List<AudioVolumeInfo> speakers,
            int speakerNumber,
            int totalVolume) {},
      );
      _eventHandler = handler;
      engine.registerEventHandler(handler);

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
    final engine = _engine;
    final channel = eventController.event?.channel;
    final tokenResult = _tokenResult;
    if (!_isInitialized || engine == null || channel == null) return;
    if (tokenResult == null || tokenResult.token.isEmpty || channel.channelName.isEmpty) {
      Get.snackbar('Error', 'Channel token is missing');
      return;
    }

    setState(() {
      _connectionStatus = "Connecting...";
    });

    try {
      await engine.joinChannel(
        token: tokenResult.token,
        channelId: channel.channelName,
        uid: tokenResult.uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _connectionStatus = 'Connection failed';
      });
    }
  }

  Future<void> _leaveChannel() async {
    final engine = _engine;
    if (engine == null) return;
    try {
      await engine.leaveChannel();
    } catch (_) {}
  }

  Future<void> _changeChannel() async {
    await _leaveChannel();
    Get.toNamed('/event_supervisor_walkie_talkie');
  }

  void _startTalking() {
    final engine = _engine;
    if (!_isJoined || engine == null) return;
    setState(() {
      _isTalking = true;
    });
    engine.muteLocalAudioStream(false);
  }

  void _stopTalking() {
    final engine = _engine;
    if (engine == null) return;
    setState(() {
      _isTalking = false;
    });
    engine.muteLocalAudioStream(true);
  }

  @override
  void dispose() {
    final engine = _engine;
    final handler = _eventHandler;
    if (engine != null) {
      if (handler != null) {
        engine.unregisterEventHandler(handler);
      }
      engine.leaveChannel().whenComplete(engine.release);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return _MessageScaffold(message: _initError!);
    }
    if (_permissionDenied) {
      return _MessageScaffold(
        message:
            'Microphone permission is required to use the walkie-talkie. Please enable it in your device settings.',
        actionLabel: 'Open Settings',
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

    final titleText =
        event.name ?? channel.displayName ?? channel.channelName;
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
                          'Status',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _connectionStatus,
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
                          'Channel',
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
                            _isTalking ? 'Transmitting...' : 'Ready to talk',
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
                          child: const Text(
                            'Join Supervisors Channel',
                            style: TextStyle(
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
                    'Connected Users (${_remoteUsers.length})',
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
                                      ? 'Waiting for other users...'
                                      : 'Join channel to see users',
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
                      child: const Text(
                        'Join Channel',
                        style: TextStyle(
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
                    _isTalking ? 'Release to stop talking' : 'Hold to talk',
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
                      child: const Text(
                        'Leave Channel',
                        style: TextStyle(
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
