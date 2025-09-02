import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';

import '../services/agora_service.dart';

class WalkieTalkieScreen extends StatefulWidget {
  final String? appId;
  final String? channelName;
  final String? token;
  final int? userId;

  const WalkieTalkieScreen({
    required this.appId,
    required this.channelName,
    required this.token,
    required this.userId,
  });

  @override
  _WalkieTalkieScreenState createState() => _WalkieTalkieScreenState();
}

class _WalkieTalkieScreenState extends State<WalkieTalkieScreen> {
  bool isPushing = false;
  bool isPoweredOn = true;
  double volume = 0.7;
  int currentChannel = 1;

  late AgoraService _agoraService;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _agoraService = AgoraService();
    _initializeAgora();
    _requestPermissionIfNeed();
  }

  Future<void> _requestPermissionIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.audio, Permission.microphone].request();
    }
  }

  void _startTalking() async {
    setState(() => _isMuted = false);

    await _agoraService.setUserRole(ClientRoleType.clientRoleBroadcaster);
    await _agoraService.muteLocalAudio(false);
  }

  void _stopTalking() async {
    setState(() => _isMuted = true);
    await _agoraService.setUserRole(ClientRoleType.clientRoleAudience);
    await _agoraService.muteLocalAudio(true);
  }

  Future<void> _initializeAgora() async {
    await _agoraService.initialize(widget.appId!);
    await _agoraService.joinChannel(
        widget.token!, widget.channelName!, widget.userId!);
    await _agoraService.setUserRole(ClientRoleType.clientRoleAudience);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 320,
                  height: 600,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2d2d2d),
                        Color(0xFF1a1a1a),
                        Color(0xFF0d0d0d),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Antenna
                      Positioned(
                        top: -30,
                        left: 50,
                        child: Container(
                          width: 4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF666666),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Main body
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Top section with LED and brand
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Power LED
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        isPoweredOn ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isPoweredOn
                                            ? Colors.green.withOpacity(0.6)
                                            : Colors.red.withOpacity(0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),

                                // Brand name
                                Text(
                                  'RADIO-X',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30),

                            // Speaker grille
                            Container(
                              width: 120,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Color(0xFF0a0a0a),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color(0xFF333333), width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  6,
                                  (index) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      8,
                                      (i) => Container(
                                        width: 3,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF444444),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Display screen
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF001a00),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Color(0xFF003300), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  'CH $currentChannel',
                                  style: TextStyle(
                                    color: Color(0xFF00ff00),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            // Volume control
                            Row(
                              children: [
                                Icon(Icons.volume_down,
                                    color: Color(0xFF666666)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Color(0xFF00ff00),
                                      inactiveTrackColor: Color(0xFF333333),
                                      thumbColor: Color(0xFF00ff00),
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8),
                                    ),
                                    child: Slider(
                                      value: volume,
                                      onChanged: (value) {
                                        setState(() {
                                          volume = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Icon(Icons.volume_up, color: Color(0xFF666666)),
                              ],
                            ),

                            SizedBox(height: 30),

                            // Channel buttons
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     _buildChannelButton(Icons.remove, () {
                            //       if (currentChannel > 1) {
                            //         setState(() {
                            //           currentChannel--;
                            //         });
                            //       }
                            //     }),
                            //     _buildChannelButton(Icons.add, () {
                            //       if (currentChannel < 16) {
                            //         setState(() {
                            //           currentChannel++;
                            //         });
                            //       }
                            //     }),
                            //   ],
                            // ),

                            // SizedBox(height: 30),

                            // Push to talk button
                            GestureDetector(
                              onTapDown: (_) {
                                _startTalking();
                                setState(() {
                                  isPushing = true;
                                });
                              },
                              onTapUp: (_) {
                                _stopTalking();
                                setState(() {
                                  isPushing = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  isPushing = false;
                                });
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: isPushing
                                        ? [Color(0xFF004400), Color(0xFF002200)]
                                        : [
                                            Color(0xFF444444),
                                            Color(0xFF222222)
                                          ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: isPushing ? 5 : 15,
                                      offset: Offset(0, isPushing ? 2 : 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        color: isPushing
                                            ? Color(0xFF00ff00)
                                            : Color(0xFF888888),
                                        size: 30,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'PUSH\nTO TALK',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isPushing
                                              ? Color(0xFF00ff00)
                                              : Color(0xFF888888),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 40),

                            // Power button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPoweredOn = !isPoweredOn;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Color(0xFF555555), width: 1),
                                ),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: isPoweredOn
                                      ? Color(0xFF00ff00)
                                      : Color(0xFF666666),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            EventBottomNavigation()
          ],
        ),
      ),
    );
  }

  Widget _buildChannelButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF444444), Color(0xFF222222)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Color(0xFF888888),
          size: 24,
        ),
      ),
    );
  }
}

// Main app
