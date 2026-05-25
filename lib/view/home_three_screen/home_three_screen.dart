import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/features/countries/domain/entities/country.dart';
import 'package:sagr/features/countries/presentation/controllers/countries_controller.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:sagr/features/latest/presentation/controllers/latest_ads_controller.dart';
import 'package:sagr/features/latest/presentation/screens/latest_ads_page.dart';
import 'package:sagr/view/feature_ads_page/feature_ads_page.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/appbar/build_core_app_bar.dart';

import '../../core/utils/image_constant.dart';
import '../../features/banner/presentation/controllers/banner_controller.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/Common/custom_dropdown.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/go_to_map.dart';
import '../home_three_screen/home_three_helpers.dart';
import '../home_three_screen/widgets/card_column.dart';
import '../home_three_screen/widgets/card_stack.dart';
import '../home_three_screen/widgets/category_sections.dart';
import '../home_three_screen/widgets/feature_ads_row.dart';
import '../home_three_screen/widgets/featured_ads_section.dart';
import '../home_three_screen/widgets/most_viewed_dropdown.dart';

import 'package:flutter/material.dart';

class HomeThreeScreen extends StatelessWidget {
  HomeThreeScreen({Key? key})
      : super(
          key: key,
        );


  


  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(77), child: BuildCoreAppBar()),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 42.v),
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                            onTap: () =>  Navigator.pushNamedAndRemoveUntil(context,'/category_screen',(_) => false),
                        //  onTap: () => Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                         builder: (context) =>
                        //                             CreateAdScreen(Get.find()))),
                        

                            child: FeatureAdsRow(
                              featureAdsText: "Categories",
                              seeMoreText: "See more",
                            )),

                        SizedBox(height: 10.v),

                        const CategoryGridSection(),
                        // GetBuilder<CategoriesController>(
                        //     init: CategoriesController(Get.find()),
                        //     builder: (_catController) {
                        //       return ListView.builder(
                        //           shrinkWrap: true,
                        //           itemCount: _catController
                        //                 .categoriesList.length,
                        //           itemBuilder: (context, index) {
                        //             return Text(_catController
                        //                 .categoriesList[0].values.toList()
                        //                 .toString());
                        //           });
                        //     }),

                        const CategoryGridSubSection(),
                        const CategoryGridSSubSection(),
                        const CategoryGridThSubSection(),
                        // SizedBox(child: Row(children: _myWidget(5))),

                        const FeaturedAdsSection(),

       GetBuilder<BannerController>(
            init: BannerController(Get.find()),
            builder: (BannerController _bannerController){

            return SizedBox(child: 
                    InkWell(
                      onTap: () =>  appLaunchUrl(_bannerController.banner.link),
                      child: CachedNetworkImage(
                                  imageUrl: _bannerController.banner.image_path
                                      .toString(),
                                  fit: BoxFit.cover,
                                ),
                    )
            );
            
          }),
                        GetBuilder<LatestAdsController>(
                            init: LatestAdsController(Get.find()),
                            builder: (latestController) {
                              return Column(
                                children: [
                                  
                                  SizedBox(height: 22.v),
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LatestAdsPage())),
                                    child: FeatureAdsRow(
                                      featureAdsText: "Latest ads",
                                      seeMoreText: "See more",
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            3, 0, 3, 0),
                                        decoration: BoxDecoration(
                                            color: WHITE_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: GetBuilder<CategoriesController>(
                                            init: CategoriesController(
                                                Get.find()),
                                            builder: (catCntr) {
                                              return CustomDropdownV2<
                                                  Category?>(
                                                onChange: (int index) =>
                                                    latestController
                                                        .setFeaturedSelectedCategory(
                                                            catCntr.categories[
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
                                                  primaryColor: Colors.black87,
                                                ),
                                                dropdownStyle: DropdownStyle(
                                                    width: 160,
                                                    color: WHITE_COLOR,
                                                    elevation: 0,
                                                    padding: EdgeInsets.all(0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                items: catCntr.categories
                                                    .asMap()
                                                    .entries
                                                    .map(
                                                      (item) => DropdownItem<
                                                          Category?>(
                                                        value: item.value,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(item
                                                              .value
                                                              .name!
                                                              .capitalize!),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                                child: Text(latestController
                                                            .selectedCategory
                                                            .id !=
                                                        null
                                                    ? latestController
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
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    3, 0, 3, 0),
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    3, 0, 3, 0),
                                            decoration: BoxDecoration(
                                                color: WHITE_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: GetBuilder<
                                                    CountriesController>(
                                                init: CountriesController(
                                                    Get.find()),
                                                builder: (catCntr) {
                                                  return CustomDropdownV2<
                                                      Country?>(
                                                    onChange: (int index) =>
                                                        latestController
                                                            .setFeaturedSelectedCountry(
                                                                catCntr.countries[
                                                                    index]),
                                                    dropdownButtonStyle:
                                                        DropdownButtonStyle(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      height: 38,
                                                      elevation: 0,
                                                      // backgroundColor: Colors.white,
                                                      primaryColor:
                                                          Colors.black87,
                                                    ),
                                                    dropdownStyle:
                                                        DropdownStyle(
                                                            width: 160,
                                                            color: WHITE_COLOR,
                                                            elevation: 0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
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
                                                              DropdownItem<
                                                                  Country?>(
                                                            value: item.value,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(item
                                                                  .value.name!),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    child: Text(latestController
                                                                .selectedCountry
                                                                .id !=
                                                            null
                                                        ? latestController
                                                            .selectedCountry
                                                            .name!
                                                        : "Country"),
                                                  );
                                                }),
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            determinePosition();

                                            latestController.nearByFilter();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1, vertical: 8),
                                            margin: EdgeInsetsDirectional.only(
                                                end: 0),
                                            decoration: !latestController.nearBy
                                                ? BoxDecoration(
                                                    color: WHITE_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  )
                                                : BoxDecoration(
                                                    color: appTheme.orange400
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: appTheme
                                                            .orange400)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Near By",
                                                  style: TextStyle(
                                                      color: !latestController
                                                              .nearBy
                                                          ? null
                                                          : appTheme.orange400,
                                                      fontSize: 13),
                                                ),
                                                !latestController.nearBy
                                                    ? SizedBox.shrink()
                                                    : CustomImageView(
                                                        imagePath: ImageConstant
                                                            .imgClose,
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
                                          onTap: () => latestController
                                              .toggleAvailablePhoto(),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: latestController
                                                          .available_photo_featured_secction
                                                      ? appTheme.orange400
                                                          .withOpacity(0.1)
                                                      : WHITE_COLOR,
                                                  border: latestController
                                                          .available_photo_featured_secction
                                                      ? Border.all(
                                                          width: 1,
                                                          color: appTheme
                                                              .orange400)
                                                      : Border(),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Row(
                                                mainAxisAlignment: latestController
                                                        .available_photo_featured_secction
                                                    ? MainAxisAlignment
                                                        .spaceAround
                                                    : MainAxisAlignment.center,
                                                children: [
                                                  Text("Available Photo",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: latestController
                                                                .available_photo_featured_secction
                                                            ? appTheme.orange400
                                                            : BLACK_COLOR,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center),
                                                  latestController
                                                          .available_photo_featured_secction
                                                      ? CustomImageView(
                                                          imagePath:
                                                              ImageConstant
                                                                  .imgClose,
                                                          height: 16.adaptSize,
                                                          width: 16.adaptSize)
                                                      : SizedBox.shrink(),
                                                ],
                                              )),
                                        ),
                                      ),

                                      // MOST VIEWS Dropdown List
                                      MostViewdDropDownLatestSection(),


  GetBuilder<LatestAdsController>(
                            init: LatestAdsController(Get.find()),
                            builder: (latestController) {

                                     return  GoToMap(context, latestController.products);

                            })


                                     
                                    ],
                                  ),
                                  SizedBox(height: 12.v),
                                  SizedBox(height: 12.v),
                                  SizedBox(
                                      height: 258.v,
                                      width: 398.h,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount:
                                              latestController.products.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      end: 5),
                                              child: CardColumn(
                                                id: latestController
                                                    .products[index].id!,
                                                negotiable: "${latestController.products[index].isNegotiable}",
                                                cars: "#cars",
                                                image: latestController
                                                    .products[index].image!,
                                                inVar:
                                                    " in ${latestController.products[index].created_at}",
                                                mercedesBenz: latestController
                                                    .products[index].name,
                                                dakahliaMansoura:
                                                    "${latestController.products[index].nationality.name}, ${latestController.products[index].city!.name}",
                                                price:
                                                    "${latestController.products[index].price} ${latestController.products[index].currency}",
                                                premium: "${latestController.products[index].type}"    
                                              ),
                                            );
                                          }))
                                ],
                              );
                            }),

                        // _buildCardStack(context),
                        // SizedBox(height: 24.v),
                        // _buildFeatureAdsRow(
                        //   context,
                        //   featureAdsText: "Explore more ads",
                        //   seeMoreText: "See more",
                        // ),
                        // SizedBox(height: 10.v),

                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Expanded(
                        //       flex: 2,
                        //       child: Container(
                        //         margin: EdgeInsetsDirectional.only(end: 0),
                        //         child: CustomDropDown(
                        //           // width: 112.h,
                        //           icon: Container(
                        //             margin: EdgeInsets.symmetric(
                        //               horizontal: 2.h,
                        //               vertical: 6.v,
                        //             ),
                        //             child: CustomImageView(
                        //               imagePath:
                        //                   ImageConstant.imgArrowdownGray60001,
                        //               height: 16.adaptSize,
                        //               width: 16.adaptSize,
                        //             ),
                        //           ),
                        //           hintText: "Category",
                        //           hintStyle: TextStyle(fontSize: 12),
                        //           items: dropdownItemList,
                        //           onChanged: (value) {},
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 2,
                        //       child: Container(
                        //         margin: EdgeInsetsDirectional.only(
                        //             end: 5, start: 4),
                        //         child: CustomDropDown(
                        //           icon: Container(
                        //             margin: EdgeInsets.symmetric(
                        //               horizontal: 2.h,
                        //               vertical: 6.v,
                        //             ),
                        //             child: CustomImageView(
                        //               imagePath:
                        //                   ImageConstant.imgArrowdownGray60001,
                        //               height: 16.adaptSize,
                        //               width: 16.adaptSize,
                        //             ),
                        //           ),
                        //           hintText: "City",
                        //           hintStyle: TextStyle(fontSize: 12),
                        //           items: dropdownItemListCities,
                        //           onChanged: (value) {},
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 2,
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: 1, vertical: 7),
                        //         margin: EdgeInsetsDirectional.only(end: 5),
                        //         decoration: BoxDecoration(
                        //             color: appTheme.orange400.withOpacity(0.1),
                        //             borderRadius: BorderRadius.circular(6),
                        //             border: Border.all(
                        //                 width: 1, color: appTheme.orange400)),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             Text(
                        //               "Near By",
                        //               style: TextStyle(
                        //                   color: appTheme.orange400,
                        //                   fontSize: 11),
                        //             ),
                        //             CustomImageView(
                        //                 imagePath: ImageConstant.imgClose,
                        //                 height: 16.adaptSize,
                        //                 width: 16.adaptSize),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //         flex: 2,
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(
                        //               horizontal: 1, vertical: 9),
                        //           decoration: BoxDecoration(
                        //               color: WHITE_COLOR,
                        //               borderRadius: BorderRadius.circular(6)),
                        //           child: Text("Available Photo",
                        //               style: TextStyle(
                        //                   fontSize: 10.5,
                        //                   fontWeight: FontWeight.w600),
                        //               textAlign: TextAlign.center),
                        //         ))
                        //   ],
                        // ),

                        // SizedBox(height: 8.v),
                        // Row(
                        //   children: [
                        //     CustomDropDown(
                        //       width: 112.h,
                        //       icon: Container(
                        //         margin: EdgeInsets.symmetric(
                        //           horizontal: 8.h,
                        //           vertical: 6.v,
                        //         ),
                        //         child: CustomImageView(
                        //           imagePath:
                        //               ImageConstant.imgArrowdownGray60001,
                        //           height: 20.adaptSize,
                        //           width: 20.adaptSize,
                        //         ),
                        //       ),
                        //       hintText: "Most viewed",
                        //       hintStyle: TextStyle(fontSize: 12),
                        //       items: dropdownItemList,
                        //       onChanged: (value) {},
                        //     ),
                        //     GoToMap(context),
                        //   ],
                        // ),

                        // SizedBox(height: 12.v),
                        // _buildCardStack(context),
                        // _buildFavoriteHorizontalScroll1(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            onPressed: () => Get.toNamed("/create_add_screen"),
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.add,
                size: 30,
                color: WHITE_COLOR,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    // begin: Alignment(0.0, 1),
                    end: Alignment(1.0, 1),
                    colors: [
                      theme.colorScheme.primary,
                      appTheme.orange400,
                    ],
                  )

                  //  LinearGradient(
                  //   //  begin: Alignment(-0.11, -0.23),
                  //   end: Alignment(0.60, 0.2),
                  //   colors: [
                  //     Color(0xffD20653),
                  //     Color(0xffFF951D),
                  //   ],
                  // ),

                  ),
            )),
      ),
    );
  }

}
