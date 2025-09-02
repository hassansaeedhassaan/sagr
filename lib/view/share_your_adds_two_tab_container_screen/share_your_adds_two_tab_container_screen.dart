import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';

class ShareYourAddsTwoTabContainerScreen222 extends StatefulWidget {
  const ShareYourAddsTwoTabContainerScreen222({Key? key})
      : super(
          key: key,
        );

  @override
  ShareYourAddsTwoTabContainerScreenState createState() =>
      ShareYourAddsTwoTabContainerScreenState();
}

class ShareYourAddsTwoTabContainerScreenState
    extends State<ShareYourAddsTwoTabContainerScreen222>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: Text("Edit Your Ads"),
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
        ),
        body: Container(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                _buildTabview(context),
                Expanded(
                  child: SizedBox(
                    // height: 672.v,
                    child: TabBarView(
                      controller: tabviewController,
                      children: [
                        // ShareYourAddsTwoPage(),
                        // ShareYourAddsSixPage(),
                        // ShareYourAddsFourPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        text: "Edit your ads",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      height: 51.v,
      width: 429.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: appTheme.orange400,
        labelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: GREY_COLOR,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        indicatorPadding: EdgeInsets.all(
          8.0.h,
        ),
        indicator: BoxDecoration(
          color: appTheme.orange400.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            8.h,
          ),
          border: Border.all(
            color: appTheme.orange400,
            width: 1.h,
          ),
        ),
        tabs: [
          Tab(
            child: Text(
              "Attachments",
            ),
          ),
          Tab(
            child: Text(
              "Ads info",
            ),
          ),
          Tab(
            child: Text(
              "Address info",
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
