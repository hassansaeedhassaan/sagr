import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/features/evocations/presentation/controllers/evocations_controller.dart';
import 'package:sagr/sagr_chat/routes/app_routes.dart';

import '../../../evocations/data/models/evocation_model.dart';
import '../../../evocations/presentation/widgets/evocation_create.dart';
import 'loading.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceAndDepartureScreen extends StatefulWidget {
  AttendanceAndDepartureScreen({super.key});

  @override
  State<AttendanceAndDepartureScreen> createState() =>
      _AttendanceAndDepartureScreenState();
}

class _AttendanceAndDepartureScreenState
    extends State<AttendanceAndDepartureScreen> with TickerProviderStateMixin {
  final _key = GlobalKey<ExpandableFabState>();
  final Completer<GoogleMapController> googleMapController = Completer();
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  final EventController eventController = Get.put(EventController(Get.find()));
  final EvocationsController evocationsController =
      Get.put(EvocationsController(Get.find()));

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _slideController.forward();
  }

  Future<void> showCreateEvocationBottomSheet({
    required BuildContext context,
    required Function(EvocationModel) onEvocationCreated,
    EvocationModel? initialEvocation,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEvocationBottomSheet(
        onEvocationCreated: onEvocationCreated,
        initialEvocation: initialEvocation,
      ),
    );
  }

  Position? _currentPosition;
  String _locationMessage = 'Location not obtained';

  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationMessage = 'Getting location...';
    });

    try {
      Position? position = await SagrLocationService.getCurrentLocation();

      if (position != null) {
        setState(() {
          _currentPosition = position;
          _locationMessage = 'Location obtained successfully';
        });
      } else {
        setState(() {
          _locationMessage = 'Failed to get location';
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = 'Error: $e';
      });
    } finally {}
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CenterCircleOverlay(
          showIndicator: eventController.isLoading ? true : false,
          // indicatorSize: 23,
          isAnimated: false,
          circleColor: Colors.transparent,
          circleSize: 70.0,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                "Attendance And Departure".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              elevation: 0,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[700]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 20),

                            // Event Header Card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667eea).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    eventController.event!.name!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "09:00 AM",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),

// Obx( () => AttendanceToggleButton(isCheckedIn: !eventController.isCheckedIn, onToggle: (value) => eventController.attendanceCheckInOut(value==false?'departure':'attendance'))),

                            // Map Card
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/map.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Color(0xFF667eea),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 40),

                            // Attendance Buttons
                            Row(
                              children: [
                                // Check In Button
                                Obx(() => !eventController.isCheckedIn
                                    ? Expanded(
                                        child: GestureDetector(
                                          onTap: () => eventController
                                              .attendanceCheckInOut(
                                                  'attendance'),
                                          child: AnimatedBuilder(
                                            animation: _pulseAnimation,
                                            builder: (context, child) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFF11998e),
                                                      Color(0xFF38ef7d),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    bottomRight:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                    bottomLeft:
                                                        Radius.circular(30),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF11998e)
                                                          .withOpacity(0.4),
                                                      blurRadius: 15,
                                                      offset: Offset(0, 8),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: eventController
                                                              .isLoading
                                                          ? SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : Icon(
                                                              Icons.login,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Text(
                                                      "تسجيل الحضور",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : Container()),

                                // Obx(()=> Text(eventController.isCheckedIn.toString())),
                                // AttendanceToggleButton(isCheckedIn: eventController.event!.isCheckedIn!, onToggle: (value) => print(value) ),
                                // Text(eventController.event!.isCheckedIn.toString()),
                                // SizedBox(width: 16),

                                // Check Out Button
                                Obx(() => eventController.isCheckedIn
                                    ? Expanded(
                                        child: GestureDetector(
                                          onTap: () => eventController
                                              .attendanceCheckInOut(
                                                  'departure'),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFFff416c),
                                                  Color(0xFFff4b2b),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFff416c)
                                                      .withOpacity(0.4),
                                                  blurRadius: 15,
                                                  offset: Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "تسجيل الانصراف ${eventController.isCheckedIn}"  ,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: eventController
                                                              .isLoading
                                                          ? SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : Icon(
                                                              Icons.logout,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                              ],
                            ),

//                         Obx(() =>AttendanceToggleButton(
//                           isLoading: eventController.isLoading,
//   isCheckedIn: eventController.isCheckedIn,
//   onToggle: (value) => eventController.attendanceCheckInOut(value),
// )),

                            SizedBox(height: 40),

                            // Permissions Button
                            SizedBox(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  showCreateEvocationBottomSheet(
                                    context: context,
                                    onEvocationCreated: (evocation) =>
                                        evocationsController.apply(evocation),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Color(0xFF667eea).withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF667eea)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.assignment_outlined,
                                          color: Color(0xFF667eea),
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Permissions".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF667eea),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ), // Bottom Navigation
              ],
            ),
            bottomNavigationBar: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: GradientAnimatedBorderContainer(
                    animationDuration: Duration(seconds: 2),
                    borderWidth: 4,
                    child: _buildModernBottomNav(eventController.event!.id!))),
          ),
        ));
  }
}

Widget _buildModernBottomNav(int eventId) {
  return Container(
    margin: EdgeInsets.all(0),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 20,
          offset: Offset(0, -5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
            onTap: () =>
                Get.toNamed('/event_walkie_talkie', arguments: eventId),
            child:
                _buildNavItem(Icons.phone_in_talk_rounded, "واكي توكي", false)),
        InkWell(
            onTap: () => Get.toNamed("/attendance_screen"),
            child: _buildNavItem(
                Icons.campaign_outlined, "الحضور والإنصراف", false)),
        _buildNavItem(Icons.notifications_outlined, "التنبيهات", false),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.HOME),
          child: _buildNavItem(Icons.chat_bubble_outline, "الدردشة", false),
        ),
      ],
    ),
  );
}

Widget _buildNavItem(IconData icon, String label, bool isCenter) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(isCenter ? 15 : 0),
        decoration: BoxDecoration(
          color: isCenter ? Colors.indigo.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(isCenter ? 25 : 8),
          boxShadow: isCenter
              ? [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isCenter ? Colors.white : Colors.grey.shade600,
          size: isCenter ? 24 : 30,
        ),
      ),
      if (!isCenter) ...[
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ],
  );
}

class SagrLocationService {
  // Get current position with error handling
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get location with custom settings
  static Future<Position?> getLocationWithSettings({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit,
      );

      return position;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Check location permissions
  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // Request location permissions
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // Open app settings for permission
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Calculate distance between two points
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}

class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Color lightColor;
  final double borderWidth;
  final bool enableAnimation;

  const AnimatedBorderContainer({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(seconds: 2),
    this.lightColor = Colors.blue,
    this.borderWidth = 2.0,
    this.enableAnimation = true,
  }) : super(key: key);

  @override
  State<AnimatedBorderContainer> createState() =>
      _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: widget.enableAnimation
                ? Border.all(
                    color: widget.lightColor.withOpacity(_animation.value),
                    width: widget.borderWidth,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
              if (widget.enableAnimation)
                BoxShadow(
                  color: widget.lightColor.withOpacity(_animation.value * 0.3),
                  spreadRadius: _animation.value * 3,
                  blurRadius: _animation.value * 15,
                  offset: const Offset(0, 0),
                ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Alternative version with gradient border animation
class GradientAnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final List<Color> gradientColors;
  final double borderWidth;
  final bool enableAnimation;

  const GradientAnimatedBorderContainer({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(seconds: 3),
    this.gradientColors = const [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.orange
    ],
    this.borderWidth = 2.0,
    this.enableAnimation = true,
  }) : super(key: key);

  @override
  State<GradientAnimatedBorderContainer> createState() =>
      _GradientAnimatedBorderContainerState();
}

class _GradientAnimatedBorderContainerState
    extends State<GradientAnimatedBorderContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(_controller);

    if (widget.enableAnimation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: CustomPaint(
            painter: widget.enableAnimation
                ? GradientBorderPainter(
                    rotation: _rotationAnimation.value,
                    colors: widget.gradientColors,
                    borderWidth: widget.borderWidth,
                  )
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double rotation;
  final List<Color> colors;
  final double borderWidth;

  GradientBorderPainter({
    required this.rotation,
    required this.colors,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(25));

    final gradient = SweepGradient(
      colors: colors,
      stops:
          List.generate(colors.length, (index) => index / (colors.length - 1)),
      transform: GradientRotation(rotation * 3.14159),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Your original implementation with animated border
class YourAnimatedBottomNav extends StatelessWidget {
  final String eventId;

  const YourAnimatedBottomNav({Key? key, required this.eventId})
      : super(key: key);

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBorderContainer(
      animationDuration: const Duration(seconds: 2),
      lightColor: Colors.blue,
      borderWidth: 2.0,
      enableAnimation: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () =>
                Get.toNamed('/event_walkie_talkie', arguments: eventId),
            child:
                _buildNavItem(Icons.phone_in_talk_rounded, "واكي توكي", false),
          ),
          InkWell(
            onTap: () => Get.toNamed("/attendance_screen"),
            child: _buildNavItem(
                Icons.campaign_outlined, "الحضور والإنصراف", false),
          ),
          _buildNavItem(Icons.notifications_outlined, "التنبيهات", false),
          _buildNavItem(Icons.chat_bubble_outline, "الدردشة", false),
        ],
      ),
    );
  }
}

// Pulsing border animation version
class PulsingBorderContainer extends StatefulWidget {
  final Widget child;
  final Duration pulseDuration;
  final Color pulseColor;
  final double maxPulseWidth;
  final double minPulseWidth;

  const PulsingBorderContainer({
    Key? key,
    required this.child,
    this.pulseDuration = const Duration(milliseconds: 1500),
    this.pulseColor = Colors.blue,
    this.maxPulseWidth = 4.0,
    this.minPulseWidth = 1.0,
  }) : super(key: key);

  @override
  State<PulsingBorderContainer> createState() => _PulsingBorderContainerState();
}

class _PulsingBorderContainerState extends State<PulsingBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: widget.minPulseWidth,
      end: widget.maxPulseWidth,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: widget.pulseColor,
              width: _pulseAnimation.value,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
              BoxShadow(
                color: widget.pulseColor.withOpacity(0.3),
                spreadRadius: _pulseAnimation.value,
                blurRadius: _pulseAnimation.value * 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
