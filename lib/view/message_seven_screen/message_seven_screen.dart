
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/appbar_title_circleimage.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';

class MessageSevenScreen extends StatelessWidget {
  MessageSevenScreen({Key? key})
      : super(
          key: key,
        );

 final  TextEditingController messageController = TextEditingController();

 final  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 16.v),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.all(12.h),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 93.h),
                        padding: EdgeInsets.all(4.h),
                        decoration: AppDecoration.fillGray.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderTL121,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.h),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle12155x257,
                                height: 155.v,
                                width: 257.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                              ),
                              SizedBox(height: 7.v),
                              Text(
                                "Mercedes-Benz E200 ....",
                                style: theme.textTheme.titleSmall,
                              ),
                              SizedBox(height: 10.v),
                              Padding(
                                padding: EdgeInsets.only(right: 71.h),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.v),
                                      child: Text(
                                        "purchase by :",
                                        style: CustomTextStyles
                                            .bodySmallBluegray90001,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.h),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: " ",
                                            ),
                                            TextSpan(
                                              text: "Eman Elsherbiny",
                                              style: CustomTextStyles
                                                  .titleSmallff333333SemiBold,
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.v),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      height: 40.v,
                                      text: "Confirm",
                                      margin: EdgeInsets.only(right: 4.h),
                                      leftIcon: Container(
                                        margin: EdgeInsets.only(right: 8.h),
                                        child: CustomImageView(
                                          imagePath: ImageConstant
                                              .imgCheckmarkOnprimary,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                      ),
                                      buttonStyle: CustomButtonStyles.none,
                                      decoration: CustomButtonStyles
                                          .gradientPrimaryToOrangeTL8Decoration,
                                      buttonTextStyle: CustomTextStyles
                                          .titleSmallOnPrimarySemiBold,
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomOutlinedButton(
                                      height: 40.v,
                                      text: "Reject ",
                                      margin: EdgeInsets.only(left: 4.h),
                                      leftIcon: Container(
                                        margin: EdgeInsets.only(right: 8.h),
                                        child: CustomImageView(
                                          imagePath:
                                              ImageConstant.imgClosePink600,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                      ),
                                      buttonStyle:
                                          CustomButtonStyles.outlinePinkTL8,
                                      buttonTextStyle:
                                          CustomTextStyles.titleSmallPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.v),
                      Text(
                        "12 August 2022 At 4:45 PM",
                        style: theme.textTheme.bodySmall,
                      ),
                      Spacer(),
                      CustomTextFormField(
                        controller: messageController,
                        hintText: "Your message",
                        hintStyle: theme.textTheme.bodySmall!,
                        textInputAction: TextInputAction.done,
                        prefix: Container(
                          margin: EdgeInsets.fromLTRB(14.h, 18.v, 18.h, 17.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgMenuPrimary,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        prefixConstraints: BoxConstraints(
                          maxHeight: 56.v,
                        ),
                        suffix: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 30.h,
                            vertical: 16.v,
                          ),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFismile,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                          ),
                        ),
                        suffixConstraints: BoxConstraints(
                          maxHeight: 56.v,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 19.v),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 69.v,
      leadingWidth: 39.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 22.v,
          bottom: 22.v,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 16.h),
        child: Row(
          children: [
            AppbarTitleCircleimage(
              imagePath: ImageConstant.imgEllipse133,
            ),
            Container(
              height: 36.199997.v,
              width: 114.h,
              margin: EdgeInsets.only(left: 13.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AppbarSubtitleOne(
                    text: "Ahmed Mohamed",
                    margin: EdgeInsets.only(bottom: 16.v),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 21.v,
                        right: 102.h,
                        bottom: 2.v,
                      ),
                      padding: EdgeInsets.all(2.h),
                      decoration: AppDecoration.fillGray5001.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Container(
                        height: 8.adaptSize,
                        width: 8.adaptSize,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            4.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppbarSubtitleTwo(
                    text: "Online",
                    margin: EdgeInsets.only(
                      left: 16.h,
                      top: 19.v,
                      right: 62.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      styleType: Style.bgFill,
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
