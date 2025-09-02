// import 'package:eltikia_s_application6/core/app_export.dart';
// import 'package:eltikia_s_application6/presentation/category_page/category_page.dart';
// import 'package:eltikia_s_application6/presentation/feature_ads_page/feature_ads_page.dart';
// import 'package:eltikia_s_application6/widgets/app_bar/appbar_leading_iconbutton.dart';
// import 'package:eltikia_s_application6/widgets/app_bar/appbar_title_iconbutton.dart';
// import 'package:eltikia_s_application6/widgets/app_bar/appbar_title_image.dart';
// import 'package:eltikia_s_application6/widgets/app_bar/appbar_trailing_iconbutton.dart';
// import 'package:eltikia_s_application6/widgets/app_bar/custom_app_bar.dart';
// import 'package:eltikia_s_application6/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/appbar/build_core_app_bar.dart';
import '../../widgets/custom_image_view.dart';

class NotificationOneScreen extends StatelessWidget {
  NotificationOneScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(77.0), child: BuildCoreAppBar()),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 8.v,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Notifications",
                style: theme.textTheme.titleLarge,
              ),
            ),
            Spacer(
              flex: 46,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgEnablePushNotifications,
              height: 171.v,
              width: 195.h,
            ),
            SizedBox(height: 12.v),
            Text(
              "There are no notification yet",
              style: CustomTextStyles.bodyMediumGray60001,
            ),
            Spacer(
              flex: 53,
            ),
          ],
        ),
      ),
    );
  }

}
