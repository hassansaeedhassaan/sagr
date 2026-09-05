import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/countries/presentation/controllers/countries_controller.dart';
import 'package:sagr/features/featured/presentation/controllers/featured_ads_controller.dart';
import 'package:sagr/features/latest/presentation/controllers/latest_ads_controller.dart';
import 'package:sagr/widgets/Common/custom_dropdown.dart';

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
