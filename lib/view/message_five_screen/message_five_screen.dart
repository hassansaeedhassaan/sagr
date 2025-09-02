import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

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
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';

class MessageFiveScreen extends StatelessWidget {
  MessageFiveScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController descriptionEditTextController =
      TextEditingController();

  final TextEditingController messageEditTextController =
      TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),

            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 16.v),
                Container(
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
                              SizedBox(height: 4.v),
                              Padding(
                                padding: EdgeInsets.only(right: 5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 4.v,
                                        bottom: 3.v,
                                      ),
                                      child: Text(
                                        "Offer",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "15000",
                                            style: CustomTextStyles
                                                .titleMediumffd20653SemiBold,
                                          ),
                                          TextSpan(
                                            text: " EGP",
                                            style: CustomTextStyles
                                                .bodyMediumff292d32,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 13.v),
                              _buildRelayedButton(context),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.v),
                      Text(
                        "12 August 2022 At 4:45 PM",
                        style: theme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 10.v),
                      // _buildLoremIpsumDolorSitAmetButton(context),
            
                      Align(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Text(
                            "Lorem ipsum dolor sit amet,",
                            style: TextStyle(fontSize: 14),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                8.h,
                              ),
                              topRight: Radius.circular(
                                8.h,
                              ),
                              bottomLeft: Radius.circular(
                                8.h,
                              ),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment(0.0, 1),
                              end: Alignment(1.0, 1),
                              colors: [
                                theme.colorScheme.secondaryContainer,
                                appTheme.orange400.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
            
                      SizedBox(height: 4.v),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.v),
                              child: Text(
                                "12 August 2022 At 4:45 PM",
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: CustomIconButton(
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                                padding: EdgeInsets.all(4.h),
                                decoration: IconButtonStyleHelper.fillOrange,
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgFiCheck,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.v),
                      _buildDescriptionEditText(context),
                      SizedBox(height: 8.v),
                      Text(
                        "12 August 2022 At 4:45 PM",
                        style: theme.textTheme.bodySmall,
                      ),
            
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:   _buildMessageEditText(context),
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
  Widget _buildRelayedButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 40.v,
      text: "Relayed",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkTealA70001,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.outlineTealA,
      buttonTextStyle: CustomTextStyles.titleSmallTealA70001,
    );
  }

  /// Section Widget
  Widget _buildLoremIpsumDolorSitAmetButton(BuildContext context) {
    return CustomElevatedButton(
      height: 40.v,
      width: 216.h,
      text: "Lorem ipsum dolor sit amet, ",
      buttonStyle: CustomButtonStyles.none,
      decoration:
          CustomButtonStyles.gradientSecondaryContainerToOrangeDecoration,
      buttonTextStyle: theme.textTheme.bodyLarge!,
      alignment: Alignment.centerRight,
    );
  }

  /// Section Widget
  Widget _buildDescriptionEditText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 108.h),
      child: CustomTextFormField(
        controller: descriptionEditTextController,
        hintText: "Lorem ipsum dolor sit amet, ",
        hintStyle: theme.textTheme.bodyLarge!,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8.h,
          vertical: 9.v,
        ),
        borderDecoration: TextFormFieldStyleHelper.fillGrayTL12,
        filled: true,
        fillColor: appTheme.gray10001,
      ),
    );
  }

  /// Section Widget
  Widget _buildMessageEditText(BuildContext context) {
    return CustomTextFormField(
      controller: messageEditTextController,
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
