// ignore_for_file: unused_element

import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/presentation/controllers/products/products_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/Common/no_result.dart';

import '../my_ads_screen/widgets/userprofile3_item_widget.dart';
import 'package:flutter/material.dart';

class MyAdsScreen extends StatelessWidget {
  MyAdsScreen({Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
        title: Text("My Ads"),
      ),
      body: GetBuilder<ProductsController>(
          init: ProductsController(Get.find()),
          builder: (ProductsController controller) {
            return  RefreshIndicator(child: controller.products.length == 0 ?  NoResultsWidget(title: "No Results Found") : controller.productsLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                :_buildUserProfile(context, controller.products), onRefresh: ()=> controller.onRefresh());
          }),
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context, List<Product> products) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
        
            return Userprofile3ItemWidget(products.elementAt(index));
          }),
      // child: ListView.separated(
      //   // physics: NeverScrollableScrollPhysics(),
      //   shrinkWrap: true,
      //   separatorBuilder: (
      //     context,
      //     index,
      //   ) {
      //     return SizedBox(
      //       height: 8.v,
      //     );
      //   },
      //   itemCount: products.length,
      //   itemBuilder: (context, index) {
      //     return Userprofile3ItemWidget(products.elementAt(index));
      //   },
      // ),
    );
  }

 
 
}
