import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/events/presentation/screens/event_ncalender.dart';
import '../../theme/app_decoration.dart';


class MoreOneScreen extends StatefulWidget {
  const MoreOneScreen({Key? key}) : super(key: key);

  @override
  State<MoreOneScreen> createState() => _MoreOneScreenState();
}

class _MoreOneScreenState extends State<MoreOneScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Custom App Bar Space
                    SizedBox(height: 50.v),
                    
                    // Enhanced Profile Section
                    _buildEnhancedProfileSection(context),
                    
                    SizedBox(height: 24.v),
                    
                    // Main Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Events & Activities Section
                          _buildSectionHeader("Events & Activities".tr, Icons.event_outlined),
                          SizedBox(height: 12.v),
                          _buildAnimatedSection([
                            _buildEnhancedMenuItem(
                              icon: Icons.campaign_outlined,
                              title: "Advertisements".tr,
                              subtitle: "Manage your ads".tr,
                              onTap: () => Get.toNamed('/ads', arguments: 'ads'),
                            ),
                            _buildEnhancedMenuItem(
                              icon: Icons.history_outlined,
                              title: "Previous Events".tr,
                              subtitle: "View past events".tr,
                              onTap: () => Get.toNamed('/previous_events', arguments: {'ed': 'previous'}),
                            ),
                            // _buildEnhancedMenuItem(
                            //   icon: Icons.calendar_today_outlined,
                            //   title: "Previous Events Calendar".tr,
                            //   subtitle: "Calendar view of past events",
                            //   onTap: () => Get.toNamed('/e_calender', arguments: {'ed': 'previous'}),
                            // ),
                            _buildEnhancedMenuItem(
                              icon: Icons.event_note_outlined,
                              title: "My Events".tr,
                              subtitle: "Your personal events".tr,
                              onTap: () => Get.toNamed('/events', arguments: {'es': 'my-events'}),
                            ),
                            _buildEnhancedMenuItem(
                              icon: Icons.date_range_outlined,
                              title: "Events Calendar".tr,
                              subtitle: "Calendar overview".tr,
                              // onTap: () => Get.toNamed('/events_calender', arguments: 'payment-fees'),
                              onTap: () => Get.to(() => EventCalendarPage() ),
                              isLast: true,
                            ),
                          ]),
                          
                          SizedBox(height: 24.v),
                          
                          // Orders & Processing Section
                          _buildSectionHeader("Orders & Processing".tr, Icons.inventory_outlined),
                          SizedBox(height: 12.v),
                          _buildAnimatedSection([
                            _buildEnhancedMenuItem(
                              icon: Icons.pending_actions_outlined,
                              title: "Orders Under Processing".tr,
                              subtitle: "Track your pending orders".tr,
                              onTap: () => Get.toNamed('/permissions'),
                              isLast: true,
                            ),
                          ]),
                          
                          SizedBox(height: 32.v),
                          
                          // Logout Section
                          _buildEnhancedLogoutSection(context),
                          
                          SizedBox(height: 32.v),
                          
                          // Enhanced Support Section
                          _buildEnhancedSupportSection(context),
                          
                          SizedBox(height: 32.v),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Enhanced Profile Section with improved lighting and design
  Widget _buildEnhancedProfileSection(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (AuthController authController) {
        if (authController.isLoading) {
          return _buildProfileShimmer();
        }
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade700,
                Colors.indigo.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.h),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(20.h),
            child: Row(
              children: [
                // Enhanced Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/create_account'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.h),
                      child: Container(
                        width: 80.h,
                        height: 80.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(40.h),
                        ),
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 16.h),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${authController.authenticatedUser!['firstName']} ${authController.authenticatedUser!['middleName']} ${authController.authenticatedUser!['lastName']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 8.v),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.v),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Text(
                          '${authController.authenticatedUser!['phone'] ?? "--".tr}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 8.v),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.v),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(12.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'ID: ${authController.authenticatedUser!['nationalID'] ?? "--"}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Edit Button
                InkWell(
                  onTap: () => Get.toNamed('/update_account'),
                  child: Container(
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Profile Shimmer Loading
  Widget _buildProfileShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CircleAvatar(radius: 40.h),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header with enhanced styling
  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.v),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Animated Section Container
  Widget _buildAnimatedSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /// Enhanced Menu Item
  Widget _buildEnhancedMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.h),
        child: Container(
          padding: EdgeInsets.all(18.h),
          decoration: BoxDecoration(
            border: !isLast ? Border(
              bottom: BorderSide(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ) : null,
          ),
          child: Row(
            children: [
              Container(
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.indigo.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4.v),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced Logout Section
  Widget _buildEnhancedLogoutSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.red.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            GetStorage().remove('access_token');
            GetStorage().remove('userData');
            GetStorage().remove('loggedInUserName');
            GetStorage().remove('loggedInUserPhone');
            Get.offAndToNamed("/login");
          },
          borderRadius: BorderRadius.circular(16.h),
          child: Container(
            padding: EdgeInsets.all(18.h),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(14.h),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.red.shade700,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تسجيل خروج",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        "Sign out of your account".tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Enhanced Support Section with lighting effects
  Widget _buildEnhancedSupportSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.teal.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Support Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade500, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.support_agent_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16.h),
              Text(
                "الدعم".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.green.shade600,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.v),
          
          // Contact Methods
          Column(
            children: [
              _buildContactMethod(
                Icons.phone_outlined,
                "+966566467735",
                Colors.blue.shade600,
              ),
              SizedBox(height: 12.v),
              _buildContactMethod(
                Icons.email_outlined,
                "sagr@mail.com",
                Colors.orange.shade600,
              ),
              SizedBox(height: 12.v),
              _buildContactMethod(
                Icons.telegram,
                "sagr@mail.com",
                Colors.blue.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Contact Method Item
  Widget _buildContactMethod(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
          Icon(
            Icons.copy_outlined,
            size: 18,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Color(0xFFEBEBF4),
          Color.fromARGB(255, 243, 243, 243),
          Color(0xFFEBEBF4),
        ],
        stops: [0.1, 0.3, 0.4],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 36),
        decoration: AppDecoration.linear.copyWith(
          border: Border.all(width: 0),
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8360c3),
                Color(0xff2ebf91),
              ],
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: const Text(
              'My Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 4 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                const Text(
                  'Check out my Profile',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    height: expandedHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: CircularProfileAvatar(
                      '',
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.fill,
                      ),
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.yellow,
                      borderWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}