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
import '../home_three_screen/widgets/latest_ads_section.dart';
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
                            child: FeatureAdsRow(
                              featureAdsText: "Categories",
                              seeMoreText: "See more",
                            )),

                        SizedBox(height: 10.v),

                        const CategoryGridSection(),
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

                        const LatestAdsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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


                  ),
            )),
      ),
    );
  }

}
