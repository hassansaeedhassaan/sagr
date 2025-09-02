import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:sagr/features/latest/presentation/controllers/latest_ads_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../data/colors.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../view/feature_ads_page/widgets/userprofile_item_widget.dart';
import '../../../../view/home_three_screen/home_three_screen.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_search_view.dart';
import '../../../../widgets/go_to_map.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/controllers/categories_controller.dart';
import '../../../countries/domain/entities/country.dart';
import '../../../countries/presentation/controllers/countries_controller.dart';


// ignore_for_file: must_be_immutable
class LatestAdsPage extends StatelessWidget {
  LatestAdsPage({Key? key})
      : super(
          key: key,
        );

  TextEditingController searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    return GetBuilder<LatestAdsController>(
        init: LatestAdsController(Get.find()),
        builder: (LatestAdsController latestAdsController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55),
                child: AppBar(
                  backgroundColor: WHITE_COLOR,
                  title: Text("Latest Ads"),
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
                            padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                            decoration: BoxDecoration(
                                color: WHITE_COLOR,
                                borderRadius: BorderRadius.circular(8)),
                            child: GetBuilder<CategoriesController>(
                                init: CategoriesController(Get.find()),
                                builder: (catCntr) {
                                  return CustomDropdownV2<Category?>(
                                    onChange: (int index) => latestAdsController
                                        .setFeaturedSelectedCategory(
                                            catCntr.categories[index]),
                                    dropdownButtonStyle: DropdownButtonStyle(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
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
                                                BorderRadius.circular(8))),
                                    items: catCntr.categories
                                        .asMap()
                                        .entries
                                        .map(
                                          (item) => DropdownItem<Category?>(
                                            value: item.value,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                  item.value.name!.capitalize!),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    child: Text(
                                        latestAdsController.selectedCategory.id !=
                                                null
                                            ? latestAdsController
                                                .selectedCategory.name!.capitalize!
                                            : "Category"),
                                  );
                                }),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                decoration: BoxDecoration(
                                    color: WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(8)),
                                child: GetBuilder<CountriesController>(
                                    init: CountriesController(Get.find()),
                                    builder: (catCntr) {
                                      return CustomDropdownV2<Country?>(
                                        onChange: (int index) =>
                                            latestAdsController
                                                .setFeaturedSelectedCountry(
                                                    catCntr.countries[index]),
                                        dropdownButtonStyle: DropdownButtonStyle(
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
                                                  // color: Colors
                                                  //     .grey,
                                                  width: 0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        items: catCntr.countries
                                            .asMap()
                                            .entries
                                            .map(
                                              (item) => DropdownItem<Country?>(
                                                value: item.value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(item.value.name!),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        child: Text(latestAdsController
                                                    .selectedCountry.id !=
                                                null
                                            ? latestAdsController
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
                
                                latestAdsController.nearByFilter();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 8),
                                margin: EdgeInsetsDirectional.only(end: 0),
                                decoration: !latestAdsController.nearBy
                                    ? BoxDecoration(
                                        color: WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(6),
                                      )
                                    : BoxDecoration(
                                        color: appTheme.orange400.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            width: 1, color: appTheme.orange400)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Near By",
                                      style: TextStyle(
                                          color: !latestAdsController.nearBy
                                              ? null
                                              : appTheme.orange400,
                                          fontSize: 13),
                                    ),
                                    !latestAdsController.nearBy
                                        ? SizedBox.shrink()
                                        : CustomImageView(
                                            imagePath: ImageConstant.imgClose,
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
                            margin: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                            child: InkWell(
                              onTap: () =>
                                  latestAdsController.toggleAvailablePhoto(),
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: latestAdsController
                                              .available_photo_featured_secction
                                          ? appTheme.orange400.withOpacity(0.1)
                                          : WHITE_COLOR,
                                      border: latestAdsController
                                              .available_photo_featured_secction
                                          ? Border.all(
                                              width: 1, color: appTheme.orange400)
                                          : Border(),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    mainAxisAlignment: latestAdsController
                                            .available_photo_featured_secction
                                        ? MainAxisAlignment.spaceAround
                                        : MainAxisAlignment.center,
                                    children: [
                                      Text("Available Photo",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: latestAdsController
                                                    .available_photo_featured_secction
                                                ? appTheme.orange400
                                                : BLACK_COLOR,
                                          ),
                                          textAlign: TextAlign.center),
                                      latestAdsController
                                              .available_photo_featured_secction
                                          ? CustomImageView(
                                              imagePath: ImageConstant.imgClose,
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
               
                      Expanded(
                          child: _buildUserProfile(
                              context, latestAdsController.products)),
                    ],
                  ),
                ),
             
              // Positioned(
              //     top: 60,
              //     left: 16,
              //     right: 16,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: GREY_COLOR,
              //         borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
              //       ),
              //       width: MediaQuery.of(context).size.width,
              //       height: 500,
                    
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Expanded(
                        
              //           child: SingleChildScrollView(
              //             child: Column(
              //               children: [
              //                Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Mercedes-Benz E200 2024 AMG Fully Loaded"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),

              //                Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Mercedes-Benz E200 2024 AMG Fully Loaded", style: TextStyle(fontWeight: FontWeight.w500),),
              //                          Text("2000 EGP", style: TextStyle(color: RED_COLOR, fontSize: 14, fontWeight: FontWeight.w800),),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
                          
              //                 Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: GREY_COLOR.withOpacity(0.15),
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Ad Tilte For Search"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
              //                Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Ad Tilte For Search"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
              //                 Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Ad Tilte For Search"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
              //                Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Ad Tilte For Search"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
              //                 Container(
              //                  decoration: BoxDecoration(
              //                    color: WHITE_COLOR
              //                  ),
              //                  child: Row(
              //                    children: [
              //                      Container(
              //                        margin: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
              //                        decoration: BoxDecoration(
              //                          color: RED_COLOR,
              //                          borderRadius: BorderRadius.circular(12),
              //                        ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(12),
              //                             child: Image.asset("assets/images/logo.png", width: 65, height: 65,),
              //                           ),
              //                      ),
                          
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          Text("Ad Tilte For Search"),
              //                          Text("2000 EGP"),
              //                            Text("Egypt, Mansoura")
              //                        ],
              //                      )
              //                    ],
              //                  ),
              //                ),
                             
                          
              //               ],
              //             ),
              //           ),
                      

              //         ),

              //         Ink(
              //           child: Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), child: Text("More Results >>"),),
              //         )
              //       ],
              //     ),
              //   )),
              
              
              
              ],
            ),
          );
        });
  }

  /// Section Widget
  Widget _buildComponent(BuildContext context) {
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
              hintText: "Search for ads... we",
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
                    onTap: () =>  Get.toNamed('/product_detail_screen', arguments: products[index]!.id),
                    child: ProductItemWidget(
                      product: products[index],
                    ));
              },
            ),
          ));
    });
   
  }
}
