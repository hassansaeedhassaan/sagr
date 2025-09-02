import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';

import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomeTwoScreen extends StatelessWidget {
  HomeTwoScreen({Key? key}) : super(key: key);

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList1 = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList2 = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList3 = ["Item One", "Item Two", "Item Three"];

  List<String> dropdownItemList4 = ["Item One", "Item Two", "Item Three"];

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(context),
            body: SizedBox(
                width: double.maxFinite,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 12.v),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              child: Column(children: [
                                _buildFrameRow(context,
                                    dynamicText: "Categories",
                                    dynamicText1: "See more"),
                                SizedBox(height: 10.v),
                                _buildFrameRow2(context),
                                SizedBox(height: 22.v),
                                _buildFrameRow(context,
                                    dynamicText: "Feature ads",
                                    dynamicText1: "See more"),
                                SizedBox(height: 11.v),
                                _buildNearByRow(context),
                                SizedBox(height: 8.v),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(children: [
                                      CustomDropDown(
                                          width: 124.h,
                                          icon: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8.h,
                                                  vertical: 9.v),
                                              child: CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgArrowdownGray60001,
                                                  height: 16.adaptSize,
                                                  width: 16.adaptSize)),
                                          hintText: "Most viewed",
                                          items: dropdownItemList2,
                                          onChanged: (value) {}),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: CustomIconButton(
                                              height: 35.v,
                                              width: 40.h,
                                              padding: EdgeInsets.all(5.h),
                                              decoration: IconButtonStyleHelper
                                                  .fillOnPrimary,
                                              child: CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgUser)))
                                    ])),
                                SizedBox(height: 12.v),
                                _buildStack(context),
                                SizedBox(height: 18.v),
                                _buildFrameRow(context,
                                    dynamicText: "Latest ads",
                                    dynamicText1: "See more"),
                                SizedBox(height: 28.v),
                                CustomDropDown(
                                    width: 99.h,
                                    hintText: "Caregory",
                                    alignment: Alignment.centerLeft,
                                    items: dropdownItemList3,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.h, vertical: 3.v),
                                    borderDecoration:
                                        DropDownStyleHelper.fillOnPrimary1,
                                    onChanged: (value) {}),
                                SizedBox(height: 28.v),
                                Padding(
                                    padding: EdgeInsets.only(left: 107.h),
                                    child: CustomDropDown(
                                        width: 66.h,
                                        hintText: "City",
                                        alignment: Alignment.centerLeft,
                                        items: dropdownItemList4,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.h, vertical: 3.v),
                                        borderDecoration:
                                            DropDownStyleHelper.fillOnPrimary1,
                                        onChanged: (value) {})),
                                SizedBox(height: 28.v),
                                _buildButton(context),
                                SizedBox(height: 28.v),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        width: 114.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.h),
                                        decoration: AppDecoration.fillOnPrimary,
                                        child: Text("Avilable Photo",
                                            style:
                                                theme.textTheme.titleSmall))),
                                SizedBox(height: 71.v),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                        onTap: () {
                                          onTapDropdown(context);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.h),
                                            decoration:
                                                AppDecoration.fillOnPrimary,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 6.v),
                                                      child: Text("Most viewed",
                                                          style: theme.textTheme
                                                              .titleSmall)),
                                                  CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgArrowdownGray60001,
                                                      height: 1.v,
                                                      width: 16.h,
                                                      margin: EdgeInsets.only(
                                                          left: 8.h, top: 9.v))
                                                ])))),
                                SizedBox(height: 71.v),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        height: 1.v,
                                        width: 40.h,
                                        margin: EdgeInsets.only(left: 132.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.h),
                                        decoration: AppDecoration.fillOnPrimary,
                                        child: CustomImageView(
                                            imagePath: ImageConstant.imgMap,
                                            height: 1.v,
                                            width: 24.h,
                                            alignment: Alignment.topCenter,
                                            margin:
                                                EdgeInsets.only(top: 5.v)))),
                                SizedBox(height: 118.v),
                                _buildStack1(context)
                              ]))))
                ])),
            bottomNavigationBar: _buildBottomBar(context),
            floatingActionButton: _buildFab(context)));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        height: 70.v,
        leadingWidth: 54.h,
        leading: AppbarLeadingIconbutton(
            imagePath: ImageConstant.imgGlobe,
            margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v)),
        title: Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Row(children: [
              AppbarTitleIconbutton(
                  imagePath: ImageConstant.imgSearch141BlueGray90001),
              AppbarTitleImage(
                  imagePath: ImageConstant.imgLayer1,
                  margin: EdgeInsets.only(left: 60.h, top: 2.v, bottom: 3.v))
            ])),
        actions: [
          AppbarTrailingIconbutton(
              imagePath: ImageConstant.imgVuesaxTwotoneNotification,
              margin: EdgeInsets.only(left: 15.h, top: 16.v, right: 16.h)),
          AppbarTrailingIconbutton(
              imagePath: ImageConstant.imgClockPrimary,
              margin: EdgeInsets.only(left: 8.h, top: 16.v, right: 31.h))
        ],
        styleType: Style.bgFill);
  }

  /// Section Widget
  Widget _buildFrameRow2(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // GridView.builder(
      //     shrinkWrap: true,
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //         mainAxisExtent: 93.v,
      //         crossAxisCount: 3,
      //         mainAxisSpacing: 12.h,
      //         crossAxisSpacing: 12.h),
      //     physics: NeverScrollableScrollPhysics(),
      //     itemCount: 6,
      //     itemBuilder: (context, index) {
      //       return Category2ItemWidget();
      //     }),
      // GridView.builder(
      //     shrinkWrap: true,
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //         mainAxisExtent: 93.v,
      //         crossAxisCount: 2,
      //         mainAxisSpacing: 12.h,
      //         crossAxisSpacing: 12.h),
      //     physics: NeverScrollableScrollPhysics(),
      //     itemCount: 4,
      //     itemBuilder: (context, index) {
      //       return Category3ItemWidget();
      //     })
    ]);
  }

  /// Section Widget
  Widget _buildNearBy(BuildContext context) {
    return CustomOutlinedButton(
        height: 35.v,
        width: 95.h,
        text: "Near by",
        rightIcon: Container(
            margin: EdgeInsets.only(left: 8.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgClose,
                height: 20.adaptSize,
                width: 20.adaptSize)),
        buttonStyle: CustomButtonStyles.outlineOrange,
        buttonTextStyle: CustomTextStyles.titleSmallOrange400);
  }

  /// Section Widget
  Widget _buildAvilablePhoto(BuildContext context) {
    return CustomElevatedButton(
        height: 35.v,
        width: 114.h,
        text: "Avilable Photo",
        buttonStyle: CustomButtonStyles.fillOnPrimary,
        buttonTextStyle: theme.textTheme.titleSmall!);
  }

  /// Section Widget
  Widget _buildNearByRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CustomDropDown(
          width: 99.h,
          icon: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
              child: CustomImageView(
                  imagePath: ImageConstant.imgArrowdownGray60001,
                  height: 16.adaptSize,
                  width: 16.adaptSize)),
          hintText: "Caregory",
          items: dropdownItemList,
          onChanged: (value) {}),
      CustomDropDown(
          width: 66.h,
          icon: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 9.v),
              child: CustomImageView(
                  imagePath: ImageConstant.imgArrowdownGray60001,
                  height: 16.adaptSize,
                  width: 16.adaptSize)),
          hintText: "City",
          items: dropdownItemList1,
          onChanged: (value) {}),
      _buildNearBy(context),
      _buildAvilablePhoto(context)
    ]);
  }

  /// Section Widget
  Widget _buildStack(BuildContext context) {
    return SizedBox(
        height: 258.v,
        width: 398.h,
        child: Stack(alignment: Alignment.center, children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(left: 181.h, right: 44.h),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _buildSeventySix(context, negotiableText: "Negotiable"),
                    _buildFrame(context,
                        cars: "#cars",
                        inVar: " in 22/1/2023",
                        mercedesBenz: "Mercedes-Benz ",
                        location: "Dakahlia, Mansoura",
                        price: "1000 EGP")
                  ]))),
          Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                      child: GestureDetector(
                          onTap: () {
                            onTapFrameColumn(context);
                          },
                          child: Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 147.v,
                                      width: 173.h,
                                      child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgRectangle12,
                                                height: 147.v,
                                                width: 173.h,
                                                radius: BorderRadius.vertical(
                                                    top: Radius.circular(12.h)),
                                                alignment: Alignment.center),
                                            Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.v),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomIconButton(
                                                              height:
                                                                  28.adaptSize,
                                                              width:
                                                                  28.adaptSize,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.h),
                                                              child: CustomImageView(
                                                                  imagePath:
                                                                      ImageConstant
                                                                          .imgFavorite)),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          8.h),
                                                              child: CustomIconButton(
                                                                  height: 28
                                                                      .adaptSize,
                                                                  width: 28
                                                                      .adaptSize,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: CustomImageView(
                                                                      imagePath:
                                                                          ImageConstant
                                                                              .imgGroup58519))),
                                                          Container(
                                                              width: 80.h,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          13.h),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.h,
                                                                      vertical:
                                                                          4.v),
                                                              decoration: AppDecoration
                                                                  .fillTealA
                                                                  .copyWith(
                                                                      borderRadius:
                                                                          BorderRadiusStyle
                                                                              .roundedBorder8),
                                                              child: Text(
                                                                  "Negotiable",
                                                                  style: CustomTextStyles
                                                                      .labelLargeOnPrimary))
                                                        ])))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(left: 189.h),
                                      child: _buildSeventySix(context,
                                          negotiableText: "Negotiable"))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildFrame(context,
                                      cars: "#cars",
                                      inVar: " in 22/1/2023",
                                      mercedesBenz: "Mercedes-Benz ",
                                      location: "Dakahlia, Mansoura",
                                      price: "1000 EGP"),
                                  Container(
                                      margin: EdgeInsets.only(left: 189.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.h, vertical: 6.v),
                                      decoration: AppDecoration.fillOnPrimary
                                          .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .customBorderBL12),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildFrame1(context,
                                                cars: "#cars",
                                                inVar: " in 22/1/2023"),
                                            SizedBox(height: 1.v),
                                            Text("Mercedes-Benz ",
                                                textAlign: TextAlign.justify,
                                                style: CustomTextStyles
                                                    .titleSmallSemiBold),
                                            SizedBox(height: 5.v),
                                            Row(children: [
                                              CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgLinkedin,
                                                  height: 16.adaptSize,
                                                  width: 16.adaptSize,
                                                  margin: EdgeInsets.only(
                                                      top: 1.v, bottom: 2.v)),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.h),
                                                  child: Text(
                                                      "Dakahlia, Mansoura",
                                                      style: theme.textTheme
                                                          .bodyMedium))
                                            ]),
                                            SizedBox(height: 10.v),
                                            Text("1000 EGP",
                                                style:
                                                    theme.textTheme.titleMedium)
                                          ]))
                                ])
                          ])))))
        ]));
  }

  /// Section Widget
  Widget _buildButton(BuildContext context) {
    return CustomOutlinedButton(
        height: 1.v,
        width: 95.h,
        text: "Near by",
        margin: EdgeInsets.only(right: 122.h),
        buttonStyle: CustomButtonStyles.outlineOrange1,
        buttonTextStyle: CustomTextStyles.titleSmallOrange400,
        alignment: Alignment.centerRight);
  }

  /// Section Widget
  Widget _buildNegotiable(BuildContext context) {
    return CustomElevatedButton(
        height: 28.v,
        width: 80.h,
        text: "Negotiable",
        buttonStyle: CustomButtonStyles.fillTealA,
        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary);
  }

  /// Section Widget
  Widget _buildStack1(BuildContext context) {
    return SizedBox(
        height: 258.v,
        width: 398.h,
        child: Stack(alignment: Alignment.topRight, children: [
          Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          _buildSeventyEight(context,
                              negotiableText: "Negotiable"),
                          Container(
                              height: 147.v,
                              width: 173.h,
                              margin: EdgeInsets.only(left: 189.h),
                              child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgRectangle12,
                                        height: 147.v,
                                        width: 173.h,
                                        radius: BorderRadius.vertical(
                                            top: Radius.circular(12.h)),
                                        alignment: Alignment.center),
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                            width: 157.h,
                                            margin: EdgeInsets.fromLTRB(
                                                8.h, 8.v, 8.h, 111.v),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomIconButton(
                                                      height: 28.adaptSize,
                                                      width: 28.adaptSize,
                                                      padding:
                                                          EdgeInsets.all(4.h),
                                                      child: CustomImageView(
                                                          imagePath:
                                                              ImageConstant
                                                                  .imgFavorite)),
                                                  _buildNegotiable(context)
                                                ])))
                                  ]))
                        ]),
                        Padding(
                            padding: EdgeInsets.only(right: 225.h),
                            child: _buildFrame2(context,
                                cars: "#cars",
                                inVar: " in 22/1/2023",
                                mercedesBenz: "Mercedes-Benz ",
                                location: "Dakahlia, Mansoura",
                                price: "1000 EGP")),
                        SizedBox(height: 265.v),
                        Padding(
                            padding: EdgeInsets.only(left: 362.h),
                            child: _buildFrame2(context,
                                cars: "#cars",
                                inVar: " in 22/1/2023",
                                mercedesBenz: "Mercedes-Benz ",
                                location: "Dakahlia, Mansoura",
                                price: "1000 EGP"))
                      ])))),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(left: 181.h, right: 44.h),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _buildSeventyEight(context, negotiableText: "Negotiable"),
                    _buildFrame2(context,
                        cars: "#cars",
                        inVar: " in 22/1/2023",
                        mercedesBenz: "Mercedes-Benz ",
                        location: "Dakahlia, Mansoura",
                        price: "1000 EGP")
                  ])))
        ]));
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
    });
  }

  /// Section Widget
  Widget _buildFab(BuildContext context) {
    return CustomFloatingButton(
        height: 50,
        width: 50,
        child: CustomImageView(
            imagePath: ImageConstant.imgFilter, height: 25.0.v, width: 25.0.h));
  }

  /// Common widget
  Widget _buildFrameRow(
    BuildContext context, {
    required String dynamicText,
    required String dynamicText1,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(dynamicText,
          style: theme.textTheme.titleLarge!
              .copyWith(color: appTheme.blueGray90001)),
      Padding(
          padding: EdgeInsets.only(top: 8.v),
          child: Text(dynamicText1,
              style: CustomTextStyles.titleSmallPrimary_1
                  .copyWith(color: theme.colorScheme.primary)))
    ]);
  }

  /// Common widget
  Widget _buildSeventySix(
    BuildContext context, {
    required String negotiableText,
  }) {
    return SizedBox(
        height: 147.v,
        width: 173.h,
        child: Stack(alignment: Alignment.topCenter, children: [
          CustomImageView(
              imagePath: ImageConstant.imgRectangle12,
              height: 147.v,
              width: 173.h,
              radius: BorderRadius.vertical(top: Radius.circular(12.h)),
              alignment: Alignment.center),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: 157.h,
                  margin: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite)),
                        Container(
                            width: 80.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.h, vertical: 4.v),
                            decoration: AppDecoration.fillTealA.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8),
                            child: Text(negotiableText,
                                style: CustomTextStyles.labelLargeOnPrimary
                                    .copyWith(
                                        color: theme.colorScheme.onPrimary
                                            .withOpacity(1))))
                      ])))
        ]));
  }

  /// Common widget
  Widget _buildFrame(
    BuildContext context, {
    required String cars,
    required String inVar,
    required String mercedesBenz,
    required String location,
    required String price,
  }) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.v),
        decoration: AppDecoration.fillOnPrimary
            .copyWith(borderRadius: BorderRadiusStyle.customBorderBL12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 155.h,
                  margin: EdgeInsets.only(right: 1.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cars,
                            style: CustomTextStyles.bodySmallOrange400
                                .copyWith(color: appTheme.orange400)),
                        Text(inVar,
                            style: CustomTextStyles.bodySmall10
                                .copyWith(color: appTheme.gray60001))
                      ])),
              SizedBox(height: 1.v),
              Text(mercedesBenz,
                  style: CustomTextStyles.titleSmallSemiBold
                      .copyWith(color: appTheme.blueGray90001)),
              SizedBox(height: 5.v),
              Row(children: [
                CustomImageView(
                    imagePath: ImageConstant.imgLinkedin,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(top: 1.v, bottom: 2.v)),
                Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(location,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: appTheme.blueGray90001)))
              ]),
              SizedBox(height: 10.v),
              Text(price,
                  style: theme.textTheme.titleMedium!
                      .copyWith(color: theme.colorScheme.primary))
            ]));
  }

  /// Common widget
  Widget _buildFrame1(
    BuildContext context, {
    required String cars,
    required String inVar,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(cars,
          textAlign: TextAlign.justify,
          style: CustomTextStyles.bodySmallOrange400
              .copyWith(color: appTheme.orange400)),
      Text(inVar,
          style:
              CustomTextStyles.bodySmall10.copyWith(color: appTheme.gray60001))
    ]);
  }

  /// Common widget
  Widget _buildFrame2(
    BuildContext context, {
    required String cars,
    required String inVar,
    required String mercedesBenz,
    required String location,
    required String price,
  }) {
    return Container(
        padding: EdgeInsets.all(8.h),
        decoration: AppDecoration.fillOnPrimary
            .copyWith(borderRadius: BorderRadiusStyle.customBorderBL12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(cars,
                textAlign: TextAlign.justify,
                style: CustomTextStyles.bodySmallOrange400
                    .copyWith(color: appTheme.orange400)),
            Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(inVar,
                    style: CustomTextStyles.bodySmall10
                        .copyWith(color: appTheme.gray60001)))
          ]),
          SizedBox(height: 2.v),
          Text(mercedesBenz,
              textAlign: TextAlign.justify,
              style: CustomTextStyles.titleSmallSemiBold
                  .copyWith(color: appTheme.blueGray90001)),
          SizedBox(height: 4.v),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomImageView(
                imagePath: ImageConstant.imgLinkedin,
                height: 16.adaptSize,
                width: 16.adaptSize,
                margin: EdgeInsets.symmetric(vertical: 3.v)),
            Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: Text(location,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: appTheme.blueGray90001)))
          ]),
          SizedBox(height: 12.v),
          Text(price,
              style: theme.textTheme.titleMedium!
                  .copyWith(color: theme.colorScheme.primary))
        ]));
  }

  /// Common widget
  Widget _buildSeventyEight(
    BuildContext context, {
    required String negotiableText,
  }) {
    return SizedBox(
        height: 147.v,
        width: 173.h,
        child: Stack(alignment: Alignment.topCenter, children: [
          CustomImageView(
              imagePath: ImageConstant.imgRectangle12,
              height: 147.v,
              width: 173.h,
              radius: BorderRadius.vertical(top: Radius.circular(12.h)),
              alignment: Alignment.center),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite)),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.h, vertical: 4.v),
                            decoration: AppDecoration.fillTealA.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder8),
                            child: Text(negotiableText,
                                style: CustomTextStyles.labelLargeOnPrimary
                                    .copyWith(
                                        color: theme.colorScheme.onPrimary
                                            .withOpacity(1))))
                      ])))
        ]));
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      // case BottomBarEnum.Home:
      //   return AppRoutes.featureAdsPage;
      // case BottomBarEnum.Category:
      //   return AppRoutes.categoryPage;
      // case BottomBarEnum.Message:
        // return "/";
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

  /// Navigates to the adsDetailsOneScreen when the action is triggered.
  onTapFrameColumn(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.adsDetailsOneScreen);
  }

  /// Navigates to the filterThreeScreen when the action is triggered.
  onTapDropdown(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.filterThreeScreen);
  }
}
