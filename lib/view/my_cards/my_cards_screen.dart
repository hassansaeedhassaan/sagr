import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/appbar/basic_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import 'widgets/userprofile6_item_widget.dart';

import 'package:flutter/material.dart';

class MyCardsScreen extends StatelessWidget {
  MyCardsScreen({Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
              appBar: PreferredSize(preferredSize: Size.fromHeight(66), child:  BasicAppBar(title: "My Cards")),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            _buildUserProfile(context),
            SizedBox(height: 24.v),
            CustomElevatedButton(
              onPressed:  () =>{},
              text: "Add new card",
              leftIcon: Container(
                margin: EdgeInsets.only(right: 10.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCloseOnprimary,
                  height: 12.adaptSize,
                  width: 12.adaptSize,
                ),
              ),
              buttonStyle: CustomButtonStyles.none,
              decoration:
                  CustomButtonStyles.gradientPrimaryToOrangeDecoration,
            ),
            SizedBox(height: 5.v),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }

  

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (
        context,
        index,
      ) {
        return SizedBox(
          height: 8.v,
        );
      },
      itemCount: 2,
      itemBuilder: (context, index) {
        return Userprofile6ItemWidget();
      },
    );
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        Navigator.pushNamed(
            navigatorKey.currentContext!, getCurrentRoute(type));
      },
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
      //   return AppRoutes.featureAdsPage;
      // case BottomBarEnum.Category:
      //   return AppRoutes.categoryPage;
      // case BottomBarEnum.Message:
        return "/";
      case BottomBarEnum.More:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      // case AppRoutes.featureAdsPage:
      //   return FeatureAdsPage();
      // case AppRoutes.categoryPage:
      //   return CategoryPage();
      default:
        return DefaultWidget();
    }
  }
}
