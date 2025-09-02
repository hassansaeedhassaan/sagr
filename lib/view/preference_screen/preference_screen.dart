
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/appbar/basic_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_image_view.dart';

class PreferenceScreen extends StatelessWidget {
  PreferenceScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController languagevalueController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(preferredSize: Size.fromHeight(66), child:  BasicAppBar(title: "Preference")),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 16.v),
              _buildFrame(context),
              Spacer(),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 39.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
      title: AppbarSubtitle(
        text: "Preference ",
        margin: EdgeInsets.only(left: 16.h),
      ),
      // styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFloatingTextField(
            controller: languagevalueController,
            labelText: "Language ",
            labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
            hintText: "Language ",
            suffix: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgCheckmarkGray50001,
                height: 20.adaptSize,
                width: 20.adaptSize,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 57.v,
            ),
          ),
          SizedBox(height: 15.v),
          CustomFloatingTextField(
            controller: countryController,
            labelText: "Country",
            labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
            hintText: "Country",
            textInputAction: TextInputAction.done,
            suffix: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgCheckmarkGray50001,
                height: 20.adaptSize,
                width: 20.adaptSize,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 57.v,
            ),
          ),
          SizedBox(height: 24.v),
          CustomElevatedButton(
            text: "Update",
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
          ),
          SizedBox(height: 7.v),
        ],
      ),
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
