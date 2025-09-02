import 'dart:async';
// import 'package:eltikia_s_application6/core/app_export.dart';
// import 'package:eltikia_s_application6/presentation/category_page/category_page.dart';
// import 'package:eltikia_s_application6/presentation/feature_ads_page/feature_ads_page.dart';
// import 'package:eltikia_s_application6/widgets/custom_bottom_bar.dart';
// import 'package:eltikia_s_application6/widgets/custom_drop_down.dart';
// import 'package:eltikia_s_application6/widgets/custom_elevated_button.dart';
// import 'package:eltikia_s_application6/widgets/custom_radio_button.dart';
// import 'package:eltikia_s_application6/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';

class ShareYourAddsScreen extends StatelessWidget {
  ShareYourAddsScreen({Key? key})
      : super(
          key: key,
        );

  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  List<String> dropdownItemList1 = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  List<String> dropdownItemList2 = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  Completer<GoogleMapController> googleMapController = Completer();

  String radioGroup = "";

  TextEditingController premiumController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTapSection(context),
                Container(
                  height: 6.v,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: appTheme.yellow50,
                    borderRadius: BorderRadius.circular(
                      3.h,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      3.h,
                    ),
                    child: LinearProgressIndicator(
                      value: 0.66,
                      backgroundColor: appTheme.yellow50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTheme.orange400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.v),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                    vertical: 11.v,
                  ),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add address info",
                        style: CustomTextStyles.titleMediumBluegray90001_1,
                      ),
                      SizedBox(height: 12.v),
                      CustomDropDown(
                        icon: Container(
                          margin: EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgCheckmarkGray50001,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        hintText: "Country",
                        hintStyle: theme.textTheme.bodyMedium!,
                        items: dropdownItemList,
                        contentPadding: EdgeInsets.only(
                          left: 16.h,
                          top: 15.v,
                          bottom: 15.v,
                        ),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 12.v),
                      CustomDropDown(
                        icon: Container(
                          margin: EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgCheckmarkGray50001,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        hintText: "state",
                        hintStyle: theme.textTheme.bodyMedium!,
                        items: dropdownItemList1,
                        contentPadding: EdgeInsets.only(
                          left: 16.h,
                          top: 15.v,
                          bottom: 15.v,
                        ),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 12.v),
                      CustomDropDown(
                        icon: Container(
                          margin: EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgCheckmarkGray50001,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        hintText: "City",
                        hintStyle: theme.textTheme.bodyMedium!,
                        items: dropdownItemList2,
                        contentPadding: EdgeInsets.only(
                          left: 16.h,
                          top: 15.v,
                          bottom: 15.v,
                        ),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 12.v),
                      _buildMapSection(context),
                      SizedBox(height: 12.v),
                      _buildFrameSection(context),
                      SizedBox(height: 12.v),
                      _buildFrameSection1(context),
                    ],
                  ),
                ),
                SizedBox(height: 30.v),
                _buildFrameSection2(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBarSection(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildTapSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgArrowDown,
            height: 24.v,
            width: 23.h,
            margin: EdgeInsets.symmetric(vertical: 3.v),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.h,
              top: 2.v,
            ),
            child: Text(
              "Share your adds",
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMapSection(BuildContext context) {
    return SizedBox(
      height: 224.v,
      width: 374.h,
      child: GoogleMap(
        //TODO: Add your Google Maps API key in AndroidManifest.xml and pod file
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            37.43296265331129,
            -122.08832357078792,
          ),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 6.h),
            child: CustomRadioButton(
              width: 181.h,
              text: "Normal ad",
              value: "Normal ad",
              groupValue: radioGroup,
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 13.v,
              ),
              textStyle: CustomTextStyles.titleMediumBluegray90001Medium,
              isRightCheck: true,
              onChange: (value) {
                radioGroup = value;
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6.h),
            child: CustomTextFormField(
              controller: premiumController,
              hintText: "Premium",
              hintStyle: CustomTextStyles.titleMediumBluegray90001Medium,
              textInputAction: TextInputAction.done,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(16.h, 13.v, 8.h, 13.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgVuesaxLinearCrown,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                ),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 50.v,
              ),
              suffix: Container(
                margin: EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgContrast,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
              ),
              suffixConstraints: BoxConstraints(
                maxHeight: 50.v,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14.v),
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildFrameSection1(BuildContext context) {
    return Container(
      width: 374.h,
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.gradientSecondaryContainerToOrange.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVuesaxTwotoneInfoCircle,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Be permium :",
                  style: CustomTextStyles.titleMediumBluegray90001Medium,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 7.h),
            child: Text(
              "Lorem ipsum dolor sit amet, ",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 7.h),
            child: Text(
              "Lorem ipsum dolor sit amet, ",
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameSection2(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.v),
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: "Previous",
              margin: EdgeInsets.only(right: 6.h),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles
                  .gradientSecondaryContainerToOrangeTL12Decoration,
              buttonTextStyle: theme.textTheme.titleMedium!,
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              text: "Next",
              margin: EdgeInsets.only(left: 6.h),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomBarSection(BuildContext context) {
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
