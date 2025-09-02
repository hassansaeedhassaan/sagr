import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/products/presentation/controllers/product_controller.dart';

import '../../data/colors.dart';
import '../../features/countries/domain/entities/country.dart';
import '../../features/countries/presentation/controllers/countries_controller.dart';
import '../../features/products/data/models/city_model.dart';
import '../../features/products/data/models/state_model.dart';
import '../../features/products/domain/entities/product.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/Common/custom_dropdown.dart';
import '../../widgets/custom_elevated_button.dart';

// ignore_for_file: must_be_immutable
class ShareYourAddsFourPage extends StatefulWidget {

   final Product? product;
  const ShareYourAddsFourPage(this.product,{Key? key})
      : super(
          key: key,
        );

  @override
  ShareYourAddsFourPageState createState() => ShareYourAddsFourPageState();
}

class ShareYourAddsFourPageState extends State<ShareYourAddsFourPage>
    with AutomaticKeepAliveClientMixin<ShareYourAddsFourPage> {
  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  List<String> dropdownItemList1 = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  List<String> dropdownItemList2 = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  Completer<GoogleMapController> googleMapController = Completer();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        // width: double.maxFinite,
        // decoration: AppDecoration.fillGray,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          SizedBox(height: 16.h),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.h,
                    vertical: 11.v,
                  ),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add address info ",
                        style:
                            CustomTextStyles.titleMediumBluegray90001_1,
                      ),
                      SizedBox(height: 12.v),

                      CreateAdCountryDropDown(),
                      
                      SizedBox(height: 12.v),
                      
                      CreateAdStateDropDown(),
                      SizedBox(height: 12.v),
                      CreateAdCityDropDown(),
                      SizedBox(height: 12.v),
                      _buildMapSection(context),
                      SizedBox(height: 12.v),
                    ],
                  ),
                ),
              ),
            ),
            _buildUpdateSection(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMapSection(BuildContext context) {
    return SizedBox(
      height: 224.v,
      width: 374.h,
      child: GoogleMap(
        //TODO: Add your Google Maps API key in AndroidManifest.xml and pod file
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            37.43296265331129,
            -122.08832357078792,
          ),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildUpdateSection(BuildContext context) {
    return GetBuilder(builder: (ProductController _prodCntr){
      return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 0.v),
        padding: EdgeInsets.symmetric(
          horizontal: 24.h,
          vertical: 16.v,
        ),
        decoration: AppDecoration.fillOnPrimary,
        child: CustomElevatedButton(
          onPressed: () => _prodCntr.updateAd(3),
          text: "Update ",
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
        ),
      ),
    );
    });
  }
}




class CreateAdCountryDropDown extends StatelessWidget {
  CreateAdCountryDropDown({super.key});

  @override
  Widget build(BuildContext context) {


    return GetBuilder(builder: (ProductController _prodCntr) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: GREY_COLOR),
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (CountriesController _countryCntr) {
              return CustomDropdownV2<Country?>(
                // onChange: (int index) => print(_countryCntr.countries[index]),
                onChange: (int index) => _prodCntr
                    .setFeaturedSelectedCountry(_countryCntr.countries[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  // backgroundColor: Colors.red,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                    // width: 112,
                    color: WHITE_COLOR,
                    elevation: 2,
                    padding: EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8))),
                items: _countryCntr.countries
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<Country?>(
                        value: item.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.value.name!),
                        ),
                      ),
                    )
                    .toList(),
                child: 
                Text(_prodCntr.selectedCountry.name.toString()),
              );
            }),
      );
    });
  }
}

class CreateAdStateDropDown extends StatelessWidget {
  CreateAdStateDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (ProductController _prodCntr) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: GREY_COLOR),
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (CountriesController _countryCntr) {
              return CustomDropdownV2<StateModel?>(
                // onChange: (int index) => print(_countryCntr.countries[index]),
                onChange: (int index) =>
                    _prodCntr.setFeaturedSelectedState(
                        _prodCntr.selectedCountry.states![index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  // backgroundColor: Colors.red,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                    // width: 112,
                    color: WHITE_COLOR,
                    elevation: 2,
                    padding: EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8))),
                items: _prodCntr.selectedCountry.name == null
                    ? []
                    : _prodCntr.selectedCountry.states!
                        .asMap()
                        .entries
                        .map(
                          (item) => DropdownItem<StateModel?>(
                            value: item.value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item.value.name),
                            ),
                          ),
                        )
                        .toList(),
                child: Text(_prodCntr.selectedState.name != ""
                    ? _prodCntr.selectedState.name.toString()
                    : "State"),
              );
            }),
      );
    });
  }
}

class CreateAdCityDropDown extends StatelessWidget {
  CreateAdCityDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(Get.find(), Get.find()),
        builder: (ProductController _prodCntr) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: GREY_COLOR),
                color: WHITE_COLOR,
                borderRadius: BorderRadius.circular(8)),
            child: GetBuilder<CountriesController>(
                init: CountriesController(Get.find()),
                builder: (CountriesController _countryCntr) {
                  return CustomDropdownV2<CityModel?>(
                    // onChange: (int index) => print(_countryCntr.countries[index]),
                    onChange: (int index) =>
                        _prodCntr.setFeaturedSelectedCity(
                            _prodCntr.selectedState.cities![index]),
                    dropdownButtonStyle: DropdownButtonStyle(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      height: 38,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      // backgroundColor: Colors.red,
                      primaryColor: Colors.black87,
                    ),
                    dropdownStyle: DropdownStyle(
                        // width: 112,
                        color: WHITE_COLOR,
                        elevation: 2,
                        padding: EdgeInsets.all(2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8))),
                    items: _prodCntr.selectedState.name == ''
                        ? []
                        : _prodCntr.selectedState.cities!
                            .asMap()
                            .entries
                            .map(
                              (item) => DropdownItem<CityModel?>(
                                value: item.value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item.value.name),
                                ),
                              ),
                            )
                            .toList(),
                    child: Text(_prodCntr.selectedCity.name != ""
                        ? _prodCntr.selectedCity.name.toString()
                        : "City"),
                  );
                }),
          );
        });
  }
}
