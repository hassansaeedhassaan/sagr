import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/features/countries/domain/entities/country.dart';
import 'package:sagr/features/countries/presentation/controllers/countries_controller.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:sagr/features/latest/presentation/controllers/latest_ads_controller.dart';
import 'package:sagr/features/latest/presentation/screens/latest_ads_page.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/view/feature_ads_page/feature_ads_page.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/appbar/build_core_app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/image_constant.dart';
import '../../features/banner/presentation/controllers/banner_controller.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/Common/custom_dropdown.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/go_to_map.dart';
import '../home_three_screen/widgets/categorychipview_item_widget.dart';
import '../home_three_screen/widgets/categorygrid_item_widget.dart';

import 'package:flutter/material.dart';

class HomeThreeScreen extends StatelessWidget {
  HomeThreeScreen({Key? key})
      : super(
          key: key,
        );


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

    Future<void> appLaunchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
  

  List<Widget> _myWidget(int count) {
    return List.generate(
        count,
        (i) => Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              child: SizedBox(
                height: 70,
                width: 70,
                child: Shimmer(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 36),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(248, 250, 124, 124),
                        //  border: Border.all(width: 0),
                        borderRadius: BorderRadiusStyle.roundedBorder12,
                      ),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFEBEBF4),
                        Color.fromARGB(255, 243, 243, 243),
                        Color(0xFFEBEBF4),
                      ],
                      stops: [
                        0.1,
                        0.3,
                        0.4,
                      ],
                      begin: Alignment(-1.0, -0.3),
                      end: Alignment(1.0, 0.3),
                      tileMode: TileMode.clamp,
                    )),
              ),
            ))).toList(); // replace * with your rupee or use Icon instead
  }

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
                        

                            child: _buildFeatureAdsRow(
                              context,
                              featureAdsText: "Categories",
                              seeMoreText: "See more",
                            )),

                        SizedBox(height: 10.v),

                        _buildCategoryGrid(context),
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

                        _buildCategoryGridSub(context),
                        _buildCategoryGridSSub(context),
                        _buildCategoryGridThSub(context),
                        // SizedBox(child: Row(children: _myWidget(5))),


   
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
                                        child: _buildFeatureAdsRow(
                                          context,
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
                                              
                                              _determinePosition();

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
                                        : _buildCardStack(context,
                                            featuredController.products),
                                  ],
                                );
                              }),
                        ),


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
                                    child: _buildFeatureAdsRow(
                                      context,
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
                                            _determinePosition();

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
                                              child: _buildCardColumn(
                                                id: latestController
                                                    .products[index].id!,
                                                context,
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

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 70.v,
      leadingWidth: 54.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgGlobe,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 8.h),
        child: Row(
          children: [
            AppbarTitleIconbutton(
              imagePath: ImageConstant.imgSearch141BlueGray90001,
            ),
            AppbarTitleImage(
              imagePath: ImageConstant.imgLayer1,
              margin: EdgeInsets.only(
                left: 60.h,
                top: 2.v,
                bottom: 3.v,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgVuesaxTwotoneNotification,
          margin: EdgeInsets.only(
            left: 15.h,
            top: 16.v,
            right: 16.h,
          ),
        ),
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgClockPrimary,
          margin: EdgeInsets.only(
            left: 8.h,
            top: 16.v,
            right: 31.h,
          ),
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildCategoryGrid(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   mainAxisExtent: 90.v,
              //   crossAxisCount: 5,
              //   mainAxisSpacing: 10.h,
              //   crossAxisSpacing: 10.h,
              // ),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                return CategorygridItemWidget(
                  onPressed: () => categoryController
                      .getChildLevelOne(categoryController.categories[index].id!),
                  category: categoryController.categories[index],
                );
              },
            ),
          );
        });
  }

  /// Section Widget
  Widget _buildCategoryGridSub(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return categoryController.productsLoading
              ? SizedBox(child: Row(children: _myWidget(5)))
              : SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   mainAxisExtent: 90.v,
                    //   crossAxisCount: 5,
                    //   mainAxisSpacing: 10.h,
                    //   crossAxisSpacing: 10.h,
                    // ),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: categoryController.subCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        // onTap: () => categoryController.getChildLevelTwo(
                        //     categoryController.subCategories[index].id!),
                        child: CategorygridItemWidget(
                          onPressed: () => categoryController.getChildLevelTwo(
                              categoryController.subCategories[index].id!),
                          category: categoryController.subCategories[index],
                          type: "sub",
                        ),
                      );
                    },
                  ),
                );
        });
  }

  /// Section Widget
  Widget _buildCategoryGridSSub(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return SizedBox(
            height: categoryController.subCategoriesTwo.length > 0 ? 100 : 0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   mainAxisExtent: 90.v,
              //   crossAxisCount: 5,
              //   mainAxisSpacing: 10.h,
              //   crossAxisSpacing: 10.h,
              // ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: categoryController.subCategoriesTwo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => categoryController.getChildLevelThird(
                      categoryController.subCategoriesTwo[index].id!),
                  child: CategorygridItemWidget(
                      category: categoryController.subCategoriesTwo[index]),
                );
              },
            ),
          );
        });
  }

  /// Section Widget
  Widget _buildCategoryGridThSub(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 90.v,
              crossAxisCount: 5,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.h,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryController.thirdLevelSubCategories.length,
            itemBuilder: (context, index) {
              return CategorygridItemWidget(
                  category: categoryController.thirdLevelSubCategories[index]);
            },
          );
        });
  }

  /// Section Widget
  Widget _buildCategoryChipView(BuildContext context) {
    return Wrap(
      runSpacing: 8.v,
      spacing: 8.h,
      children:
          List<Widget>.generate(4, (index) => CategorychipviewItemWidget()),
    );
  }

  /// Section Widget
  Widget _buildCardStack(BuildContext context, List<Product> products) {
    return SizedBox(
        height: 258.v,
        width: 398.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 5),
                child: _buildCardColumn(
                  id: products[index].id!,
                  context,
                  negotiable: products.elementAt(index).isNegotiable.toString(),
                  cars: "#cars",
                  image: products[index].image!,
                  inVar: " in ${products[index].created_at}",
                  mercedesBenz: products[index].name,
                  dakahliaMansoura:
                      "${products[index].nationality.name}, ${products[index].city!.name}",
                  price: "${products[index].price} ${products[index].currency}",
                  premium: "${products[index].type}"
                ),
              );
            }));

    return SizedBox(
      height: 258.v,
      width: 398.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        // alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 5),
            // child: _buildCardColumn(
            //   context,
            //   negotiable: "Negotiable",
            //   image: "",
            //   cars: "#cars",
            //   inVar: " in 22/1/2023",
            //   mercedesBenz: "Mercedes-Benz ",
            //   dakahliaMansoura: "Dakahlia, Mansoura",
            //   price: "1000 EGP",
            // ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 5),
            // child: _buildCardColumn(
            //   context,
            //   negotiable: "Negotiable",
            //   image: "",
            //   cars: "#cars",
            //   inVar: " in 22/1/2023",
            //   mercedesBenz: "Mercedes-Benz ",
            //   dakahliaMansoura: "Dakahlia, Mansoura",
            //   price: "1000 EGP",
            // ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 5),
            // child: _buildCardColumn(
            //   context,
            //   negotiable: "Negotiable",
            //   image: "",
            //   cars: "#cars",
            //   inVar: " in 22/1/2023",
            //   mercedesBenz: "Mercedes-Benz ",
            //   dakahliaMansoura: "Dakahlia, Mansoura",
            //   price: "1000 EGP",
            // ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: 5),
            // child: _buildCardColumn(
            //   context,
            //   image: "",
            //   negotiable: "Negotiable",
            //   cars: "#cars",
            //   inVar: " in 22/1/2023",
            //   mercedesBenz: "Mercedes-Benz ",
            //   dakahliaMansoura: "Dakahlia, Mansoura",
            //   price: "1000 EGP",
            // ),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: IntrinsicWidth(
          //       child: Column(
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               SizedBox(
          //                 height: 147.v,
          //                 width: 173.h,
          //                 child: Stack(
          //                   alignment: Alignment.topCenter,
          //                   children: [
          //                     CustomImageView(
          //                       imagePath: ImageConstant.imgRectangle12,
          //                       height: 147.v,
          //                       width: 173.h,
          //                       radius: BorderRadius.vertical(
          //                         top: Radius.circular(12.h),
          //                       ),
          //                       alignment: Alignment.center,
          //                     ),
          //                     Align(
          //                       alignment: Alignment.topCenter,
          //                       child: Padding(
          //                         padding: EdgeInsets.only(top: 8.v),
          //                         child: Row(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           mainAxisSize: MainAxisSize.min,
          //                           children: [
          //                             CustomIconButton(
          //                               height: 28.adaptSize,
          //                               width: 28.adaptSize,
          //                               padding: EdgeInsets.all(4.h),
          //                               child: CustomImageView(
          //                                 imagePath: ImageConstant.imgFavorite,
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: EdgeInsets.only(left: 8.h),
          //                               child: CustomIconButton(
          //                                 height: 28.adaptSize,
          //                                 width: 28.adaptSize,
          //                                 padding: EdgeInsets.all(5.h),
          //                                 child: CustomImageView(
          //                                   imagePath:
          //                                       ImageConstant.imgGroup58519,
          //                                 ),
          //                               ),
          //                             ),
          //                             Container(
          //                               width: 80.h,
          //                               margin: EdgeInsets.only(left: 13.h),
          //                               padding: EdgeInsets.symmetric(
          //                                 horizontal: 10.h,
          //                                 vertical: 4.v,
          //                               ),
          //                               decoration:
          //                                   AppDecoration.fillTealA.copyWith(
          //                                 borderRadius:
          //                                     BorderRadiusStyle.roundedBorder8,
          //                               ),
          //                               child: Text(
          //                                 "Negotiable",
          //                                 style: CustomTextStyles
          //                                     .labelLargeOnPrimary,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.only(left: 189.h),
          //                 child: _buildFavoriteStack(
          //                   context,
          //                   negotiableText: "Negotiable",
          //                 ),
          //               ),
          //             ],
          //           ),
          //           _buildCars(
          //             context,
          //             cars: "#cars",
          //             inVar: " in 22/1/2023",
          //             mercedesBenz: "Mercedes-Benz ",
          //             dakahliaMansoura: "Dakahlia, Mansoura",
          //             price: "1000 EGP",
          //             cars1: "#cars",
          //             in1: " in 22/1/2023",
          //             mercedesBenz1: "Mercedes-Benz ",
          //             dakahliaMansoura1: "Dakahlia, Mansoura",
          //             price1: "1000 EGP",
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildFeatureAdsRow(
    BuildContext context, {
    required String featureAdsText,
    required String seeMoreText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          featureAdsText,
          style: theme.textTheme.titleLarge!.copyWith(
            color: appTheme.blueGray90001,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.v),
          child: Text(
            seeMoreText,
            style: CustomTextStyles.titleSmallPrimary_1.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildFavoriteStack(
    BuildContext context, {
    required String negotiableText,
  }) {
    return SizedBox(
      height: 147.v,
      width: 173.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle12,
            height: 147.v,
            width: 173.h,
            radius: BorderRadius.vertical(
              top: Radius.circular(12.h),
            ),
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 157.h,
              margin: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                    padding: EdgeInsets.all(4.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFavorite,
                    ),
                  ),
                  Container(
                    width: 80.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.h,
                      vertical: 4.v,
                    ),
                    decoration: AppDecoration.fillTealA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Text(
                      negotiableText,
                      style: CustomTextStyles.labelLargeOnPrimary.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildCardColumn(
    BuildContext context, {
    required int id,
    required String negotiable,
    required String cars,
    required String inVar,
    required String mercedesBenz,
    required String dakahliaMansoura,
    required String price,
    required String image,
    required String premium,
  }) {
    return InkResponse(
      onTap: () => Get.toNamed('/product_detail_screen', arguments: id),

      // onTap: () => Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => AdsDetailsScreen())),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 147.v,
            width: 173.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 147.v,
                  width: 173.h,
                  child: image == ""
                      ? Image.asset("assets/images/logo.png")
                      : ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.h),
                          ),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          height: 28.adaptSize,
                          width: 28.adaptSize,
                          padding: EdgeInsets.all(4.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFavorite,
                          ),
                        ),
              

                
                      premium != "free"  ?  SizedBox.shrink() : Padding(
                          padding: EdgeInsets.only(left: 0.h),
                          child: CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup58519,
                            ),
                          ),
                        ),
                        Container(
                          width: 80.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 4.v,
                          ),
                            decoration: negotiable != 'true' ?  BoxDecoration() : AppDecoration.fillTealA.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: negotiable == 'true' ?  Text(
                            negotiable == 'true' ? "Negotiable" : "",
                            style:
                                CustomTextStyles.labelLargeOnPrimary.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(1),
                            ),
                          ): SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 173.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 6.v,
            ),
            decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.customBorderBL12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cars,
                        style: CustomTextStyles.bodySmallOrange400.copyWith(
                          color: appTheme.orange400,
                        ),
                      ),
                      Text(
                        inVar,
                        style: CustomTextStyles.bodySmall10.copyWith(
                          color: appTheme.gray60001,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.v),
                Flexible(
                  child: Text(
                    mercedesBenz,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleSmallSemiBold.copyWith(
                      color: appTheme.blueGray90001,
                    ),
                  ),
                ),
                SizedBox(height: 5.v),
                Padding(
                  padding: EdgeInsets.only(right: 13.h),
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgLinkedin,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        margin: EdgeInsets.only(
                          top: 1.v,
                          bottom: 2.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: FittedBox(
                          child: Container(
                            width: 122,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              dakahliaMansoura,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: appTheme.blueGray90001,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.v),
                Text(
                  price,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildCars(
    BuildContext context, {
    required String cars,
    required String inVar,
    required String mercedesBenz,
    required String dakahliaMansoura,
    required String price,
    required String cars1,
    required String in1,
    required String mercedesBenz1,
    required String dakahliaMansoura1,
    required String price1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.h,
            vertical: 6.v,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
            borderRadius: BorderRadiusStyle.customBorderBL12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 155.h,
                margin: EdgeInsets.only(right: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cars,
                      style: CustomTextStyles.bodySmallOrange400.copyWith(
                        color: appTheme.orange400,
                      ),
                    ),
                    Text(
                      inVar,
                      style: CustomTextStyles.bodySmall10.copyWith(
                        color: appTheme.gray60001,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.v),
              Text(
                mercedesBenz,
                style: CustomTextStyles.titleSmallSemiBold.copyWith(
                  color: appTheme.blueGray90001,
                ),
              ),
              SizedBox(height: 5.v),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgLinkedin,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      top: 1.v,
                      bottom: 2.v,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      dakahliaMansoura,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.blueGray90001,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.v),
              Text(
                price,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 189.h),
          padding: EdgeInsets.symmetric(
            horizontal: 8.h,
            vertical: 6.v,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
            borderRadius: BorderRadiusStyle.customBorderBL12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cars1,
                    textAlign: TextAlign.justify,
                    style: CustomTextStyles.bodySmallOrange400.copyWith(
                      color: appTheme.orange400,
                    ),
                  ),
                  Text(
                    in1,
                    style: CustomTextStyles.bodySmall10.copyWith(
                      color: appTheme.gray60001,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.v),
              Text(
                mercedesBenz1,
                textAlign: TextAlign.justify,
                style: CustomTextStyles.titleSmallSemiBold.copyWith(
                  color: appTheme.blueGray90001,
                ),
              ),
              SizedBox(height: 5.v),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgLinkedin,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      top: 1.v,
                      bottom: 2.v,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      dakahliaMansoura1,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.blueGray90001,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.v),
              Text(
                price1,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Common widget
  Widget _buildCardColumn1(
    BuildContext context, {
    required String negotiable,
    required String negotiable1,
    required String cars,
    required String inVar,
    required String mercedesBenz,
    required String dakahliaMansoura,
    required String price,
    required String cars1,
    required String in1,
    required String mercedesBenz1,
    required String dakahliaMansoura1,
    required String price1,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 147.v,
              width: 173.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgRectangle12,
                    height: 147.v,
                    width: 173.h,
                    radius: BorderRadius.vertical(
                      top: Radius.circular(12.h),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 157.h,
                      margin: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgFavorite,
                            ),
                          ),
                          Container(
                            width: 80.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                              vertical: 4.v,
                            ),
                            decoration: AppDecoration.fillTealA.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                            ),
                            child: Text(
                              negotiable,
                              style:
                                  CustomTextStyles.labelLargeOnPrimary.copyWith(
                                color:
                                    theme.colorScheme.onPrimary.withOpacity(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 147.v,
              width: 173.h,
              margin: EdgeInsets.only(left: 189.h),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgRectangle12,
                    height: 147.v,
                    width: 173.h,
                    radius: BorderRadius.vertical(
                      top: Radius.circular(12.h),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 157.h,
                      margin: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgFavorite,
                            ),
                          ),
                          Container(
                            width: 80.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                              vertical: 4.v,
                            ),
                            decoration: AppDecoration.fillTealA.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                            ),
                            child: Text(
                              negotiable1,
                              style:
                                  CustomTextStyles.labelLargeOnPrimary.copyWith(
                                color:
                                    theme.colorScheme.onPrimary.withOpacity(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 6.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.customBorderBL12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 155.h,
                    margin: EdgeInsets.only(right: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cars,
                          style: CustomTextStyles.bodySmallOrange400.copyWith(
                            color: appTheme.orange400,
                          ),
                        ),
                        Text(
                          inVar,
                          style: CustomTextStyles.bodySmall10.copyWith(
                            color: appTheme.gray60001,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    mercedesBenz,
                    style: CustomTextStyles.titleSmallSemiBold.copyWith(
                      color: appTheme.blueGray90001,
                    ),
                  ),
                  SizedBox(height: 5.v),
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgLinkedin,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        margin: EdgeInsets.only(
                          top: 1.v,
                          bottom: 2.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          dakahliaMansoura,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: appTheme.blueGray90001,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    price,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 189.h),
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 6.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.customBorderBL12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cars1,
                        textAlign: TextAlign.justify,
                        style: CustomTextStyles.bodySmallOrange400.copyWith(
                          color: appTheme.orange400,
                        ),
                      ),
                      Text(
                        in1,
                        style: CustomTextStyles.bodySmall10.copyWith(
                          color: appTheme.gray60001,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    mercedesBenz1,
                    textAlign: TextAlign.justify,
                    style: CustomTextStyles.titleSmallSemiBold.copyWith(
                      color: appTheme.blueGray90001,
                    ),
                  ),
                  SizedBox(height: 5.v),
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgLinkedin,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        margin: EdgeInsets.only(
                          top: 1.v,
                          bottom: 2.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          dakahliaMansoura1,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: appTheme.blueGray90001,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    price1,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Handling page based on route
  // Widget getCurrentPage(String currentRoute) {
  //   switch (currentRoute) {
  //     case AppRoutes.featureAdsPage:
  //       return FeatureAdsPage();
  //     case AppRoutes.categoryPage:
  //       return CategoryPage();
  //     default:
  //       return DefaultWidget();
  //   }
  // }
}

class MostViewdDropDown extends StatelessWidget {
  MostViewdDropDown({super.key});

  final List<String> dropdownItemList = [
    "today",
    "yesterday",
    "week",
    "month",
    "month_2",
    "month_3",
    "month_6",
    "year",
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (FeaturedAdsController featuredController) {
      return Container(
        width: 118,
        margin: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
        decoration: BoxDecoration(
            color: WHITE_COLOR, borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<String?>(
                onChange: (int index) => featuredController
                    .setFeaturedSelectedMostVied(dropdownItemList[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  // backgroundColor: Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                    width: 112,
                    color: WHITE_COLOR,
                    elevation: 0,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8))),
                items: dropdownItemList
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<String?>(
                        value: item.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.value.tr),
                        ),
                      ),
                    )
                    .toList(),
                child: Text(featuredController.selectedMostViewed != ""
                    ? featuredController.selectedMostViewed.tr
                    : "Most Viewed"),
              );
            }),
      );
    });
  }
}

class MostViewdDropDownLatestSection extends StatelessWidget {
  MostViewdDropDownLatestSection({super.key});

  final List<String> dropdownItemList = [
    "today",
    "yesterday",
    "week",
    "month",
    "month_2",
    "month_3",
    "month_6",
    "year",
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (LatestAdsController latestAdsController) {
      return Container(
        width: 118,
        margin: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
        decoration: BoxDecoration(
            color: WHITE_COLOR, borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<String?>(
                onChange: (int index) => latestAdsController
                    .setFeaturedSelectedMostVied(dropdownItemList[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  // backgroundColor: Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                    width: 112,
                    color: WHITE_COLOR,
                    elevation: 0,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8))),
                items: dropdownItemList
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<String?>(
                        value: item.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.value.tr),
                        ),
                      ),
                    )
                    .toList(),
                child: Text(latestAdsController.selectedMostViewed != ""
                    ? latestAdsController.selectedMostViewed.tr
                    : "Most Viewed"),
              );
            }),
      );
    });
  }
}
