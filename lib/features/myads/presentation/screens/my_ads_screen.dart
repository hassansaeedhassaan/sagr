// ignore_for_file: unused_element

import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/myads/presentation/controllers/my_ads_controller.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';


import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../view/my_ads_screen/widgets/userprofile3_item_widget.dart';

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
      body: GetBuilder<MyAdsController>(
          init: MyAdsController(Get.find()),
          builder: (MyAdsController _myAdsController) {

          return SmartRefresher(controller: _myAdsController.refreshController,enablePullDown: true,
                                            enablePullUp: true,
                                            header: WaterDropHeader(),
                                            onRefresh: _myAdsController.onRefresh,
                                            onLoading: _myAdsController.onLoading,

                                            footer: CustomFooter(
                                              builder: (BuildContext context,
                                                  LoadStatus? mode) {
                                                Widget body;
                                                if (mode == LoadStatus.idle) {
                                                  body = _myAdsController.products
                                                              .length >
                                                          0
                                                      ? Text("Pull up load")
                                                      : Text("");
                                                } else if (mode ==
                                                    LoadStatus.loading) {
                                                  body =
                                                      CircularProgressIndicator();
                                                } else if (mode ==
                                                    LoadStatus.failed) {
                                                  body = Text(
                                                      "Load Failed!Click retry!");
                                                } else if (mode ==
                                                    LoadStatus.canLoading) {
                                                  body = Text(
                                                      "release to load more");
                                                } else {
                                                  body = Text("No more Data");
                                                }

                                                if (_myAdsController.hasMore ==
                                                    false) {
                                                  body = Text("No more Data");
                                                }

                                                return Container(
                                                  height: 55.0,
                                                  child: Center(child: body),
                                                );
                                              },
                                            ),
                                            
                                            child:ListView.builder(
        
        physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _myAdsController.products.length,
          itemBuilder: (_, index) {
            return Userprofile3ItemWidget(_myAdsController.products.elementAt(index));
          })
                                            );

            // return _myAdsController.isLoading?  CircularProgressIndicator() : Text(_myAdsController.products.toString());
            // return  RefreshIndicator(child: _myAdsController.products.length == 0 ?  NoResultsWidget(title: "No Results Found") : _myAdsController.isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :_buildUserProfile(context, _myAdsController.products), onRefresh: ()=> _myAdsController.onRefresh());
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

    );
  }

 
 
}
