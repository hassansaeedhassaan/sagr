import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/image_constant.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/categories/domain/entities/category.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/features/countries/domain/entities/country.dart';
import 'package:sagr/features/countries/presentation/controllers/countries_controller.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:sagr/theme/theme_helper.dart';
import 'package:sagr/view/feature_ads_page/feature_ads_page.dart';
import 'package:sagr/view/home_three_screen/home_three_helpers.dart';
import 'package:sagr/view/home_three_screen/widgets/card_stack.dart';
import 'package:sagr/view/home_three_screen/widgets/feature_ads_row.dart';
import 'package:sagr/view/home_three_screen/widgets/most_viewed_dropdown.dart';
import 'package:sagr/widgets/Common/custom_dropdown.dart';
import 'package:sagr/widgets/custom_image_view.dart';
import 'package:sagr/widgets/go_to_map.dart';

/// The "Feature ads" section of the home screen: category/country filters,
/// most-viewed dropdown, map link and the featured products card list.
class FeaturedAdsSection extends StatelessWidget {
  const FeaturedAdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return
                        Container(
                          child: GetBuilder<FeaturedAdsController>(
                              init: FeaturedAdsController(Get.find()),
                              builder: (featuredController) {
                                return Column(
                                  children: [
                                    SizedBox(height: 22.v),
                                    GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FeatureAdsPage())),
                                        child: FeatureAdsRow(
                                          featureAdsText: "Feature ads",
                                          seeMoreText: "See more",
                                        )),
                                    SizedBox(height: 11.v),

                                    // _buildCategoryChipView(context),

                                    //  Text( featuredController.selectedCategory.toString()),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  3, 0, 3, 0),
                                          decoration: BoxDecoration(
                                              color: WHITE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: GetBuilder<
                                                  CategoriesController>(
                                              init: CategoriesController(
                                                  Get.find()),
                                              builder: (catCntr) {
                                                return CustomDropdownV2<
                                                    Category?>(
                                                  onChange: (int index) =>
                                                      featuredController
                                                          .setFeaturedSelectedCategory(
                                                              catCntr.categories[
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
                                                  dropdownStyle: DropdownStyle(
                                                      width: 160,
                                                      color: WHITE_COLOR,
                                                      elevation: 0,
                                                      padding:
                                                          EdgeInsets.all(0),
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
                                                  child: Text(featuredController
                                                              .selectedCategory
                                                              .id !=
                                                          null
                                                      ? featuredController
                                                          .selectedCategory
                                                          .name!
                                                          .capitalize!
                                                      : "Category".tr),
                                                );
                                              }),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(3, 0, 3, 0),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(3, 0, 3, 0),
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
                                                          featuredController
                                                              .setFeaturedSelectedCountry(
                                                                  catCntr.countries[
                                                                      index]),
                                                      dropdownButtonStyle:
                                                          DropdownButtonStyle(
                                                        shape: RoundedRectangleBorder(
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
                                                              color:
                                                                  WHITE_COLOR,
                                                              elevation: 0,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            0,
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
                                                                        .all(
                                                                        8.0),
                                                                child: Text(item
                                                                    .value
                                                                    .name!),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                      child: Text(featuredController
                                                                  .selectedCountry
                                                                  .id !=
                                                              null
                                                          ? featuredController
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

                                              featuredController.nearByFilter();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1, vertical: 8),
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      end: 0),
                                              decoration: !featuredController
                                                      .nearBy
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Near By",
                                                    style: TextStyle(
                                                        color:
                                                            !featuredController
                                                                    .nearBy
                                                                ? null
                                                                : appTheme
                                                                    .orange400,
                                                        fontSize: 13),
                                                  ),
                                                  !featuredController.nearBy
                                                      ? SizedBox.shrink()
                                                      : CustomImageView(
                                                          imagePath:
                                                              ImageConstant
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
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: InkWell(
                                            onTap: () => featuredController
                                                .toggleAvailablePhoto(),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    color: featuredController
                                                            .available_photo_featured_secction
                                                        ? appTheme.orange400
                                                            .withOpacity(0.1)
                                                        : WHITE_COLOR,
                                                    border: featuredController
                                                            .available_photo_featured_secction
                                                        ? Border.all(
                                                            width: 1,
                                                            color: appTheme
                                                                .orange400)
                                                        : Border(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      featuredController
                                                              .available_photo_featured_secction
                                                          ? MainAxisAlignment
                                                              .spaceAround
                                                          : MainAxisAlignment
                                                              .center,
                                                  children: [
                                                    Text("Available Photo",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: featuredController
                                                                  .available_photo_featured_secction
                                                              ? appTheme
                                                                  .orange400
                                                              : BLACK_COLOR,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                    featuredController
                                                            .available_photo_featured_secction
                                                        ? CustomImageView(
                                                            imagePath:
                                                                ImageConstant
                                                                    .imgClose,
                                                            height:
                                                                16.adaptSize,
                                                            width: 16.adaptSize)
                                                        : SizedBox.shrink(),
                                                  ],
                                                )),
                                          ),
                                        ),

                                        // MOST VIEWS Dropdown List
                                        MostViewdDropDown(),


  GetBuilder<FeaturedAdsController>(
                            init: FeaturedAdsController(Get.find()),
                            builder: (latestController) {





                                     return  GoToMap(context, latestController.products);

                            })

                                       
                                      ],
                                    ),
                                    SizedBox(height: 12.v),

                                    featuredController.productsLoading
                                        ? SizedBox(
                                            height: 300,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : CardStack(
                                            products: featuredController.products),
                                  ],
                                );
                              }),
                        )
    ;
  }
}
