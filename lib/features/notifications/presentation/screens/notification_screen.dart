import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:sagr/view/notification_one_screen/notification_one_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../theme/theme_helper.dart';
import '../../../../widgets/appbar/build_core_app_bar.dart';

import 'package:flutter/material.dart';

import '../widgets/userprofile2_item_widget.dart';

class NotificationsScreen extends StatelessWidget {


  final NotificationsController _controller;

  NotificationsScreen(this._controller,{Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(77.0), child: BuildCoreAppBar()),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 11.v,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifications",
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 6.v),
           Expanded(child:  _buildUserProfile(context)),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }


  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Obx(() => ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (
        context,
        index,
      ) {
        return SizedBox(
          height: 8.v,
        );
      },
      itemCount: _controller.notifications.length,
      itemBuilder: (context, index) {

        return GestureDetector(child: Userprofile2ItemWidget(_controller.notifications.elementAt(index)), onDoubleTap: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationOneScreen())),);
        // return Userprofile2ItemWidget();
      },
    ));
  }

  
}
