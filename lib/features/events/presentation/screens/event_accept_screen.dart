import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/features/events/data/models/start_date_time_model.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';

class EventAcceptScreen extends StatelessWidget {
  const EventAcceptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      init: EventController(Get.find()),
      builder: (EventController eventController) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with Cover Image
              SliverAppBar(
                expandedHeight: 280.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover Image with Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/cover.jpg"),
                          ),
                        ),
                      ),
                      // Gradient overlay for better text readability
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
                    ],
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // Event Header Card
                      eventController.isLoading
                          ? CircularProgressIndicator()
                          : _buildEventHeaderCard(context, eventController),

                      SizedBox(height: 24),

                      // ID and Zone Information Card
                      eventController.isLoading
                          ? CircularProgressIndicator()
                          : _buildInfoCard(context, eventController),

                      SizedBox(height: 32),

                      // Logo Section
                      eventController.isLoading
                          ? CircularProgressIndicator()
                          : _buildLogoSection(),

                      SizedBox(height: 32),

                      // Text(eventController.event!.zoneCoordinates.toString()),
                      // Countdown Timer
                      eventController.isLoading
                          ? CircularProgressIndicator()
                          : !eventController.isLoading &&
                                  eventController
                                          .event!.startDateTime!.status ==
                                      EventStatus.upcoming
                              ? _buildCountdownTimer(eventController.event!)
                              : Container(),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
             
            ],
          ),

        
          // Modern Bottom Navigation
          bottomNavigationBar: eventController.isLoading
              ? Center(child: CircularProgressIndicator(),)
              : eventController.event!.startDateTime!.status ==
                          EventStatus.active &&
                      eventController.event!.assigned == true
                  ? _buildModernBottomNav(eventController.event!.id!)
                  : null,
        );
      },
    );
  }

  Widget _buildEventHeaderCard(
      BuildContext context, EventController eventController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Event Icon
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.purple[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.celebration_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

          SizedBox(width: 16),

          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${eventController.event?.name!}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${eventController.event?.date}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Forward Arrow
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, EventController eventController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              // Employee ID Row
              eventController.isLoading
                  ? CircularProgressIndicator()
                  : _buildInfoRow(
                      "الرقم الوظيفي",
                      eventController.event!.nationalID!.toString(),
                      Icons.badge_outlined,
                      Colors.blue,
                    ),

              SizedBox(height: 20),

              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.grey[300]!,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Zone Row
              _buildInfoRow(
                "الزون",
                "3",
                Icons.location_on_outlined,
                Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        // Icon
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),

        SizedBox(width: 16),

        // Label
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Value
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/sagr-logo.png',
          width: 120,
          height: 60,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(EventModel event) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple[400]!,
            Colors.blue[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "الوقت المتبقي",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TimerCountdown(
              daysDescription: "Days".tr,
              secondsDescription: "Seconds".tr,
              minutesDescription: "Minutes".tr,
              hoursDescription: "Hours".tr,
              format: CountDownTimerFormat.daysHoursMinutesSeconds,
              endTime: DateTime.now().add(
                Duration(
                  days: event.startDateTime!.days,
                  hours: event.startDateTime!.hours,
                  minutes: event.startDateTime!.minutes,
                  seconds: event.startDateTime!.seconds,
                ),
              ),
              onEnd: () {
                print("Timer finished");
              },
            ),
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

  Widget _buildModernBottomNav(int eventId) {
    return Container(
      margin: EdgeInsets.all(20),
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
              // onTap: () => Get.to(() => WalkieTalkieScreen2()),
              onTap: () =>
                  Get.toNamed('/event_walkie_talkie', arguments: eventId),
              child: _buildNavItem(
                  Icons.phone_in_talk_rounded, "واكي توكي", false)),
          InkWell(
              onTap: () => Get.toNamed("/attendance_screen"),
              // onTap: ()=> Get.toNamed("/attendance_screen"),
              child: _buildNavItem(
                  Icons.campaign_outlined, "الحضور والإنصراف", false)),
          // _buildNavItem(Icons.celebration_outlined, "", true), // Center highlighted item
          _buildNavItem(Icons.notifications_outlined, "التنبيهات", false),
          _buildNavItem(Icons.chat_bubble_outline, "الدردشة", false),
        ],
      ),
    );
  }

  // Widget _buildNavItem(IconData icon, String label, bool isActive) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: isActive ? 16 : 8),
  //     decoration: BoxDecoration(
  //       gradient: isActive
  //           ? LinearGradient(
  //               colors: [Colors.blue[400]!, Colors.purple[400]!],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             )
  //           : null,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           icon,
  //           color: isActive ? Colors.white : Colors.grey[600],
  //           size: isActive ? 24 : 20,
  //         ),
  //         if (label.isNotEmpty) ...[
  //           SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: FontWeight.w500,
  //               color: isActive ? Colors.white : Colors.grey[600],
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }
}
