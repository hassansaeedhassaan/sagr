import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/notification_one_screen/notification_one_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../theme/theme_helper.dart';
import '../../widgets/appbar/build_core_app_bar.dart';
import '../notification_screen/widgets/userprofile2_item_widget.dart';

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key})
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
              "Notifications ",
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
    return ListView.separated(
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
      itemCount: 7,
      itemBuilder: (context, index) {

        return GestureDetector(child: Userprofile2ItemWidget(), onDoubleTap: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationOneScreen())),);
        // return Userprofile2ItemWidget();
      },
    );
  }

  
}
