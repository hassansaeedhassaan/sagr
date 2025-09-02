import 'dart:async';
import 'dart:io';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/features/countries/domain/entities/country.dart';
import 'package:sagr/features/products/data/models/city_model.dart';
import 'package:sagr/features/products/data/models/state_model.dart';
import 'package:sagr/features/products/presentation/controllers/create_ad_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:video_player/video_player.dart';

import '../core/utils/image_constant.dart';
import '../features/categories/domain/entities/category.dart';
import '../features/countries/presentation/controllers/countries_controller.dart';
import '../theme/app_decoration.dart';
import '../theme/custom_button_style.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import '../widgets/Common/custom_dropdown.dart';
import '../widgets/appbar/basic_app_bar.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'widgets/Forms/easy_app_text_form_field.dart';

class CreateAdScreen extends StatelessWidget {
  final CreateAdController _controller;

//  final int _currentStep = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Completer<GoogleMapController> googleMapController = Completer();

  CreateAdScreen(this._controller, {Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: GetBuilder(builder: (CreateAdController _createAdCntr) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(66),
              child: BasicAppBar(title: "Share your ad.")),
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            width: SizeUtils.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    _createAdCntr.currentStep == 1
                        ? FadedSlideAnimation(
                            beginOffset: Offset(0.0, 3),
                            endOffset: Offset(0.0, 0),
                            slideDuration: Duration(milliseconds: 500),
                            fadeDuration: Duration(milliseconds: 500),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.h),
                              padding: EdgeInsets.all(12.h),
                              decoration: AppDecoration.fillOnPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload attachments ",
                                    style: CustomTextStyles
                                        .titleMediumBluegray90001_1,
                                  ),
                                  Text(
                                    "You can add maximum 20 images or 5 videos.",
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  SizedBox(height: 10.v),
                                  _buildMediaImages(context),
                                  SizedBox(height: 16.v),
                                  _buildFrame1(context),
                                  SizedBox(height: 16.v),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 12.v),
                    _createAdCntr.currentStep == 2
                        ? FadedSlideAnimation(
                            beginOffset: Offset(0.0, 3),
                            endOffset: Offset(0.0, 0),
                            slideDuration: Duration(milliseconds: 500),
                            fadeDuration: Duration(milliseconds: 500),
                            child: Container(
                              height: MediaQuery.of(context).size.height - 250,
                              margin: EdgeInsets.symmetric(horizontal: 16.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.h,
                                vertical: 11.v,
                              ),
                              decoration: AppDecoration.fillOnPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder12,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add info",
                                      style: CustomTextStyles
                                          .titleMediumBluegray90001_1,
                                    ),
                                    SizedBox(height: 12.v),

                                    CategoryDropDown(),

                                    SizedBox(height: 12.v),
                                    EasyAppTextFormField(
                                        initialValue: _createAdCntr.title,
                                        onChanged: (value) =>
                                            _createAdCntr.title = value!,
                                        labelText: "Title".tr,
                                        hintText: "Title".tr),

                                    SizedBox(height: 12.v),

                                    EasyAppTextFormField(
                                        initialValue: _createAdCntr.description,
                                        onChanged: (value) =>
                                            _createAdCntr.description = value!,
                                        labelText: "Description".tr,
                                        hintText: "Description".tr,
                                        multiline: 6),
                                    // _buildAddDescriptionSection(context),
                                    SizedBox(height: 12.v),
                                    // Container(
                                    //   margin: EdgeInsets.only(bottom: 2),
                                    //   child: Text("Price Type".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    // ),
                                    PriceTypeDropdown(),
                                    SizedBox(height: 12.v),
                                    _buildAddFrameSection(context),
                                    SizedBox(height: 12.v),
                                    EasyAppTextFormField(
                                        initialValue: _createAdCntr.phone,
                                        onChanged: (value) =>
                                            _createAdCntr.phone = value!,
                                        labelText: "Phone number",
                                        hintText: "Phone number"),
                                    SizedBox(height: 12.v),
                                    EasyAppTextFormField(
                                        initialValue: _createAdCntr.whatsapp,
                                        onChanged: (value) =>
                                            _createAdCntr.whatsapp = value!,
                                        labelText: "Whats app number",
                                        hintText: "Whats app number")
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    _createAdCntr.currentStep == 3
                        ? FadedSlideAnimation(
                            beginOffset: Offset(0.0, 3),
                            endOffset: Offset(0.0, 0),
                            slideDuration: Duration(milliseconds: 500),
                            fadeDuration: Duration(milliseconds: 500),
                            // beginOffset: Offset(0.5, 20),
                            // endOffset: Offset(0.0, 0),
                            // slideDuration: Duration(milliseconds: 500),
                            // fadeDuration: Duration(milliseconds: 1000),
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
                                    "Add address info",
                                    style: CustomTextStyles
                                        .titleMediumBluegray90001_1,
                                  ),
                                  SizedBox(height: 12.v),

                                  CreateAdCountryDropDown(),

                                  SizedBox(height: 12.v),
                                  CreateAdStateDropDown(),

                                  SizedBox(height: 12.v),
                                  CreateAdCityDropDown(),
                                  SizedBox(height: 12.v),
                                  _buildMapSection(context),
                                  SizedBox(height: 15.v),

                                  // _buildFrameSection(context),

                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () =>
                                              _createAdCntr.setAdPremium(false),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 44,
                                            decoration: BoxDecoration(
                                                // color: PURPLE_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        _createAdCntr.isPremium
                                                            ? GREY_COLOR
                                                            : ZAHRA_RED)),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child:
                                                        Text("Normal Ad".tr)),
                                                Container(
                                                    width: 20.h,
                                                    height: 20.h,
                                                    decoration: BoxDecoration(
                                                        // color: RED_COLOR,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: _createAdCntr
                                                                    .isPremium
                                                                ? GREY_COLOR
                                                                : ZAHRA_RED)),
                                                    child:
                                                        _createAdCntr.isPremium
                                                            ? SizedBox.shrink()
                                                            : Container(
                                                                height: 5,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        ZAHRA_RED,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                              ))
                                              ],
                                            ),
                                          ),
                                        )),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () =>
                                              _createAdCntr.setAdPremium(true),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 44,
                                            decoration: BoxDecoration(
                                                // color: PURPLE_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        _createAdCntr.isPremium
                                                            ? ZAHRA_RED
                                                            : GREY_COLOR)),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              8.h,
                                                              13.v,
                                                              6.h,
                                                              13.v),
                                                      child: CustomImageView(
                                                        imagePath: ImageConstant
                                                            .imgVuesaxLinearCrown,
                                                        height: 20.adaptSize,
                                                        width: 20.adaptSize,
                                                      ),
                                                    ),
                                                    Text("Premium Ad".tr)
                                                  ],
                                                )),
                                                Container(
                                                  width: 20.h,
                                                  height: 20.h,
                                                  decoration: BoxDecoration(
                                                      // color: RED_COLOR,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          width: 1.4,
                                                          color: _createAdCntr
                                                                  .isPremium
                                                              ? ZAHRA_RED
                                                              : GREY_COLOR
                                                                  .withOpacity(
                                                                      0.6))),
                                                  child: !_createAdCntr
                                                          .isPremium
                                                      ? SizedBox.shrink()
                                                      : Container(
                                                          height: 5,
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                              color: ZAHRA_RED,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.v),
                                  _createAdCntr.isPremium
                                      ? _bePremiumSection(context)
                                      : SizedBox.shrink(),
                                  SizedBox(height: 20.v),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: WHITE_COLOR,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 16.v),
              decoration: AppDecoration.fillOnPrimary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_createAdCntr.currentStep > 1)
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (_createAdCntr.currentStep > 1) {
                            _createAdCntr
                                .setCurrenStep(_createAdCntr.currentStep - 1);
                          }
                        },
                        height: 42.h,
                        text: "Previous",
                        margin: EdgeInsets.only(right: 6.h),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientSecondaryContainerToOrangeTL12Decoration,
                        buttonTextStyle: theme.textTheme.titleMedium!,
                      ),
                    ),
                  if (_createAdCntr.currentStep < 3)
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          _createAdCntr
                              .setCurrenStep(_createAdCntr.currentStep + 1);
                        },
                        // onPressed: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ShareYourAddsSevenScreen())),
                        height: 42.h,
                        text: "Next",
                        margin: EdgeInsets.only(left: 6.h),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientPrimaryToOrangeDecoration,
                      ),
                    ),
                  if (_createAdCntr.currentStep == 3)
                    
                    Expanded(
                      child:   CustomElevatedButton(
                              onPressed: () {
                                _createAdCntr.submitAd(context);
                              },
                              height: 42.h,
                              text: _createAdCntr.isLoading ?"Sending..." : "Send",
                              margin: EdgeInsets.only(left: 6.h),
                              buttonStyle: CustomButtonStyles.none,
                              decoration: CustomButtonStyles
                                  .gradientPrimaryToOrangeDecoration,
                            ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Section Widget
  Widget _buildMainImg(BuildContext context) {
    return Expanded(
        child: GetBuilder<CreateAdController>(
            init: CreateAdController(Get.find()),
            builder: (CreateAdController _createAdController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Add image ".tr,
                              style: CustomTextStyles.bodyMediumff363333,
                            ),
                            TextSpan(
                              text: "( optional ) ".tr,
                              style: CustomTextStyles.bodySmallff828282,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.h,
                          bottom: 0.v,
                        ),
                        child: Obx(() => Text(
                              "(${_controller.imagePaths.length}/20)",
                              style: CustomTextStyles.bodyMediumBluegray900,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.v),
                  Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () => _createAdController.pickImages(),
                      //   child: Container(
                      //     height: 88.adaptSize,
                      //     width: 88.adaptSize,
                      //     padding: EdgeInsets.all(31.h),
                      //     decoration: AppDecoration.outlinePrimary2.copyWith(
                      //       borderRadius: BorderRadiusStyle.roundedBorder8,
                      //     ),
                      //     child: CustomImageView(
                      //       imagePath: ImageConstant.imgPlus,
                      //       height: 24.adaptSize,
                      //       width: 24.adaptSize,
                      //       alignment: Alignment.center,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: SizedBox(
                          // height: 88.v,

// data == null ? 1 : data.length + 1
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _createAdController.imagePaths.length == 0
                                      ? 1
                                      : _createAdController.imagePaths.length +
                                          1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 2.0,
                                      mainAxisSpacing: 10.0),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  // return the header
                                  return new GestureDetector(
                                    onTap: () =>
                                        _createAdController.pickImages(),
                                    child: Container(
                                      height: 88.v,
                                      width: 96.h,
                                      padding: EdgeInsets.all(31.h),
                                      decoration: AppDecoration.outlinePrimary2
                                          .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder8,
                                      ),
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgPlus,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  );
                                }
                                index -= 1;
                                return Container(
                                  height: 88.v,
                                  width: 96.h,
                                  margin: EdgeInsets.only(left: 4.h),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          height: 100.adaptSize,
                                          width: 100.adaptSize,
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  child: Image.file(
                                                    File(_createAdController
                                                        .imagePaths[index]),
                                                    fit: BoxFit.cover,
                                                    height: 100.adaptSize,
                                                    width: 100.adaptSize,
                                                  )),
                                              GestureDetector(
                                                onTap: () => _createAdController
                                                    .setMainImage(index),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 4.h,
                                                      bottom: 4.v,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        _createAdController
                                                                    .mainImage ==
                                                                index
                                                            ? Icon(
                                                                Icons
                                                                    .radio_button_checked,
                                                                size: 20,
                                                                color:
                                                                    ZAHRA_RED,
                                                                fill: 0.5,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .radio_button_checked,
                                                                size: 20,
                                                                color:
                                                                    WHITE_COLOR,
                                                                fill: 0.5,
                                                              ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          "Main Img",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  WHITE_COLOR),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CustomIconButton(
                                        onTap: () => _createAdController
                                            .removeImageInCreate(index),
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        alignment: Alignment.topRight,
                                        child: CustomImageView(
                                          imagePath:
                                              ImageConstant.imgCloseOnerror,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                          // width: 226.h,
                          // child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     shrinkWrap: true,
                          //     itemCount:
                          //         _createAdController.imagePaths.length,
                          //     itemBuilder: (_, index) {
                          //       return Container(
                          //         height: 88.v,
                          //         width: 96.h,
                          //         margin: EdgeInsets.only(left: 8.h),
                          //         child: Stack(
                          //           alignment: Alignment.topRight,
                          //           children: [
                          //             Align(
                          //               alignment: Alignment.centerLeft,
                          //               child: SizedBox(
                          //                 height: 100.adaptSize,
                          //                 width: 100.adaptSize,
                          //                 child: Stack(
                          //                   alignment:
                          //                       Alignment.bottomLeft,
                          //                   children: [
                          //                     ClipRRect(
                          //                         borderRadius:
                          //                             BorderRadius
                          //                                 .circular(8.h),
                          //                         child: Image.file(
                          //                           File(_createAdController
                          //                                   .imagePaths[
                          //                               index]),
                          //                           fit: BoxFit.cover,
                          //                           height: 100.adaptSize,
                          //                           width: 100.adaptSize,
                          //                         )),
                          //                     GestureDetector(
                          //                       onTap: () =>
                          //                           _createAdController
                          //                               .setMainImage(
                          //                                   index),
                          //                       child: Align(
                          //                         alignment: Alignment
                          //                             .bottomLeft,
                          //                         child: Padding(
                          //                           padding:
                          //                               EdgeInsets.only(
                          //                             left: 4.h,
                          //                             bottom: 4.v,
                          //                           ),
                          //                           child: Row(
                          //                             children: [
                          //                               _createAdController
                          //                                           .mainImage ==
                          //                                       index
                          //                                   ? Icon(
                          //                                       Icons
                          //                                           .radio_button_checked,
                          //                                       size: 20,
                          //                                       color:
                          //                                           ZAHRA_RED,
                          //                                       fill: 0.5,
                          //                                     )
                          //                                   : Icon(
                          //                                       Icons
                          //                                           .radio_button_checked,
                          //                                       size: 20,
                          //                                       color:
                          //                                           WHITE_COLOR,
                          //                                       fill: 0.5,
                          //                                     ),
                          //                               SizedBox(
                          //                                 width: 2,
                          //                               ),
                          //                               Text(
                          //                                 "Main Img",
                          //                                 style: TextStyle(
                          //                                     fontSize:
                          //                                         12,
                          //                                     color:
                          //                                         WHITE_COLOR),
                          //                               )
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //             CustomIconButton(
                          //               onTap: () => _createAdController
                          //                   .removeImageInCreate(index),
                          //               height: 24.adaptSize,
                          //               width: 24.adaptSize,
                          //               alignment: Alignment.topRight,
                          //               child: CustomImageView(
                          //                 imagePath: ImageConstant
                          //                     .imgCloseOnerror,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     }),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }));
  }

  /// Section Widget
  Widget _buildMediaImages(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildMainImg(context)],
    );
  }

  /// Section Widget
  Widget _buildProductVideo(BuildContext context) {
    return Expanded(
      child: GetBuilder<CreateAdController>(
          init: CreateAdController(Get.find()),
          builder: (CreateAdController createAdController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Product Video ",
                            style: CustomTextStyles.bodyMediumff363333,
                          ),
                          TextSpan(
                            text: "( optional ) ",
                            style: CustomTextStyles.bodySmallff828282,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.v),
                      child: Text(
                        "(${createAdController.videoPaths.length}/5)",
                        style: CustomTextStyles.bodyMediumBluegray900,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 6.v),
                SizedBox(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => createAdController.pickVideo(),
                        child: Container(
                          height: 88.adaptSize,
                          width: 88.adaptSize,
                          padding: EdgeInsets.all(31.h),
                          decoration: AppDecoration.outlinePrimary2.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgPlus,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 266.h,
                        height: 88.v,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: createAdController.uint8lists.length,
                            itemBuilder: (_, index) {
                              return Container(
                                margin:
                                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child: SizedBox(
                                  height: 88.v,
                                  width: 88.h,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.h),
                                        child: Image.memory(
                                          createAdController.uint8lists[index],
                                          fit: BoxFit.cover,
                                          height: 88.adaptSize,
                                          width: 88.adaptSize,
                                        ),
                                      ),
                                      CustomIconButton(
                                        onTap: () => createAdController
                                            .removeVideoInCreate(index),
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        alignment: Alignment.topRight,
                                        child: CustomImageView(
                                          imagePath:
                                              ImageConstant.imgCloseOnerror,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductVideo(context),
      ],
    );
  }

  /// Section Widget
  Widget _buildMinPriceSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 6.h),
        child: EasyAppTextFormField(
          labelText: "Min Price",
          hintText: "Min Price",
          // hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddFrameSection(BuildContext context) {
    return GetBuilder<CreateAdController>(
        init: CreateAdController(Get.find()),
        builder: (CreateAdController _createAdCntr) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _createAdCntr.selectedPriceType == "Fixed Price"
                  ? SizedBox.shrink()
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 6.h),
                        child: EasyAppTextFormField(
                          onChanged: (value) => _createAdCntr.min_price,
                          labelText: "Min Price",
                          hintText: "Min Price",
                          // hintStyle: CustomTextStyles.bodyMediumErrorContainer,
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 0.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.h,
                    vertical: 5.v,
                  ),
                  decoration: AppDecoration.outlineGray.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8.h,
                          top: 0.v,
                          bottom: 0.v,
                        ),

                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            // color: ZAHRA_RED,
                            border:
                                Border.all(width: 0, color: Colors.transparent),
                          ),
                          child: EasyAppTextFormField(
                              onChanged: (value) =>
                                  _createAdCntr.price = value!,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              labelText: _createAdCntr.selectedPriceType ==
                                      "Fixed Price"
                                  ? "Price "
                                  : "Max Price",
                              hintText: _createAdCntr.selectedPriceType ==
                                      "Fixed Price"
                                  ? "Price "
                                  : "Max Price"),
                        ),
                        // child: SizedBox(
                        //   width: 78,
                        //   child: CustomFloatingTextField(

                        //     autofocus: false,
                        //     labelText:
                        //         _createAdCntr.selectedPriceType == "Fixed Price"
                        //             ? "Price "
                        //             : "Max Price",
                        //     // labelStyle:
                        //     //     CustomTextStyles.titleMediumBluegray90001Medium,
                        //     hintText:
                        //         _createAdCntr.selectedPriceType == "Fixed Price"
                        //             ? "Price "
                        //             : "Max Price",
                        //     contentPadding: EdgeInsets.only(
                        //       left: 0.h,
                        //       right: 0.h,
                        //       bottom: 12.v,
                        //     ),
                        //     hintStyle: TextStyle(
                        //         fontSize: 14, fontWeight: FontWeight.normal),
                        //     labelStyle: TextStyle(
                        //         fontSize: 14, fontWeight: FontWeight.normal),
                        //     borderDecoration:
                        //         FloatingTextFormFieldStyleHelper.underLine,
                        //     filled: false,
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        child: CustomDropDown(
                          width: 69.h,
                          icon: Container(
                            decoration: BoxDecoration(
                              color: RED_COLOR,
                              gradient: LinearGradient(
                                //  begin: Alignment(-0.11, -0.23),
                                end: Alignment(1.0, 1.0),
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0.3),
                                  appTheme.orange400.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),

                            // margin: EdgeInsets.fromLTRB(4.h, 6.v, 8.h, 6.v),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SR",
                                  style: TextStyle(
                                      color: Color(0XFFD20653), height: 1),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgArrowdownPrimary,
                                  height: 20.adaptSize,
                                  width: 20.adaptSize,
                                )
                              ],
                            ),
                          ),
                          // hintText: "SR",
                          hintStyle: CustomTextStyles.bodySmallPrimary,
                          items: [],
                          borderDecoration: DropDownStyleHelper
                              .gradientSecondaryContainerToOrange,
                          filled: false,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildMapSection(BuildContext context) {
    return GetBuilder<CreateAdController>(
        init: CreateAdController(Get.find()),
        builder: (CreateAdController _createAdCntr) {
          return SizedBox(
            height: 224.v,
            width: 500.h,
            child: _createAdCntr.mapLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    mapType: MapType.terrain,
                    // initialCameraPosition: CameraPosition(
                    //   target: LatLng(
                    //     37.43296265331129,
                    //     -122.08832357078792,
                    //   ),
                    //   zoom: 14.4746,
                    // ),
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController.complete(controller);
                    },

                    initialCameraPosition: CameraPosition(
                        target: LatLng(_createAdCntr.lat, _createAdCntr.long),
                        zoom: 13),
                    // onMapCreated: (GoogleMapController controller) {
                    //   _controller.complete(controller);
                    // },
                    // markers: Set.from(_markers),

                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
          );
        });
  }

  /// Section Widget
  Widget _bePremiumSection(BuildContext context) {
    return Container(
      width: 374.h,
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.gradientSecondaryContainerToOrange.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVuesaxTwotoneInfoCircle,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Be permium :",
                  style: CustomTextStyles.titleMediumBluegray90001Medium,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 7.h),
            child: Text(
              "Lorem ipsum dolor sit amet, ",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 7.h),
            child: Text(
              "Lorem ipsum dolor sit amet, ",
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 6.h),
            child: CustomRadioButton(
              width: 181.h,
              text: "Normal ad",
              value: "Normal ad",
              groupValue: "",
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 13.v,
              ),
              textStyle: CustomTextStyles.titleMediumBluegray90001Medium,
              decoration: RadioStyleHelper.outlinePrimary,
              isRightCheck: true,
              onChange: (value) {},
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6.h),
            child: CustomTextFormField(
              hintText: "Premium",
              hintStyle: CustomTextStyles.titleMediumBluegray90001Medium,
              textInputAction: TextInputAction.done,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(8.h, 13.v, 6.h, 13.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgVuesaxLinearCrown,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                ),
              ),
              prefixConstraints: BoxConstraints(
                maxHeight: 50.v,
              ),
              suffix: Container(
                margin: EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                child: CustomImageView(
                  imagePath: ImageConstant.imgContrastPrimarycontainer,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
              ),
              suffixConstraints: BoxConstraints(
                maxHeight: 50.v,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14.v),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (CreateAdController createController) {
      return Container(
        width: double.infinity,

        // padding: EdgeInsetsDirectional.fromSTEB(
        //     3, 0, 3, 0),
        // decoration: BoxDecoration(
        //     color: WHITE_COLOR,
        //     borderRadius:
        //         BorderRadius.circular(8)),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: GREY_COLOR),
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CategoriesController>(
            init: CategoriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<Category?>(
                onChange: (int index) => createController
                    .setSelectedCategory(catCntr.categories[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  // backgroundColor: Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
                    // width: 160,
                    color: WHITE_COLOR,
                    elevation: 0,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8))),
                items: catCntr.categories
                    .asMap()
                    .entries
                    .map(
                      (item) => DropdownItem<Category?>(
                        value: item.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.value.name!.capitalize!),
                        ),
                      ),
                    )
                    .toList(),
                child: Text(createController.selectedCategory.name != null
                    ? createController.selectedCategory.name.toString()
                    : "Category"),
              );
            }),
      );
    });
  }
}

class CreateAdCountryDropDown extends StatelessWidget {
  CreateAdCountryDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (CreateAdController createAdController) {
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
                onChange: (int index) => createAdController
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
                child: Text(createAdController.selectedCountry.name != null
                    ? createAdController.selectedCountry.name.toString()
                    : "Country"),
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
    return GetBuilder(builder: (CreateAdController createAdController) {
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
                    createAdController.setFeaturedSelectedState(
                        createAdController.selectedCountry.states![index]),
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
                items: createAdController.selectedCountry.name == null
                    ? []
                    : createAdController.selectedCountry.states!
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
                child: Text(createAdController.selectedState.name != ""
                    ? createAdController.selectedState.name.toString()
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
    return GetBuilder<CreateAdController>(
        init: CreateAdController(Get.find()),
        builder: (CreateAdController createAdController) {
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
                        createAdController.setFeaturedSelectedCity(
                            createAdController.selectedState.cities![index]),
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
                    items: createAdController.selectedState.name == ''
                        ? []
                        : createAdController.selectedState.cities!
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
                    child: Text(createAdController.selectedCity.name != ""
                        ? createAdController.selectedCity.name.toString()
                        : "City"),
                  );
                }),
          );
        });
  }
}

class PriceTypeDropdown extends StatelessWidget {
  PriceTypeDropdown({super.key});

  final List<String> dropdownItemList = ["Fixed Price", "Offer Price"];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (CreateAdController createAdController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: GREY_COLOR),
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<String?>(
                onChange: (int index) =>
                    createAdController.setPriceType(dropdownItemList[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 38,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  // backgroundColor: Colors.white,
                  primaryColor: Colors.black87,
                ),
                dropdownStyle: DropdownStyle(
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
                child: Text(createAdController.selectedPriceType != ""
                    ? createAdController.selectedPriceType.tr
                    : "Price Type"),
              );
            }),
      );
    });
  }
}

Widget _buildInlineVideoPlayer(int index) {
  final VideoPlayerController controller = VideoPlayerController.file(File(
      '/data/user/0/com.ecommerce.zahra/cache/c317afe4-849d-4741-b052-f6cc0ea4f60e/SampleVideo_1280x720_1mb.mp4'));
  // const double volume = kIsWeb ? 0.0 : 1.0;
  controller.setVolume(0.0);
  controller.initialize();
  controller.setLooping(true);
  controller.pause();
  return Center(
    child: AspectRatioVideo(controller),
  );
}

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {super.key});

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: VideoPlayer(controller!),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
