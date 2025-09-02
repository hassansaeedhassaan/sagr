import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/commissions/commission_screen.dart';
import 'package:sagr/view/contact_us_five_screen/contact_us_five_screen.dart';
import 'package:sagr/view/contact_us_four_screen/contact_us_four_screen.dart';
import 'package:sagr/view/contact_us_screen/contact_us_screen.dart';

import 'package:sagr/view/my_ads_screen/my_ads_screen.dart';
import 'package:sagr/view/my_cards/my_cards_screen.dart';
import 'package:sagr/view/my_fav_screen/my_favorite_screen.dart';
import 'package:sagr/view/preference_screen/preference_screen.dart';
import 'package:sagr/view/wallet_screen/wallet_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/appbar/build_core_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_image_view.dart';

import '../contact_us_three_screen/contact_us_three_screen.dart';

// ignore: must_be_immutable
class MoreScreen extends StatelessWidget {
  MoreScreen({Key? key}) : super(key: key);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(77.0), child: BuildCoreAppBar()),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 16.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.v),
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      children: [
                        _buildFrameRow1(context),
                        SizedBox(height: 12.v),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUsScreen()))
                          },
                          child: _buildFrameRow(
                            context,
                            thumbsUpImage: ImageConstant.imgLock,
                            walletLabel: "Personal Info",
                            arrowRightImage:
                                ImageConstant.imgArrowRightGray50001,
                          ),
                        ),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WalletScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgThumbsUpGray60001,
                              walletLabel: "Wallet",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CommissionScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgSend,
                              walletLabel: "My Commissions",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyCardsScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage:
                                  ImageConstant.imgThumbsUpGray6000124x24,
                              walletLabel: "My Cards",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyAdsScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgSearchGray60001,
                              walletLabel: "My Ads",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyFavoriteScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgFavoriteGray60001,
                              walletLabel: "My Favorite",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PreferenceScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgGlobeGray60001,
                              walletLabel: "Preference",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContactUsFormScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgCallGray60001,
                              walletLabel: "Contact us",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContactUsFourScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgVideoCamera,
                              walletLabel: "About us",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContactUsThreeScreen()))
                                },
                            child: _buildFrameRow(
                              context,
                              thumbsUpImage: ImageConstant.imgVuesaxLinearCrown,
                              walletLabel: "How to become Special",
                              arrowRightImage:
                                  ImageConstant.imgArrowRightGray50001,
                            )),
                        SizedBox(height: 8.v),
                        _buildFrameRow(
                          context,
                          thumbsUpImage: ImageConstant.imgClockPrimary,
                          walletLabel: "Logout",
                          arrowRightImage: ImageConstant.imgArrowRightPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
      height: 70.v,
      leadingWidth: 53.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgGlobe,
        margin: EdgeInsets.only(
          left: 15.h,
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
            left: 16.h,
            top: 16.v,
            right: 16.h,
          ),
        ),
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgClockPrimary,
          margin: EdgeInsets.only(
            left: 8.h,
            top: 16.v,
            right: 32.h,
          ),
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildFrameRow1(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.linear.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle121,
            height: 48.adaptSize,
            width: 48.adaptSize,
            radius: BorderRadius.circular(
              24.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              top: 2.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Eman Elsherbiny",
                  style: CustomTextStyles.titleMediumOnPrimarySemiBold,
                ),
                Text(
                  "eman10@gmail.com",
                  style: CustomTextStyles.titleSmallOnPrimary,
                ),
              ],
            ),
          ),
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

  /// Common widget
  Widget _buildFrameRow(
    BuildContext context, {
    required String thumbsUpImage,
    required String walletLabel,
    required String arrowRightImage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48.adaptSize,
            width: 48.adaptSize,
            padding: EdgeInsets.all(12.h),
            decoration: AppDecoration.fillGray50.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: CustomImageView(
              imagePath: thumbsUpImage,
              height: 24.adaptSize,
              width: 24.adaptSize,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              top: 11.v,
              bottom: 11.v,
            ),
            child: Text(
              walletLabel,
              style: CustomTextStyles.titleMediumOnErrorContainer.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: arrowRightImage,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 14.v),
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
