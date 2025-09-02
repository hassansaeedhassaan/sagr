
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_image_view.dart';
import '../home_one_screen/widgets/userprofilelist_item_widget.dart';

import 'package:flutter/material.dart';

class HomeOneScreen extends StatelessWidget {
  HomeOneScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 12.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      children: [
                        _buildCategoriesFrame(context),
                        SizedBox(height: 10.v),
                        _buildCategoryTextRow(context),
                        SizedBox(height: 24.v),
                        _buildUserProfileList(context),
                        SizedBox(height: 38.v),
                        _buildWidgetRow(context),
                        Padding(
                          padding: EdgeInsets.only(right: 203.h),
                          child: _buildHomeOneColumn(
                            context,
                            carName: "#cars",
                            date: " in 22/1/2023",
                            mercedesBenz: "Mercedes-Benz ",
                            locationText: "Dakahlia, Mansoura",
                            price: "1000 EGP",
                          ),
                        ),
                        SizedBox(height: 173.v),
                        Padding(
                          padding: EdgeInsets.only(left: 203.h),
                          child: _buildHomeOneColumn(
                            context,
                            carName: "#cars",
                            date: " in 22/1/2023",
                            mercedesBenz: "Mercedes-Benz ",
                            locationText: "Dakahlia, Mansoura",
                            price: "1000 EGP",
                          ),
                        ),
                        SizedBox(height: 173.v),
                      ],
                    ),
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
      height: 70.v,
      leadingWidth: 54.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgGlobe,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 8.h),
        child: Row(
          children: [
            AppbarTitleIconbutton(
              imagePath: ImageConstant.imgSearch141BlueGray90001,
            ),
            AppbarTitleImage(
              imagePath: ImageConstant.imgLayer1,
              margin: EdgeInsets.only(
                left: 60.h,
                top: 2.v,
                bottom: 3.v,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgVuesaxTwotoneNotification,
          margin: EdgeInsets.only(
            left: 15.h,
            top: 16.v,
            right: 16.h,
          ),
        ),
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgClockPrimary,
          margin: EdgeInsets.only(
            left: 8.h,
            top: 16.v,
            right: 31.h,
          ),
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildCategoriesFrame(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Categories",
          style: theme.textTheme.titleLarge,
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.v),
          child: Text(
            "See more",
            style: CustomTextStyles.titleSmallPrimary_1,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildCategoryTextRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // GridView.builder(
        //   shrinkWrap: true,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     mainAxisExtent: 93.v,
        //     crossAxisCount: 2,
        //     mainAxisSpacing: 12.h,
        //     crossAxisSpacing: 12.h,
        //   ),
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: 8,
        //   itemBuilder: (context, index) {
        //     return Category5ItemWidget();
        //   },
        // ),
        // GridView.builder(
        //   shrinkWrap: true,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     mainAxisExtent: 93.v,
        //     crossAxisCount: 3,
        //     mainAxisSpacing: 12.h,
        //     crossAxisSpacing: 12.h,
        //   ),
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: 12,
        //   itemBuilder: (context, index) {
        //     return Category6ItemWidget();
        //   },
        // ),
      ],
    );
  }

  /// Section Widget
  Widget _buildUserProfileList(BuildContext context) {
    return SizedBox(
      height: 216.v,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            width: 8.h,
          );
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return UserprofilelistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildWidgetRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomImageView(
            imagePath: ImageConstant.imgRectangle12,
            height: 135.v,
            width: 195.h,
            radius: BorderRadius.vertical(
              top: Radius.circular(12.h),
            ),
            margin: EdgeInsets.only(right: 4.h),
          ),
        ),
        Expanded(
          child: CustomImageView(
            imagePath: ImageConstant.imgRectangle12,
            height: 135.v,
            width: 195.h,
            radius: BorderRadius.vertical(
              top: Radius.circular(12.h),
            ),
            margin: EdgeInsets.only(left: 4.h),
          ),
        ),
      ],
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
  Widget _buildHomeOneColumn(
    BuildContext context, {
    required String carName,
    required String date,
    required String mercedesBenz,
    required String locationText,
    required String price,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.customBorderBL12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 8.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                carName,
                textAlign: TextAlign.justify,
                style: CustomTextStyles.bodySmallOrange400.copyWith(
                  color: appTheme.orange400,
                ),
              ),
              Text(
                date,
                style: CustomTextStyles.bodySmall10.copyWith(
                  color: appTheme.gray60001,
                ),
              ),
            ],
          ),
          SizedBox(height: 197.v),
          Text(
            mercedesBenz,
            textAlign: TextAlign.justify,
            style: CustomTextStyles.titleSmallSemiBold.copyWith(
              color: appTheme.blueGray90001,
            ),
          ),
          SizedBox(height: 220.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVuesaxLinearLocation,
                height: 1.v,
                width: 16.h,
                margin: EdgeInsets.only(top: 3.v),
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
          SizedBox(height: 254.v),
          Text(
            price,
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primary,
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
        return "/";
      case BottomBarEnum.Category:
       return "/";
      case BottomBarEnum.Message:
        return "/";
      case BottomBarEnum.More:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  // Widget getCurrentPage(String currentRoute) {
  //   switch (currentRoute) {
  //     case AppRoutes.featureAdsPage:
  //       return FeatureAdsPage();
  //     case AppRoutes.categoryPage:
  //       return CategoryPage();
  //     default:
  //       return DefaultWidget();
  //   }
  // }
}
