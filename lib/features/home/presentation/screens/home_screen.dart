import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sagr/features/events/presentation/controllers/events_controller.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/jobs/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/sagr_chat/routes/app_routes.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../data/colors.dart';
import '../../../../sagr_chat/screens/home/home_screen.dart';

// Modern Color Palette
class AppColors {
  static const primary = Color(0xFF6366F1);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF4F46E5);
  static const secondary = Color(0xFF06B6D4);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const surface = Color(0xFFFAFAFA);
  static const surfaceVariant = Color(0xFFF3F4F6);
  static const onSurface = Color(0xFF111827);
  static const onSurfaceVariant = Color(0xFF6B7280);
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  EventsController _controller = Get.put(EventsController(Get.find()));


  @override
  Widget build(BuildContext context) {

     Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'.tr),
        content: Text('Are you sure you want to exit the app?'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'.tr),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        // Show exit confirmation dialog
        final shouldExit = await _showExitDialog();
        if (shouldExit == true) {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: MasterWrapper(
        body: Scaffold(
          backgroundColor: AppColors.surface,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              // Header Section
              _buildHeader(),
      
      
      // SizedBox(
      //   height: 30,
      //   child: Marquee(
      //   text: 'Some sample text that takes some space.',
      //   style: TextStyle(fontWeight: FontWeight.bold),
      //   scrollAxis: Axis.horizontal,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   blankSpace: 20.0,
      //   velocity: 100.0,
      //   pauseAfterRound: Duration(seconds: 1),
      //   startPadding: 10.0,
      //   accelerationDuration: Duration(seconds: 1),
      //   accelerationCurve: Curves.linear,
      //   decelerationDuration: Duration(milliseconds: 500),
      //   decelerationCurve: Curves.easeOut,
      // ),
      // ),
      
      
              // Jobs Section
              _buildJobsSectionV2(),
      
              //  _buildJobsSection(),
      
      
      
              // Events Section Header
              _buildEventsHeader(),
      
              // Events List with Infinite Scroll
              Expanded(child: _buildEventsList()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: InkWell(
        onTap: () => Get.toNamed(AppRoutes.HOME),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            "Sagr".tr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.onSurface),
          onPressed: () {}, // Add notification functionality
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مرحباً بك!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "استكشف الفرص المتاحة والفعاليات القادمة",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الوظائف المتاحة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {}, // Navigate to all jobs
                child: Text("عرض الكل"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 0),
        SizedBox(
          height: 120,
          child: GetBuilder<JobsController>(
            init: JobsController(Get.find()),
            builder: (JobsController jobController) {
              if (jobController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: jobController.jobs.length + 1,
                itemBuilder: (context, index) => index == 0? 
                    Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _controller.filterEventsByJob(0);
                }, // Add job tap functionality
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.home_work_sharp,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "جميع الوظائف",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ):_buildJobCard(jobController.jobs[index-1]) ,
              );
            },
          ),
        ),
        const SizedBox(height: 10), // Add spacing after jobs section
      ],
    );
  }

  Widget _buildJobsSectionV2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الوظائف المتاحة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {}, // Navigate to all jobs
                child: Text("عرض الكل"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 0),
        SizedBox(
          height: 80,
          child: GetBuilder<JobsController>(
            init: JobsController(Get.find()),
            builder: (JobsController jobController) {
              if (jobController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: jobController.jobs.length + 1,
                itemBuilder: (context, index) => index == 0? 
                    Container(
        
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _controller.filterEventsByJob(0);
                }, // Add job tap functionality
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        width: 35,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.home_work_sharp,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "جميع الوظائف",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ):_buildJobCardV2(jobController.jobs[index-1]) ,
              );
            },
          ),
        ),
        const SizedBox(height: 10), // Add spacing after jobs section
      ],
    );
  }

  Widget _buildJobCard(JobModel job) {
    return GetBuilder<EventsController>(
        init: EventsController(Get.find()),
        builder: (EventsController controller) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // MessageHelper.showSuccessDialog(
                  //       title: 'نجح العملية',
                  //       message: 'تم حفظ البيانات بنجاح',
                  //       onConfirm: () {
                  //         print('تم تأكيد العملية');
                  //       },
                  //     );

                  _controller.filterEventsByJob(job.id!);
                }, // Add job tap functionality
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.work_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        job.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildJobCardV2(JobModel job) {
    return GetBuilder<EventsController>(
        init: EventsController(Get.find()),
        builder: (EventsController controller) {
          return Container(
            // width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // MessageHelper.showSuccessDialog(
                  //       title: 'نجح العملية',
                  //       message: 'تم حفظ البيانات بنجاح',
                  //       onConfirm: () {
                  //         print('تم تأكيد العملية');
                  //       },
                  //     );

                  _controller.filterEventsByJob(job.id!);
                }, // Add job tap functionality
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        width: 35,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.work_outline,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        job.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildEventsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "الفعاليات القادمة",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          TextButton(
            onPressed: () {}, // Navigate to all events
            child: Text("عرض الكل"),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return GetBuilder<EventsController>(
      init: EventsController(Get.find()),
      builder: (EventsController eventController) {
        if (eventController.isLoading && eventController.events.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: AppColors.primary,
              rightDotColor: AppColors.secondary,
              size: 50,
            ),
          );
        }

        return SmartRefresher(
          controller: eventController.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: eventController.onRefresh,
          onLoading: eventController.onLoading,
          header: const WaterDropHeader(),
          footer: CustomFooter(
            height: 55,
            builder: (BuildContext context, LoadStatus? mode) {
              return _buildSmartRefresherFooter(mode, eventController);
            },
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 0),
            itemCount: eventController.events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(eventController.events[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.toNamed(
                  '/event_processing_screen',
                  arguments: event.id,
                  preventDuplicates: true,
                );
            // switch (event.appliedStatus) {
            //   case 'accepted':
            //     Get.toNamed(
            //       '/event_accept_screen',
            //       arguments: event.id,
            //       preventDuplicates: true,
            //     );
            //     break;
            //   case 'initAccept':
            //     Get.toNamed(
            //       '/event_screen',
            //       arguments: event.id,
            //       preventDuplicates: true,
            //     );
            //     break;
            //   case 'rejected':
            //     break;
            //   case 'pending':
            //     Get.toNamed(
            //       '/event_processing_screen',
            //       arguments: event.id,
            //       preventDuplicates: true,
            //     );
            //     break;
            //   default:
            //     Get.toNamed(
            //       '/event_apply_screen',
            //       arguments: event!.id,
            //       preventDuplicates: true,
            //     );
            // }
            
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildEventLogo(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event!.address != null ? event!.address.toString():"غير متوفر",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color.fromARGB(255, 78, 78, 78),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildTimeIndicator(event.ago),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateTimeInfo(event),

                    
                    InkWell(

                      onTap: () {
            switch (event.appliedStatus) {
              case 'accepted':
                Get.toNamed(
                  '/event_accept_screen',
                  arguments: event.id,
                  preventDuplicates: true,
                );
                break;
              case 'initAccept':
                Get.toNamed(
                  '/event_screen',
                  arguments: event.id,
                  preventDuplicates: true,
                );
                break;
              case 'rejected':
                break;
              case 'pending':
                Get.toNamed(
                  '/event_processing_screen',
                  arguments: event.id,
                  preventDuplicates: true,
                );
                break;
              default:
                Get.toNamed(
                  '/event_apply_screen',
                  arguments: event!.id,
                  preventDuplicates: true,
                );
            }
            
          },
                      child:_buildStatusButton(event.appliedStatus) ,
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          "assets/images/sagr-logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTimeIndicator(String? ago) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            ago ?? "",
            style: TextStyle(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfo(dynamic event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.date.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          event.time.toString(),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String? status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case 'accepted':
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        icon = Icons.check_circle_outline;
        text = status!.tr;
        break;
      case 'initAccept':
        bgColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        icon = Icons.pending_outlined;
        text = status!.tr;
        
        break;
      case 'rejected':
        bgColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        icon = Icons.cancel_outlined;
        text = status!.tr;
        break;
      case 'pending':
        bgColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        icon = Icons.schedule;
        text = status!.tr;
        break;
      default:
        bgColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        icon = Icons.arrow_forward;
        text = 'تقديم';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRefresherFooter(
      LoadStatus? mode, EventsController controller) {
    Widget body;

    if (mode == LoadStatus.idle) {
      body = controller.events.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "اسحب لأعلى للمزيد",
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();
    } else if (mode == LoadStatus.loading) {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: AppColors.primary,
            rightDotColor: AppColors.secondary,
            size: 40,
          ),
        ),
      );
    } else if (mode == LoadStatus.failed) {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              "فشل في التحميل! اضغط للمحاولة مرة أخرى",
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else if (mode == LoadStatus.canLoading) {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "اتركه للتحميل",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.onSurfaceVariant,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "لا يوجد المزيد من الفعاليات",
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Override for hasMore check
    if (!controller.hasMore) {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🛑",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "لا يوجد المزيد من الفعاليات",
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return body;
  }
}

class AppliedWidgetStatusAndApplyButton extends StatelessWidget {
  final String? status;

  const AppliedWidgetStatusAndApplyButton({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'accepted') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: SAGR_ACCEPTED.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.done,
                size: 15, color: SAGR_ACCEPTED.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: SAGR_ACCEPTED.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (status == 'initAccept') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.indeterminate_check_box,
                size: 15, color: SAGR_INIT_ACCEPTED.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: SAGR_INIT_ACCEPTED.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (status == 'rejected') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: RED_COLOR.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.error, size: 15, color: RED_COLOR.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: RED_COLOR.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (status == 'pending') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: SAGR_PENDING.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.timer,
                size: 15, color: SAGR_PENDING.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: SAGR_PENDING.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
          color: GREY_COLOR.withOpacity(0.4),
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
      child: Row(
        children: [
          Text(
            'تقديم',
            style: TextStyle(height: 1.4),
          ),
          Icon(
            Icons.arrow_forward,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = 2.0;
    final radius = 20.0;
    final tRadius = 2 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color.fromARGB(255, 0, 0, 0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 100;
  static double height = 100;
}
