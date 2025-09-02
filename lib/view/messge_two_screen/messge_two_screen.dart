import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_search_view.dart';
import '../messge_two_screen/widgets/userprofile7_item_widget.dart';

import 'package:flutter/material.dart';

class MessgeTwoScreen extends StatelessWidget {
  MessgeTwoScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController searchController = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return  MasterWrapper(
      body: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
          leadingWidth: 39.h,
          toolbarHeight: 66,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(
            left: 16.h,
            top: 16.v,
            bottom: 16.v,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 16.h),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Message ",
                  style: CustomTextStyles.titleLargeff333333,
                ),
                TextSpan(
                  text: "(10)",
                  style: CustomTextStyles.titleMediumffd20653,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        )
        ),
        body: Container(
          // width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              CustomSearchView(
                controller: searchController,
                hintText: "Search Direct Messages ...",
                hintStyle: theme.textTheme.bodySmall!,
              ),
              SizedBox(height: 8.v),
             Expanded(child:  _buildUserProfile(context)),
            ],
          ),
        ),
        
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
      title: Padding(
        padding: EdgeInsets.only(left: 16.h),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Message ",
                style: CustomTextStyles.titleLargeff333333,
              ),
              TextSpan(
                text: "(10)",
                style: CustomTextStyles.titleMediumffd20653,
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (
        context,
        index,
      ) {
        return SizedBox(
          height: 8.v,
        );
      },
      itemCount: 20,
      itemBuilder: (context, index) {
        return Userprofile7ItemWidget();
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
