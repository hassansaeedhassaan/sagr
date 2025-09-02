import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';



class WalkieTalkieSupervisorScreen extends StatefulWidget {
  @override
  _WalkieTalkieSupervisorScreenState createState() => _WalkieTalkieSupervisorScreenState();
}

class _WalkieTalkieSupervisorScreenState extends State<WalkieTalkieSupervisorScreen> {
  // Replace with your Agora App ID

  final AuthController _controller = Get.put(AuthController());

      final EventController eventController = Get.put(EventController(Get.find()));


  static const String appId = "3aa7d0944ad240e4acc7bff3e6a59a5f";


  
  late RtcEngine _engine;
  late RtcEngineEventHandler _eventHandler;
  bool _isJoined = false;
  bool _isTalking = false;
  bool _isMuted = true;
  bool _isInitialized = false;
  String _connectionStatus = "Disconnected";
  List<String> _connectedUsers = [];

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {


print("🔥🔥🔥🔥🔥🔥");
print(eventController.event!.channel!.agoraToken);
   

    print("🔥🔥🔥🔥🔥🔥");

    // Request microphone permission
    await [Permission.microphone].request();

    // Create RTC engine
    _engine = createAgoraRtcEngine();
    
    await _engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Enable audio
    await _engine.enableAudio();
    

    
    
    // Set audio profile for voice communication
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );


    await _engine.setDefaultAudioRouteToSpeakerphone(true);

    // Mute by default (push-to-talk behavior)
    await _engine.muteLocalAudioStream(true);

    // Set up event handlers
    _eventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        setState(() {
          _isJoined = true;
          _connectionStatus = "Connected";
        });
        print("Local user joined channel: ${connection.channelId}");
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {

        setState(() {
          _connectedUsers.add(_controller.authenticatedUser!['name']);
          // _connectedUsers.add("User $remoteUid");
        });
      
        print("Remote user $remoteUid joined");
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        setState(() {
          _connectedUsers.removeWhere((user) => user == "User $remoteUid");
        });
        print("Remote user $remoteUid left channel");
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        setState(() {
          _isJoined = false;
          _connectionStatus = "Disconnected";
          _connectedUsers.clear();
        });
        print("Local user left channel");
      },
      onAudioVolumeIndication: (RtcConnection connection, List<AudioVolumeInfo> speakers, int speakerNumber, int totalVolume) {
        // Handle volume indication for visual feedback
        for (var speaker in speakers) {
          if (speaker.uid == 0 && speaker.volume! > 10) {
            // Local user is speaking
            print("Local user speaking: ${speaker.volume}");
          }
        }
      },
    );
    
    _engine.registerEventHandler(_eventHandler);

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _joinChannel() async {
    if (!_isInitialized) return;
    
    setState(() {
      _connectionStatus = "Connecting...";
    });

    await _engine.joinChannel(
      token: eventController.event!.supervisorChannel!.agoraToken, // Use token for production
      channelId: eventController.event!.supervisorChannel!.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        
        // audioScenario: AudioScenarioType.audioScenarioGameStreaming,
      ),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> _changeChannel() async {
    await _engine.leaveChannel();
    Get.toNamed('/event_walkie_talkie');
    
  }

  void _startTalking() {
    if (!_isJoined) return;
    
    setState(() {
      _isTalking = true;
      _isMuted = false;
    });
    _engine.muteLocalAudioStream(false);
  }

  void _stopTalking() {
    setState(() {
      _isTalking = false;
      _isMuted = true;
    });
    _engine.muteLocalAudioStream(true);
  }

  @override
  void dispose() {
    _leaveChannel();
    _engine.unregisterEventHandler(_eventHandler);
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Obx( () =>  eventController.isLoading? CircularProgressIndicator() : Text(
           '${eventController.event!}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )) ,
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.only(
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
                          eventController.event!.supervisorChannel!.displayName!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

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
                      SizedBox(width: 8),
                      Text(
                        _isTalking ? 'Transmitting...' : 'Ready to talk',
                        style: TextStyle(
                          color: _isTalking ? Colors.green : Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                                        ],
                                      ),
                    ), 
                 SizedBox(
                  height: 32,
                   child: ElevatedButton(
                        onPressed: _changeChannel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 139, 67),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12)
                        ),
                        child: Text(
                          'Back to Team Channel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                 )
                  ],
                ),
                
              ],
            ),
          ),
          
          // Connected Users Section
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connected Users (${_connectedUsers.length})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: _connectedUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  color: Colors.grey[600],
                                  size: 60,
                                ),
                                SizedBox(height: 10),
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
                            itemCount: _connectedUsers.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.grey[800],
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(
                                    _connectedUsers[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Icon(
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
          
          // Controls Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Join/Leave Channel Button
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
                  // Push to Talk Button
                  GestureDetector(
                    onTapDown: (_) => _startTalking(),
                    onTapUp: (_) => _stopTalking(),
                    onTapCancel: () => _stopTalking(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: _isTalking ? Colors.red : Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isTalking ? Colors.red : Colors.blue).withOpacity(0.3),
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
                  
                  SizedBox(height: 20),
                  
                  Text(
                    _isTalking ? 'Release to stop talking' : 'Hold to talk',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Leave Channel Button
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