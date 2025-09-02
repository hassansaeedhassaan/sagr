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
import 'package:flutter/material.dart';

class AdsDetailsThreeScreen extends StatelessWidget {
  AdsDetailsThreeScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController searchController = TextEditingController();

  TextEditingController replayValueEditTextController = TextEditingController();

  TextEditingController replayValueEditTextController1 =
      TextEditingController();

  TextEditingController replayValueEditTextController2 =
      TextEditingController();

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
            child: Column(
              children: [
                _buildComponent(context),
                SizedBox(height: 16.v),
                _buildNegotiable(context),
              ],
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
  Widget _buildNegotiableButton(BuildContext context) {
    return CustomElevatedButton(
      height: 28.v,
      width: 80.h,
      text: "Negotiable",
      buttonStyle: CustomButtonStyles.fillTealA,
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildNegotiableButton1(BuildContext context) {
    return CustomElevatedButton(
      height: 28.v,
      width: 80.h,
      text: "Negotiable",
      buttonStyle: CustomButtonStyles.fillTealA,
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildChatButton(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        height: 45.v,
        text: "Chat ",
        margin: EdgeInsets.only(right: 4.h),
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
      ),
    );
  }

  /// Section Widget
  Widget _buildWhatsUpButton(BuildContext context) {
    return Expanded(
      child: CustomOutlinedButton(
        text: "What's up ",
        margin: EdgeInsets.only(left: 4.h),
        leftIcon: Container(
          margin: EdgeInsets.only(right: 8.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgVolume,
            height: 22.adaptSize,
            width: 22.adaptSize,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildReplayValueEditText(BuildContext context) {
    return CustomTextFormField(
      controller: replayValueEditTextController,
      hintText: "Replay",
      contentPadding: EdgeInsets.all(12.h),
    );
  }

  /// Section Widget
  Widget _buildReplayValueEditText1(BuildContext context) {
    return CustomTextFormField(
      controller: replayValueEditTextController1,
      hintText: "Replay",
      contentPadding: EdgeInsets.all(12.h),
    );
  }

  /// Section Widget
  Widget _buildReplayValueEditText2(BuildContext context) {
    return CustomTextFormField(
      controller: replayValueEditTextController2,
      hintText: "Replay",
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.all(12.h),
    );
  }

  /// Section Widget
  Widget _buildNegotiable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 343.v,
                bottom: 893.v,
              ),
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
                  _buildFrame(
                    context,
                    carText: "#cars",
                    dateText: " in 22/1/2023",
                    brandText: "Mercedes-Benz ",
                    locationText: "Dakahlia, Mansoura",
                    priceText: "1000 EGP",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                top: 343.v,
                bottom: 893.v,
              ),
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
                                _buildNegotiableButton(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildFrame(
                    context,
                    carText: "#cars",
                    dateText: " in 22/1/2023",
                    brandText: "Mercedes-Benz ",
                    locationText: "Dakahlia, Mansoura",
                    priceText: "1000 EGP",
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 16.h),
                child: Column(
                  children: [
                    SizedBox(
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 4.h,
                                      right: 5.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 136.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4.h),
                                                  child: CustomIconButton(
                                                    height: 28.adaptSize,
                                                    width: 28.adaptSize,
                                                    padding:
                                                        EdgeInsets.all(4.h),
                                                    child: CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgFavorite,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.h),
                                                  child: CustomIconButton(
                                                    height: 28.adaptSize,
                                                    width: 28.adaptSize,
                                                    padding:
                                                        EdgeInsets.all(5.h),
                                                    child: CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgGroup58519,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.h),
                                                  child: CustomIconButton(
                                                    height: 28.adaptSize,
                                                    width: 28.adaptSize,
                                                    padding:
                                                        EdgeInsets.all(5.h),
                                                    child: CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgVuesaxLinearFlag,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.h),
                                                  child: CustomIconButton(
                                                    height: 28.adaptSize,
                                                    width: 28.adaptSize,
                                                    padding:
                                                        EdgeInsets.all(5.h),
                                                    child: CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgSearch,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _buildNegotiableButton1(context),
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
                                        margin: EdgeInsets.symmetric(
                                            vertical: 22.v),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8.h),
                                          padding: EdgeInsets.all(4.h),
                                          decoration: AppDecoration
                                              .fillOnPrimary1
                                              .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle457,
                                                height: 60.v,
                                                width: 59.h,
                                                radius: BorderRadius.circular(
                                                  8.h,
                                                ),
                                              ),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle462,
                                                height: 60.v,
                                                width: 59.h,
                                                radius: BorderRadius.circular(
                                                  8.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(left: 4.h),
                                              ),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle459,
                                                height: 60.v,
                                                width: 59.h,
                                                radius: BorderRadius.circular(
                                                  8.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(left: 4.h),
                                              ),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle462,
                                                height: 60.v,
                                                width: 59.h,
                                                radius: BorderRadius.circular(
                                                  8.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(left: 4.h),
                                              ),
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle459,
                                                height: 60.v,
                                                width: 59.h,
                                                radius: BorderRadius.circular(
                                                  8.h,
                                                ),
                                                margin:
                                                    EdgeInsets.only(left: 4.h),
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
                    ),
                    SizedBox(height: 12.v),
                    Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "#cars",
                                      style:
                                          CustomTextStyles.bodySmallOrange400,
                                    ),
                                    SizedBox(height: 2.v),
                                    SizedBox(
                                      width: 274.h,
                                      child: Text(
                                        "Mercedes-Benz E200 2024 AMG Fully Loaded",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                        style: CustomTextStyles
                                            .titleMediumBluegray90001Medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.h,
                                  bottom: 22.v,
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 1.h),
                                        child: Text(
                                          " in 22/1/2023",
                                          style: CustomTextStyles.bodySmall10,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "1000 EGP",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                          imagePath: ImageConstant
                                              .imgLinkedinGray60001,
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
                                            style: CustomTextStyles
                                                .bodySmallBluegray90001,
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
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildChatButton(context),
                                    _buildWhatsUpButton(context),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: CustomIconButton(
                                  height: 45.adaptSize,
                                  width: 45.adaptSize,
                                  padding: EdgeInsets.all(11.h),
                                  decoration: IconButtonStyleHelper.outlinePink,
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgCall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.v),
                    Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2.v),
                                child: Text(
                                  "Description",
                                  style:
                                      CustomTextStyles.titleMediumBluegray900,
                                ),
                              ),
                              Container(
                                width: 133.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.h,
                                  vertical: 2.v,
                                ),
                                decoration:
                                    AppDecoration.fillOnPrimary.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder4,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Translate ",
                                        style:
                                            CustomTextStyles.titleSmallffd20653,
                                      ),
                                      TextSpan(
                                        text: "to English",
                                        style:
                                            CustomTextStyles.titleSmallffd20653,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.v),
                          SizedBox(
                            width: 374.h,
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, \\magna aliqua.Lorem ipsum dolor sit amet, con\\sed.",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              style:
                                  CustomTextStyles.bodyLargeGray60001.copyWith(
                                height: 1.50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.v),
                    Container(
                      padding: EdgeInsets.all(12.h),
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
                          SizedBox(height: 12.v),
                          Container(
                            decoration: AppDecoration.fillOnPrimary.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder12,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildFrame3(
                                  context,
                                  text1: "ali Ali",
                                  text2: "Very nice product",
                                  text3: "8h",
                                  text4: "replay",
                                  text5: "Edit",
                                  text6: "Delete",
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
                                          children: [
                                            Text(
                                              "Eman Elsherbiny",
                                              style: CustomTextStyles
                                                  .titleMediumBluegray900Medium,
                                            ),
                                            SizedBox(height: 8.v),
                                            _buildReplayValueEditText(context),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 17.v),
                                Divider(),
                                SizedBox(height: 7.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                      imagePath:
                                          ImageConstant.imgRectangle1240x40,
                                      height: 40.adaptSize,
                                      width: 40.adaptSize,
                                      radius: BorderRadius.circular(
                                        20.h,
                                      ),
                                      margin: EdgeInsets.only(bottom: 53.v),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildFrame1(
                                              context,
                                              dynamicText: "ali Ali",
                                            ),
                                            SizedBox(height: 5.v),
                                            Container(
                                              width: 326.h,
                                              padding: EdgeInsets.all(8.h),
                                              decoration: AppDecoration.fillGray
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .customBorderBL8,
                                              ),
                                              child: Text(
                                                "Very nice product",
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ),
                                            SizedBox(height: 5.v),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.v),
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
                                                    left: 12.h,
                                                    top: 3.v,
                                                    bottom: 3.v,
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
                                              ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgRectangle1232x32,
                                        height: 32.adaptSize,
                                        width: 32.adaptSize,
                                        radius: BorderRadius.circular(
                                          16.h,
                                        ),
                                        margin: EdgeInsets.only(bottom: 88.v),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "ali Ali",
                                                    style: CustomTextStyles
                                                        .titleMediumBluegray900Medium,
                                                  ),
                                                  CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgNotification,
                                                    height: 20.adaptSize,
                                                    width: 20.adaptSize,
                                                    margin: EdgeInsets.only(
                                                        left: 5.h),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.v),
                                              Container(
                                                padding: EdgeInsets.all(7.h),
                                                decoration: AppDecoration
                                                    .outlinePrimary
                                                    .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .customBorderBL8,
                                                ),
                                                child: SizedBox(
                                                  width: 270.h,
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
                                              ),
                                              SizedBox(height: 8.v),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 46.h),
                                                child: _buildFrame2(
                                                  context,
                                                  h: "8h",
                                                  replay: "replay",
                                                  edit: "Edit",
                                                  deleteImage: "Delete",
                                                ),
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
                                          children: [
                                            Text(
                                              "Eman Elsherbiny",
                                              style: CustomTextStyles
                                                  .titleMediumBluegray900Medium,
                                            ),
                                            SizedBox(height: 8.v),
                                            _buildReplayValueEditText1(context),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.v),
                                Divider(),
                                SizedBox(height: 7.v),
                                _buildFrame3(
                                  context,
                                  text1: "ali Ali",
                                  text2: "Very nice product",
                                  text3: "8h",
                                  text4: "replay",
                                  text5: "Edit",
                                  text6: "Delete",
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
                                          children: [
                                            Text(
                                              "Eman Elsherbiny",
                                              style: CustomTextStyles
                                                  .titleMediumBluegray900Medium,
                                            ),
                                            SizedBox(height: 8.v),
                                            _buildReplayValueEditText2(context),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.v),
                          Text(
                            "View More",
                            style: CustomTextStyles.titleSmallPrimary_1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  /// Common widget
  Widget _buildFrame(
    BuildContext context, {
    required String carText,
    required String dateText,
    required String brandText,
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
          SizedBox(
            width: 179.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  carText,
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
          ),
          SizedBox(height: 2.v),
          Text(
            brandText,
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
  Widget _buildFrame1(
    BuildContext context, {
    required String dynamicText,
  }) {
    return Row(
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
          margin: EdgeInsets.only(left: 5.h),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildFrame2(
    BuildContext context, {
    required String h,
    required String replay,
    required String edit,
    required String deleteImage,
  }) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.v),
          child: Text(
            h,
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
            left: 12.h,
            top: 3.v,
            bottom: 3.v,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            replay,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: appTheme.blueGray90001,
            ),
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgEdit,
          height: 18.adaptSize,
          width: 18.adaptSize,
          margin: EdgeInsets.only(
            left: 12.h,
            top: 3.v,
            bottom: 3.v,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            edit,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: appTheme.blueGray90001,
            ),
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgThumbsUp,
          height: 18.adaptSize,
          width: 18.adaptSize,
          margin: EdgeInsets.only(
            left: 12.h,
            top: 3.v,
            bottom: 3.v,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: Text(
            deleteImage,
            style: CustomTextStyles.bodyMediumRed500.copyWith(
              color: appTheme.red500,
            ),
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildFrame3(
    BuildContext context, {
    required String text1,
    required String text2,
    required String text3,
    required String text4,
    required String text5,
    required String text6,
  }) {
    return Row(
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
          margin: EdgeInsets.only(bottom: 53.v),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text1,
                      style: CustomTextStyles.titleMediumBluegray900Medium
                          .copyWith(
                        color: appTheme.blueGray900,
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgNotification,
                      height: 20.adaptSize,
                      width: 20.adaptSize,
                      margin: EdgeInsets.only(left: 5.h),
                    ),
                  ],
                ),
                SizedBox(height: 5.v),
                Container(
                  width: 326.h,
                  padding: EdgeInsets.all(8.h),
                  decoration: AppDecoration.fillGray.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderBL8,
                  ),
                  child: Text(
                    text2,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: appTheme.blueGray90001,
                    ),
                  ),
                ),
                SizedBox(height: 5.v),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.v),
                      child: Text(
                        text3,
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
                        left: 12.h,
                        top: 3.v,
                        bottom: 3.v,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        text4,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: appTheme.blueGray90001,
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgEdit,
                      height: 18.adaptSize,
                      width: 18.adaptSize,
                      margin: EdgeInsets.only(
                        left: 12.h,
                        top: 3.v,
                        bottom: 3.v,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        text5,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: appTheme.blueGray90001,
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgThumbsUp,
                      height: 18.adaptSize,
                      width: 18.adaptSize,
                      margin: EdgeInsets.only(
                        left: 12.h,
                        top: 3.v,
                        bottom: 3.v,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        text6,
                        style: CustomTextStyles.bodyMediumRed500.copyWith(
                          color: appTheme.red500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
