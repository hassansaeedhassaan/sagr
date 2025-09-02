import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/products/presentation/controllers/product_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../theme/theme_helper.dart';
import '../../../../view/share_your_adds_four_page/share_your_adds_four_page.dart';
import '../../../../view/share_your_adds_six_page/share_your_adds_six_page.dart';
import '../../../../view/share_your_adds_two_page/share_your_adds_two_page.dart';

class ProductInfoScreen extends StatefulWidget {
  const ProductInfoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ShareYourAddsTwoTabContainerScreenState createState() =>
      ShareYourAddsTwoTabContainerScreenState();
}

class ShareYourAddsTwoTabContainerScreenState
    extends State<ProductInfoScreen>
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
        body: GetBuilder<ProductController>(
          init: ProductController(Get.find(), Get.find()),
          builder: (controller){
          return Container(
          child: controller.productsLoading ? Center(child: CircularProgressIndicator()) : SizedBox(
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
                      
                        ShareYourAddsTwoPage(controller.product),
                        ShareYourAddsSixPage(controller.product),
                        ShareYourAddsFourPage(controller.product),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        }),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
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
}
