import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../ads_details_one_screen/widgets/userprofile1_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_image_view.dart';


class AdsDetailsOneScreen extends StatelessWidget {
  AdsDetailsOneScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController searchController = TextEditingController();

  TextEditingController veryNiceProductController = TextEditingController();

  TextEditingController replayController = TextEditingController();

  TextEditingController veryNiceProductController1 = TextEditingController();

  TextEditingController replayController1 = TextEditingController();

  TextEditingController frameController = TextEditingController();

  TextEditingController replayController2 = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.v),
              child: Column(
                children: [
                  _buildComponent(context),
                  SizedBox(height: 16.v),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFavorite(context),
                        _buildNegotiable(context),
                        Expanded(
                          child: Column(
                            children: [
                              _buildFrame2(context),
                              SizedBox(height: 12.v),
                              _buildFrame4(context),
                              SizedBox(height: 12.v),
                              _buildDescriptionFrame(context),
                              SizedBox(height: 12.v),
                              _buildViewMore(context),
                              SizedBox(height: 22.v),
                              _buildRelated(context),
                              SizedBox(height: 11.v),
                              _buildUserProfile(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
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
        text: "Ads Details",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildComponent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary,
      child: CustomSearchView(
        controller: searchController,
        hintText: "Search for ads...",
      ),
    );
  }

  /// Section Widget
  Widget _buildFavorite(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(
        top: 343.v,
        bottom: 1456.v,
      ),
      child: IntrinsicWidth(
        child: Padding(
          padding: EdgeInsets.only(right: 1795.h),
          child: Column(
            children: [
              SizedBox(
                height: 135.v,
                width: 195.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgRectangle12,
                      height: 135.v,
                      width: 195.h,
                      radius: BorderRadius.vertical(
                        top: Radius.circular(12.h),
                      ),
                      alignment: Alignment.center,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8.h,
                          top: 8.v,
                        ),
                        child: Row(
                          children: [
                            CustomIconButton(
                              height: 28.adaptSize,
                              width: 28.adaptSize,
                              padding: EdgeInsets.all(4.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: CustomIconButton(
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgGroup58519,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildNegotiableButton(
                context,
                carsText: "#cars",
                dateText: " in 22/1/2023",
                mercedesBenz: "Mercedes-Benz ",
                locationText: "Dakahlia, Mansoura",
                priceText: "1000 EGP",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFavoriteButton(BuildContext context) {
    return CustomElevatedButton(
      height: 28.v,
      width: 80.h,
      text: "Negotiable",
      buttonStyle: CustomButtonStyles.fillTealA,
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildNegotiable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(
        top: 343.v,
        bottom: 1456.v,
      ),
      child: IntrinsicWidth(
        child: Padding(
          padding: EdgeInsets.only(right: 1592.h),
          child: Column(
            children: [
              SizedBox(
                height: 135.v,
                width: 195.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgRectangle12,
                      height: 135.v,
                      width: 195.h,
                      radius: BorderRadius.vertical(
                        top: Radius.circular(12.h),
                      ),
                      alignment: Alignment.center,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 173.h,
                        margin: EdgeInsets.fromLTRB(8.h, 8.v, 14.h, 99.v),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIconButton(
                              height: 28.adaptSize,
                              width: 28.adaptSize,
                              padding: EdgeInsets.all(4.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite,
                              ),
                            ),
                            _buildFavoriteButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildNegotiableButton(
                context,
                carsText: "#cars",
                dateText: " in 22/1/2023",
                mercedesBenz: "Mercedes-Benz ",
                locationText: "Dakahlia, Mansoura",
                priceText: "1000 EGP",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNegotiableButton3(BuildContext context) {
    return CustomElevatedButton(
      height: 28.v,
      width: 80.h,
      text: "Negotiable",
      buttonStyle: CustomButtonStyles.fillTealA,
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildFrame2(BuildContext context) {
    return SizedBox(
      height: 268.v,
      width: 398.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle11,
            height: 268.v,
            width: 398.h,
            radius: BorderRadius.circular(
              12.h,
            ),
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 374.h,
                    margin: EdgeInsets.only(
                      left: 4.h,
                      right: 5.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 28.adaptSize,
                          width: 28.adaptSize,
                          padding: EdgeInsets.all(4.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFavorite,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup58519,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgVuesaxLinearFlag,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgSearch,
                            ),
                          ),
                        ),
                        Spacer(),
                        _buildNegotiableButton3(context),
                      ],
                    ),
                  ),
                  SizedBox(height: 152.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowLeft,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.symmetric(vertical: 22.v),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8.h),
                          padding: EdgeInsets.all(4.h),
                          decoration: AppDecoration.fillOnPrimary1.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle457,
                                height: 60.v,
                                width: 59.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle462,
                                height: 60.v,
                                width: 59.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                                margin: EdgeInsets.only(left: 4.h),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle459,
                                height: 60.v,
                                width: 59.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                                margin: EdgeInsets.only(left: 4.h),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle462,
                                height: 60.v,
                                width: 59.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                                margin: EdgeInsets.only(left: 4.h),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle459,
                                height: 60.v,
                                width: 59.h,
                                radius: BorderRadius.circular(
                                  8.h,
                                ),
                                margin: EdgeInsets.only(left: 4.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowRight,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.only(
                          left: 8.h,
                          top: 22.v,
                          bottom: 22.v,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildChatButton(BuildContext context) {
    return CustomElevatedButton(
      height: 45.v,
      width: 156.h,
      text: "Chat ",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSettingsOnprimary,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildWhatsUpButton(BuildContext context) {
    return CustomOutlinedButton(
      width: 156.h,
      text: "What's up ",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgVolume,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame4(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#cars",
                style: CustomTextStyles.bodySmallOrange400,
              ),
              Text(
                " in 22/1/2023",
                style: CustomTextStyles.bodySmall10,
              ),
            ],
          ),
          _buildFrame(
            context,
            descriptionText: "Mercedes-Benz E200 2024 AMG Fully Loaded",
            translateText: "1000 EGP",
          ),
          SizedBox(height: 10.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgEllipse1,
                height: 42.adaptSize,
                width: 42.adaptSize,
                radius: BorderRadius.circular(
                  21.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Eman Elsherbiny",
                      style: theme.textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgLinkedinGray60001,
                          height: 20.adaptSize,
                          width: 20.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.h,
                            top: 2.v,
                          ),
                          child: Text(
                            "Dakahlia, Mansoura , Egypt",
                            style: CustomTextStyles.bodySmallBluegray90001,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChatButton(context),
              _buildWhatsUpButton(context),
              CustomIconButton(
                height: 45.adaptSize,
                width: 45.adaptSize,
                padding: EdgeInsets.all(11.h),
                decoration: IconButtonStyleHelper.outlinePink,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildDescriptionFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFrame(
            context,
            descriptionText: "Description",
            translateText: "Translate to English",
          ),
          SizedBox(height: 8.v),
          SizedBox(
            width: 374.h,
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, \\magna aliqua.Lorem ipsum dolor sit amet, con\\sed.",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: CustomTextStyles.bodyLargeGray60001.copyWith(
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildVeryNiceProduct(BuildContext context) {
    return CustomTextFormField(
      controller: veryNiceProductController,
      hintText: "Very nice product",
      contentPadding: EdgeInsets.all(8.h),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray10001,
    );
  }

  /// Section Widget
  Widget _buildReplay(BuildContext context) {
    return CustomTextFormField(
      controller: replayController,
      hintText: "Replay",
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildVeryNiceProduct1(BuildContext context) {
    return CustomTextFormField(
      controller: veryNiceProductController1,
      hintText: "Very nice product",
      contentPadding: EdgeInsets.all(8.h),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray10001,
    );
  }

  /// Section Widget
  Widget _buildReplay1(BuildContext context) {
    return CustomTextFormField(
      controller: replayController1,
      hintText: "Replay",
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame10(BuildContext context) {
    return CustomTextFormField(
      controller: frameController,
      hintText: "Very nice product",
      contentPadding: EdgeInsets.all(8.h),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray10001,
    );
  }

  /// Section Widget
  Widget _buildReplay2(BuildContext context) {
    return CustomTextFormField(
      controller: replayController2,
      hintText: "Replay",
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildViewMore(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Comments ",
                    style: CustomTextStyles.titleMediumff363333,
                  ),
                  TextSpan(
                    text: "(16)",
                    style: CustomTextStyles.bodyMediumffd20653,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 11.v),
          SizedBox(
            height: 712.v,
            width: 374.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: AppDecoration.fillOnPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 204.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle1240x40,
                              height: 40.adaptSize,
                              width: 40.adaptSize,
                              radius: BorderRadius.circular(
                                20.h,
                              ),
                              margin: EdgeInsets.only(bottom: 52.v),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFrame1(
                                      context,
                                      dynamicText: "ali Ali",
                                    ),
                                    SizedBox(height: 5.v),
                                    _buildVeryNiceProduct(context),
                                    SizedBox(height: 8.v),
                                    _buildH(
                                      context,
                                      dynamicText: "8h",
                                      dynamicText1: "replay",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.v),
                        Padding(
                          padding: EdgeInsets.only(left: 48.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRectangle1232x32,
                                height: 32.adaptSize,
                                width: 32.adaptSize,
                                radius: BorderRadius.circular(
                                  16.h,
                                ),
                                margin: EdgeInsets.only(bottom: 87.v),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ali Ali",
                                            style: CustomTextStyles
                                                .titleMediumBluegray900Medium,
                                          ),
                                          CustomImageView(
                                            imagePath:
                                                ImageConstant.imgNotification,
                                            height: 20.adaptSize,
                                            width: 20.adaptSize,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.v),
                                      Container(
                                        width: 286.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7.h,
                                          vertical: 5.v,
                                        ),
                                        decoration: AppDecoration.outlinePrimary
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.customBorderBL8,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 2.v),
                                            Container(
                                              width: 252.h,
                                              margin:
                                                  EdgeInsets.only(right: 17.h),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Very ",
                                                      style: CustomTextStyles
                                                          .bodyMediumff333333,
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "nice product Very nice product Very nice |",
                                                      style: CustomTextStyles
                                                          .bodyMediumff333333,
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.v),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 160.h,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2.v),
                                                  child: Text(
                                                    "8h",
                                                    style: theme
                                                        .textTheme.bodySmall,
                                                  ),
                                                ),
                                                CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgUserBlueGray90001,
                                                  height: 18.adaptSize,
                                                  width: 18.adaptSize,
                                                  margin: EdgeInsets.only(
                                                    left: 13.h,
                                                    bottom: 2.v,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.h),
                                                  child: Text(
                                                    "replay",
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ),
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgEdit,
                                                  height: 18.adaptSize,
                                                  width: 18.adaptSize,
                                                  margin: EdgeInsets.only(
                                                    left: 12.h,
                                                    bottom: 2.v,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 8.h,
                                                    bottom: 1.v,
                                                  ),
                                                  child: Text(
                                                    "Edit",
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomImageView(
                                            imagePath:
                                                ImageConstant.imgThumbsUp,
                                            height: 18.adaptSize,
                                            width: 18.adaptSize,
                                            margin: EdgeInsets.only(
                                              left: 12.h,
                                              bottom: 2.v,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.h),
                                            child: Text(
                                              "Delete",
                                              style: CustomTextStyles
                                                  .bodyMediumRed500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgEllipse132x32,
                              height: 32.adaptSize,
                              width: 32.adaptSize,
                              radius: BorderRadius.circular(
                                16.h,
                              ),
                              margin: EdgeInsets.only(bottom: 38.v),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Eman Elsherbiny",
                                      style: CustomTextStyles
                                          .titleMediumBluegray900Medium,
                                    ),
                                    SizedBox(height: 7.v),
                                    _buildReplay(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.v),
                        Divider(),
                        SizedBox(height: 6.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle1240x40,
                              height: 40.adaptSize,
                              width: 40.adaptSize,
                              radius: BorderRadius.circular(
                                20.h,
                              ),
                              margin: EdgeInsets.only(bottom: 52.v),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFrame1(
                                      context,
                                      dynamicText: "ali Ali",
                                    ),
                                    SizedBox(height: 5.v),
                                    _buildVeryNiceProduct1(context),
                                    SizedBox(height: 7.v),
                                    Row(
                                      children: [
                                        _buildH(
                                          context,
                                          dynamicText: "8h",
                                          dynamicText1: "replay",
                                        ),
                                        Container(
                                          width: 51.h,
                                          margin: EdgeInsets.only(
                                            left: 12.h,
                                            bottom: 1.v,
                                          ),
                                          child: Row(
                                            children: [
                                              CustomImageView(
                                                imagePath:
                                                    ImageConstant.imgEdit,
                                                height: 18.adaptSize,
                                                width: 18.adaptSize,
                                                margin: EdgeInsets.only(
                                                    bottom: 1.v),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.h),
                                                child: Text(
                                                  "Edit",
                                                  style: theme
                                                      .textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 12.h,
                                            bottom: 1.v,
                                          ),
                                          child: _buildContent(
                                            context,
                                            deleteText: "Delete",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgEllipse132x32,
                              height: 32.adaptSize,
                              width: 32.adaptSize,
                              radius: BorderRadius.circular(
                                16.h,
                              ),
                              margin: EdgeInsets.only(bottom: 38.v),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Eman Elsherbiny",
                                      style: CustomTextStyles
                                          .titleMediumBluegray900Medium,
                                    ),
                                    SizedBox(height: 7.v),
                                    _buildReplay1(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgRectangle1240x40,
                            height: 40.adaptSize,
                            width: 40.adaptSize,
                            radius: BorderRadius.circular(
                              20.h,
                            ),
                            margin: EdgeInsets.only(bottom: 52.v),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFrame1(
                                    context,
                                    dynamicText: "ali Ali",
                                  ),
                                  SizedBox(height: 5.v),
                                  _buildFrame10(context),
                                  SizedBox(height: 7.v),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.v),
                                        child: Text(
                                          "8h",
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgUserBlueGray90001,
                                        height: 18.adaptSize,
                                        width: 18.adaptSize,
                                        margin: EdgeInsets.only(
                                          left: 13.h,
                                          bottom: 2.v,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.h),
                                        child: Text(
                                          "replay",
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      CustomImageView(
                                        imagePath: ImageConstant.imgEdit,
                                        height: 18.adaptSize,
                                        width: 18.adaptSize,
                                        margin: EdgeInsets.only(
                                          left: 12.h,
                                          bottom: 2.v,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.h,
                                          bottom: 1.v,
                                        ),
                                        child: Text(
                                          "Edit",
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 12.h,
                                          bottom: 1.v,
                                        ),
                                        child: _buildContent(
                                          context,
                                          deleteText: "Delete",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse132x32,
                            height: 32.adaptSize,
                            width: 32.adaptSize,
                            radius: BorderRadius.circular(
                              16.h,
                            ),
                            margin: EdgeInsets.only(bottom: 38.v),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Eman Elsherbiny",
                                    style: CustomTextStyles
                                        .titleMediumBluegray900Medium,
                                  ),
                                  SizedBox(height: 7.v),
                                  _buildReplay2(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17.v),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 23.v),
          Text(
            "View More",
            style: CustomTextStyles.titleSmallPrimary_1,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRelated(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Related",
          style: theme.textTheme.titleLarge,
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.v),
          child: Text(
            "See more",
            style: CustomTextStyles.titleSmallPrimary_1,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 247.v,
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.h,
      ),
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Userprofile1ItemWidget();
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

  /// Common widget
  Widget _buildNegotiableButton(
    BuildContext context, {
    required String carsText,
    required String dateText,
    required String mercedesBenz,
    required String locationText,
    required String priceText,
  }) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.customBorderBL12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                carsText,
                textAlign: TextAlign.justify,
                style: CustomTextStyles.bodySmallOrange400.copyWith(
                  color: appTheme.orange400,
                ),
              ),
              Text(
                dateText,
                style: CustomTextStyles.bodySmall10.copyWith(
                  color: appTheme.gray60001,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.v),
          Text(
            mercedesBenz,
            textAlign: TextAlign.justify,
            style: CustomTextStyles.titleSmallSemiBold.copyWith(
              color: appTheme.blueGray90001,
            ),
          ),
          SizedBox(height: 4.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgLinkedin,
                height: 16.adaptSize,
                width: 16.adaptSize,
                margin: EdgeInsets.symmetric(vertical: 3.v),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(
                  locationText,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: appTheme.blueGray90001,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.v),
          Text(
            priceText,
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildFrame(
    BuildContext context, {
    required String descriptionText,
    required String translateText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.v),
          child: Text(
            descriptionText,
            style: CustomTextStyles.titleMediumBluegray900.copyWith(
              color: appTheme.blueGray900,
            ),
          ),
        ),
        Container(
          width: 133.h,
          padding: EdgeInsets.symmetric(
            horizontal: 3.h,
            vertical: 2.v,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder4,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Translate ",
                  style: CustomTextStyles.titleSmallffd20653,
                ),
                TextSpan(
                  text: "to English",
                  style: CustomTextStyles.titleSmallffd20653,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildFrame1(
    BuildContext context, {
    required String dynamicText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dynamicText,
          style: CustomTextStyles.titleMediumBluegray900Medium.copyWith(
            color: appTheme.blueGray900,
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgNotification,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildH(
    BuildContext context, {
    required String dynamicText,
    required String dynamicText1,
  }) {
    return SizedBox(
      width: 97.h,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 3.v),
            child: Text(
              dynamicText,
              style: theme.textTheme.bodySmall!.copyWith(
                color: appTheme.gray60001,
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgUserBlueGray90001,
            height: 18.adaptSize,
            width: 18.adaptSize,
            margin: EdgeInsets.only(
              left: 13.h,
              bottom: 2.v,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              dynamicText1,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: appTheme.blueGray90001,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildContent(
    BuildContext context, {
    required String deleteText,
  }) {
    return SizedBox(
      width: 68.h,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUp,
            height: 18.adaptSize,
            width: 18.adaptSize,
            margin: EdgeInsets.only(bottom: 1.v),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              deleteText,
              style: CustomTextStyles.bodyMediumRed500.copyWith(
                color: appTheme.red500,
              ),
            ),
          ),
        ],
      ),
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
