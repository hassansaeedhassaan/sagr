
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/appbar/basic_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(66), child:  BasicAppBar(title: "Wallet")),
        // appBar: AppBar(
        //   title: Text("Wallet"),
        // ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              _buildWalletFrame(context),
              SizedBox(height: 12.v),
              _buildRechargeByFrame(context),
              SizedBox(height: 24.v),
              CustomElevatedButton(
                width: 186.h,
                text: "Confirm",
                buttonStyle: CustomButtonStyles.none,
                decoration:
                    CustomButtonStyles.gradientPrimaryToOrangeDecoration,
              ),
              SizedBox(height: 5.v),
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
        text: "Wallet",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildWalletFrame(BuildContext context) {
    return Container(
      width: 398.h,
      padding: EdgeInsets.symmetric(
        horizontal: 17.h,
        vertical: 24.v,
      ),
      decoration: BoxDecoration(
         gradient: LinearGradient(
          //  begin: Alignment(-0.11, -0.23),
          end: Alignment(1.09, 1.21),
          colors: [
            theme.colorScheme.primary,
            appTheme.orange400,
          ],
        ),
        borderRadius: BorderRadiusStyle.roundedBorder16,

        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgFrame1261153940,
          ),
          fit: BoxFit.cover,
        ),
      ),
    
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 9.h,
                top: 5.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Balance",
                    style: CustomTextStyles.bodyMediumNunitoSansOnPrimary,
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    "1500 SR",
                    style: CustomTextStyles.headlineSmallNunitoSansOnPrimary,
                  ),
                ],
              ),
            ),
          ),
          CustomElevatedButton(
            height: 42.v,
            width: 118.h,
            text: "Recharge",
          
            buttonStyle: CustomButtonStyles.fillOnPrimaryTL12,
            buttonTextStyle: CustomTextStyles.titleMediumPink60001SemiBold,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRechargeByFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rechage by :",
                style: CustomTextStyles.titleMediumBluegray90001SemiBold_1,
              ),
              SizedBox(height: 6.v),
              CustomImageView(
                imagePath: ImageConstant.imgImageRemovebgPreview,
                height: 26.v,
                width: 70.h,
              ),
            ],
          ),
          CustomImageView(
            imagePath: ImageConstant.imgContrastPrimarycontainer,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.only(
              top: 35.v,
              bottom: 3.v,
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
