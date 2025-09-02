import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/features/evocations/presentation/controllers/evocations_controller.dart';
import 'package:sagr/sagr_chat/routes/app_routes.dart';
import 'package:intl/intl.dart';
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
  
  // Enhanced Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  
  // Enhanced Animations
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final EventController eventController = Get.put(EventController(Get.find()));
  final EvocationsController evocationsController =
      Get.put(EvocationsController(Get.find()));

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Pulse Animation for Check-in Button
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Slide Animation for Main Content
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Fade Animation for Status Changes
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale Animation for Buttons
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _slideController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
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

  // Dynamic time formatting
  String _getFormattedTime() {
    // if (eventController.event?.startDateTime != null) {
    //   try {
    //     final DateTime time = DateTime.parse(eventController.event!.startDateTime!);
    //     return DateFormat('hh:mm a').format(time);
    //   } catch (e) {
    //     return DateFormat('hh:mm a').format(DateTime.now());
    //   }
    // }
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  // Get event status color
  Color _getStatusColor() {
    if (eventController.isCheckedIn) {
      return Colors.orange;
    }
    return Colors.green;
  }

  // Get status text
  String _getStatusText() {
    if (eventController.isLoading) return 'Processing...'.tr;
    if (eventController.isCheckedIn) return 'Checked In'.tr;
    return 'Ready to Check In'.tr;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CenterCircleOverlay(
          showIndicator: eventController.isLoading,
          isAnimated: true,
          circleColor: Colors.transparent,
          circleSize: 70.0,
          child: Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            appBar: _buildEnhancedAppBar(),
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
                            _buildEventHeaderCard(),
                            SizedBox(height: 25),
                            _buildStatusIndicator(),
                            SizedBox(height: 25),
                            _buildLocationCard(),
                            SizedBox(height: 35),
                            _buildEnhancedActionButtons(),
                            SizedBox(height: 30),
                            _buildPermissionsButton(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: GradientAnimatedBorderContainer(
                    animationDuration: Duration(seconds: 3),
                    borderWidth: 3,
                    child: _buildModernBottomNav(eventController.event?.id?.toString() ?? '0'))),
          ),
        ));
  }

  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      title: Text(
        "Attendance & Departure".tr,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Color(0xFF1E293B),
        ),
      ),
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFFF8FAFC),
      centerTitle: false,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF64748B), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildEventHeaderCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFA855F7),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6366F1).withOpacity(0.25),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.event,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              eventController.event?.name ?? 'Event Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _getFormattedTime(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStatusColor().withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor().withOpacity(0.1),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12),
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Map or Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
            // Location Info
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        eventController.event?.appliedStatus ?? 'Event Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Location Accuracy Indicator
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.gps_fixed,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedActionButtons() {
    return Column(
      children: [
        // Check In Button
        Obx(() => !eventController.isCheckedIn
            ? _buildCheckInButton()
            : _buildCheckOutButton()),
        
        // Additional Info
        SizedBox(height: 16),
        Text(
          'Tap to record your attendance'.tr,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInButton() {
    return GestureDetector(
      onTap: eventController.isLoading 
          ? null 
          : () => eventController.attendanceCheckInOut('attendance'),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: eventController.isLoading ? 1.0 : _pulseAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10B981),
                    Color(0xFF059669),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF10B981).withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: eventController.isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Check In".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckOutButton() {
    return GestureDetector(
      onTap: eventController.isLoading 
          ? null 
          : () => eventController.attendanceCheckInOut('departure'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEF4444),
              Color(0xFFDC2626),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEF4444).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Check Out".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: eventController.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsButton() {
    return GestureDetector(
      onTap: () {
        showCreateEvocationBottomSheet(
          context: context,
          onEvocationCreated: (evocation) =>
              evocationsController.apply(evocation),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF6366F1).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.assignment_outlined,
                color: Color(0xFF6366F1),
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Text(
              "Request Permissions".tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildModernBottomNav(String eventId) {
  return Container(
    margin: EdgeInsets.all(0),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 24,
          offset: Offset(0, -8),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
            onTap: () => Get.toNamed('/event_walkie_talkie', arguments: eventId),
            child: _buildNavItem(Icons.phone_in_talk_rounded, "Walkie Talkie".tr, false)),
        InkWell(
            onTap: () => Get.toNamed("/attendance_screen"),
            child: _buildNavItem(Icons.campaign_outlined, "Attendance".tr, true)),
        _buildNavItem(Icons.notifications_outlined, "Notifications".tr, false),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.HOME),
          child: _buildNavItem(Icons.chat_bubble_outline, "Chat".tr, false),
        ),
      ],
    ),
  );
}

Widget _buildNavItem(IconData icon, String label, bool isSelected) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(0xFF6366F1).withOpacity(0.15) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? Color(0xFF6366F1) : Color(0xFF64748B),
          size: 24,
        ),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Color(0xFF6366F1) : Color(0xFF64748B),
        ),
      ),
    ],
  );
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
