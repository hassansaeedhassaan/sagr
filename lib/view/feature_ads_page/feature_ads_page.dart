import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/utils/image_constant.dart';
import '../../data/colors.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/categories/presentation/controllers/categories_controller.dart';
import '../../features/countries/domain/entities/country.dart';
import '../../features/countries/presentation/controllers/countries_controller.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/Common/custom_dropdown.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/go_to_map.dart';
import '../feature_ads_page/widgets/userprofile_item_widget.dart';

import 'package:flutter/material.dart';

import '../home_three_screen/home_three_screen.dart';

// ignore_for_file: must_be_immutable
class FeatureAdsPage extends StatelessWidget {
  FeatureAdsPage({Key? key})
      : super(
          key: key,
        );

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeaturedAdsController>(
        init: FeaturedAdsController(Get.find()),
        builder: (FeaturedAdsController featuredAdsController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55),
                child: AppBar(
                  backgroundColor: WHITE_COLOR,
                  title: Text("Feature Ads"),
                  scrolledUnderElevation: 0,
                )),
            body: Stack(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      _buildComponent(context),
                      SizedBox(height: 10.v),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  decoration: BoxDecoration(
                                      color: WHITE_COLOR,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: GetBuilder<CategoriesController>(
                                      init: CategoriesController(Get.find()),
                                      builder: (catCntr) {
                                        return CustomDropdownV2<Category?>(
                                          onChange: (int index) =>
                                              featuredAdsController
                                                  .setFeaturedSelectedCategory(
                                                      catCntr
                                                          .categories[index]),
                                          dropdownButtonStyle:
                                              DropdownButtonStyle(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            height: 38,
                                            elevation: 0,
                                            // backgroundColor: Colors.white,
                                            // primaryColor:
                                            //     Colors.black87,
                                          ),
                                          dropdownStyle: DropdownStyle(
                                              width: 160,
                                              color: WHITE_COLOR,
                                              elevation: 0,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    // color:
                                                    //     Colors.grey,
                                                    width: 0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8))),
                                          items: catCntr.categories
                                              .asMap()
                                              .entries
                                              .map(
                                                (item) =>
                                                    DropdownItem<Category?>(
                                                  value: item.value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(item.value.name!
                                                        .capitalize!),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          child: Text(featuredAdsController
                                                      .selectedCategory.id !=
                                                  null
                                              ? featuredAdsController
                                                  .selectedCategory
                                                  .name!
                                                  .capitalize!
                                              : "Category"),
                                        );
                                      }),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          3, 0, 3, 0),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          3, 0, 3, 0),
                                      decoration: BoxDecoration(
                                          color: WHITE_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: GetBuilder<CountriesController>(
                                          init: CountriesController(Get.find()),
                                          builder: (catCntr) {
                                            return CustomDropdownV2<Country?>(
                                              onChange: (int index) =>
                                                  featuredAdsController
                                                      .setFeaturedSelectedCountry(
                                                          catCntr.countries[
                                                              index]),
                                              dropdownButtonStyle:
                                                  DropdownButtonStyle(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                height: 38,
                                                elevation: 0,
                                                // backgroundColor: Colors.white,
                                                // primaryColor:
                                                //     Colors.black87,
                                              ),
                                              dropdownStyle: DropdownStyle(
                                                  width: 160,
                                                  color: WHITE_COLOR,
                                                  elevation: 0,
                                                  padding: EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        // color: Colors
                                                        //     .grey,
                                                        width: 0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              items: catCntr.countries
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (item) =>
                                                        DropdownItem<Country?>(
                                                      value: item.value,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            item.value.name!),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              child: Text(featuredAdsController
                                                          .selectedCountry.id !=
                                                      null
                                                  ? featuredAdsController
                                                      .selectedCountry.name!
                                                  : "Country"),
                                            );
                                          }),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      // _determinePosition();

                                      featuredAdsController.nearByFilter();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 8),
                                      margin:
                                          EdgeInsetsDirectional.only(end: 0),
                                      decoration: !featuredAdsController.nearBy
                                          ? BoxDecoration(
                                              color: WHITE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            )
                                          : BoxDecoration(
                                              color: appTheme.orange400
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  width: 1,
                                                  color: appTheme.orange400)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Near By",
                                            style: TextStyle(
                                                color: !featuredAdsController
                                                        .nearBy
                                                    ? null
                                                    : appTheme.orange400,
                                                fontSize: 13),
                                          ),
                                          !featuredAdsController.nearBy
                                              ? SizedBox.shrink()
                                              : CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgClose,
                                                  height: 16.adaptSize,
                                                  width: 16.adaptSize),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.v),
                            Row(
                              children: [
                                Container(
                                  width: 130,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: InkWell(
                                    onTap: () => featuredAdsController
                                        .toggleAvailablePhoto(),
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: featuredAdsController
                                                    .available_photo_featured_secction
                                                ? appTheme.orange400
                                                    .withOpacity(0.1)
                                                : WHITE_COLOR,
                                            border: featuredAdsController
                                                    .available_photo_featured_secction
                                                ? Border.all(
                                                    width: 1,
                                                    color: appTheme.orange400)
                                                : Border(),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Row(
                                          mainAxisAlignment: featuredAdsController
                                                  .available_photo_featured_secction
                                              ? MainAxisAlignment.spaceAround
                                              : MainAxisAlignment.center,
                                          children: [
                                            Text("Available Photo",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: featuredAdsController
                                                          .available_photo_featured_secction
                                                      ? appTheme.orange400
                                                      : BLACK_COLOR,
                                                ),
                                                textAlign: TextAlign.center),
                                            featuredAdsController
                                                    .available_photo_featured_secction
                                                ? CustomImageView(
                                                    imagePath:
                                                        ImageConstant.imgClose,
                                                    height: 16.adaptSize,
                                                    width: 16.adaptSize)
                                                : SizedBox.shrink(),
                                          ],
                                        )),
                                  ),
                                ),

                                // MOST VIEWS Dropdown List
                                MostViewdDropDown(),

                                // GoToMap(context),
                              ],
                            ),
                            SizedBox(height: 12.v),
                          ],
                        ),
                      ),
                      // Filters Designs

                      // Container(
                      //   padding: EdgeInsetsDirectional.symmetric(horizontal: 8),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Expanded(
                      //             flex: 2,
                      //             child: Container(
                      //               margin: EdgeInsetsDirectional.only(end: 0),
                      //               child: CustomDropDown(
                      //                 // width: 112.h,
                      //                 icon: Container(
                      //                   margin: EdgeInsets.symmetric(
                      //                     horizontal: 2.h,
                      //                     vertical: 6.v,
                      //                   ),
                      //                   child: CustomImageView(
                      //                     imagePath: ImageConstant.imgArrowdownGray60001,
                      //                     height: 16.adaptSize,
                      //                     width: 16.adaptSize,
                      //                   ),
                      //                 ),
                      //                 hintText: "Category",
                      //                 hintStyle: TextStyle(fontSize: 12),
                      //                 items: dropdownItemList,
                      //                 onChanged: (value) {},
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //             flex: 2,
                      //             child: Container(
                      //               margin: EdgeInsetsDirectional.only(end: 5, start: 4),
                      //               child: CustomDropDown(
                      //                 icon: Container(
                      //                   margin: EdgeInsets.symmetric(
                      //                     horizontal: 2.h,
                      //                     vertical: 6.v,
                      //                   ),
                      //                   child: CustomImageView(
                      //                     imagePath: ImageConstant.imgArrowdownGray60001,
                      //                     height: 16.adaptSize,
                      //                     width: 16.adaptSize,
                      //                   ),
                      //                 ),
                      //                 hintText: "City",
                      //                 hintStyle: TextStyle(fontSize: 12),
                      //                 items: dropdownItemList,
                      //                 onChanged: (value) {},
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //             flex: 2,
                      //             child: Container(
                      //               padding:
                      //                   EdgeInsets.symmetric(horizontal: 1, vertical: 7),
                      //               margin: EdgeInsetsDirectional.only(end: 5),
                      //               decoration: BoxDecoration(
                      //                   color: appTheme.orange400.withOpacity(0.1),
                      //                   borderRadius: BorderRadius.circular(6),
                      //                   border: Border.all(
                      //                       width: 1, color: appTheme.orange400)),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //                 children: [
                      //                   Text(
                      //                     "Near By",
                      //                     style: TextStyle(
                      //                         color: appTheme.orange400, fontSize: 11),
                      //                   ),
                      //                   CustomImageView(
                      //                       imagePath: ImageConstant.imgClose,
                      //                       height: 16.adaptSize,
                      //                       width: 16.adaptSize),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //               flex: 2,
                      //               child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: 1, vertical: 9),
                      //                 decoration: BoxDecoration(
                      //                     color: WHITE_COLOR,
                      //                     borderRadius: BorderRadius.circular(6)),
                      //                 child: Text("Available Photo",
                      //                     style: TextStyle(
                      //                         fontSize: 10.5,
                      //                         fontWeight: FontWeight.w600),
                      //                     textAlign: TextAlign.center),
                      //               ))
                      //         ],
                      //       ),
                      //       SizedBox(height: 8.v),
                      //       Row(
                      //         children: [
                      //           CustomDropDown(
                      //             width: 112.h,
                      //             icon: Container(
                      //               margin: EdgeInsets.symmetric(
                      //                 horizontal: 8.h,
                      //                 vertical: 6.v,
                      //               ),
                      //               child: CustomImageView(
                      //                 imagePath: ImageConstant.imgArrowdownGray60001,
                      //                 height: 20.adaptSize,
                      //                 width: 20.adaptSize,
                      //               ),
                      //             ),
                      //             hintText: "Most viewed",
                      //             hintStyle: TextStyle(fontSize: 12),
                      //             items: dropdownItemList,
                      //             onChanged: (value) {},
                      //           ),
                      //           GoToMap(context),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // _buildNearBy(context),
                      // SizedBox(height: 8.v),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 16.h),
                      //     child: Row(
                      //       children: [
                      //         CustomDropDown(
                      //           width: 124.h,
                      //           icon: Container(
                      //             margin: EdgeInsets.symmetric(
                      //               horizontal: 8.h,
                      //               vertical: 9.v,
                      //             ),
                      //             child: CustomImageView(
                      //               imagePath: ImageConstant.imgArrowdownGray60001,
                      //               height: 16.adaptSize,
                      //               width: 16.adaptSize,
                      //             ),
                      //           ),
                      //           hintText: "Most viewed",
                      //           items: dropdownItemList2,
                      //           onChanged: (value) {},
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(left: 8.h),
                      //           child: CustomIconButton(
                      //             height: 35.v,
                      //             width: 40.h,
                      //             padding: EdgeInsets.all(5.h),
                      //             decoration: IconButtonStyleHelper.fillOnPrimary,
                      //             child: CustomImageView(
                      //               imagePath: ImageConstant.imgUser,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(height: 12.v),
                      Expanded(
                          child: _buildUserProfile(
                              context, featuredAdsController.products)),
                    ],
                  ),
                ),
                
                SearchResults(isShow: featuredAdsController.show_search_dialog, isLoading: featuredAdsController.productsLoading,),
              ],
            ),
          );
        });
  }

  /// Section Widget
  Widget _buildComponent(BuildContext context) {
    return GetBuilder<FeaturedAdsController>(
      init: FeaturedAdsController(Get.find()),
      builder: (FeaturedAdsController __featuredController) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 8.v,
          ),
          decoration: AppDecoration.fillOnPrimary,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchView(
                      controller: searchController,
                      hintText: "Search for ads...",
                      onChanged: (value) => __featuredController.setSearchQuery(value),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgShare,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    margin: EdgeInsets.only(
                      left: 12.h,
                      top: 13.v,
                      bottom: 13.v,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context, products) {
    return GetBuilder(builder: (FeaturedAdsController featureAdsController) {
      return SmartRefresher(
          physics: AlwaysScrollableScrollPhysics(),
          controller: featureAdsController.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          onRefresh: featureAdsController.onRefresh,
          onLoading: featureAdsController.onLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 247.v,
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.h,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Get.toNamed('/product_detail_screen',
                        arguments: products[index]!.id),
                    child: ProductItemWidget(
                      product: products[index],
                    ));
              },
            ),
          ));
    });
  }
}

class SearchResults extends StatelessWidget {
  final bool isShow;
  final bool isLoading;
  const SearchResults({
    Key? key,
    this.isLoading = false,
    this.isShow = true, // non-nullable but optional with a default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeaturedAdsController>(
        init: FeaturedAdsController(Get.find()),
        builder: (FeaturedAdsController _featuredController) {
          return  isShow == false
              ? SizedBox.shrink()
              : Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: GREY_COLOR,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: _featuredController.searchLoading == true  ? Center(child:  CircularProgressIndicator(),) :Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                reverse: true,
                                child: Column(
                                  children: _featuredController.products.map((product) =>  Container(
                                      decoration: BoxDecoration(color: WHITE_COLOR),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsetsDirectional.fromSTEB(
                                                0, 12, 10, 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                fit: BoxFit.cover,
                                                "${product.image}",
                                                width: 65,
                                                height: 65,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width - 120,
                                                child: Text(
                                                  maxLines: 2,
                                                "${product.name}",
                                             
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              ),
                                              Text(
                                                "${product.price} ${product.currency}",
                                                style: TextStyle(
                                                    color: RED_COLOR,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800),
                                              ),
                                              Text("Egypt, Mansoura")
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    ).toList(),
                                ),
                              ),
                            ),
                            Ink(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                child: Text("More Results >>"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
        });
  }
}
