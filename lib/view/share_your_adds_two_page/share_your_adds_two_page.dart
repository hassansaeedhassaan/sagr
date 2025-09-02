import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/products/presentation/controllers/product_controller.dart';

import '../../core/utils/image_constant.dart';
import '../../data/colors.dart';
import '../../features/products/domain/entities/product.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_radio_button.dart';

// ignore_for_file: must_be_immutable
class ShareYourAddsTwoPage extends StatefulWidget {
  final Product? product;
  const ShareYourAddsTwoPage(this.product, {Key? key})
      : super(
          key: key,
        );

  @override
  ShareYourAddsTwoPageState createState() => ShareYourAddsTwoPageState();
}

class ShareYourAddsTwoPageState extends State<ShareYourAddsTwoPage>
    with AutomaticKeepAliveClientMixin<ShareYourAddsTwoPage> {
  String radioGroup = "";

  String radioGroup1 = "";

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder(builder: (ProductController _prodController) {
          return SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              decoration: AppDecoration.fillGray,
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 16),
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
                          style: CustomTextStyles.titleMediumBluegray90001_1,
                        ),
                        Text(
                          "You can add maximum 20 images or 50 videos.",
                          style: theme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 11.v),
                        _buildUploadAttachmentsSection(context),
                        GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _prodController.imagePaths.length +
                                        _prodController.adImages.length ==
                                    0
                                ? 1
                                : (_prodController.imagePaths.length +
                                        _prodController.adImages.length) +
                                    1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1,
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 10.0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Container(
                                  height: 88.adaptSize,
                                  width: 88.adaptSize,
                                  padding: EdgeInsets.all(31.h),
                                  decoration:
                                      AppDecoration.outlinePrimary2.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder8,
                                  ),
                                  child: CustomImageView(
                                    onTap: () => _prodController.pickImages(),
                                    imagePath: ImageConstant.imgPlus,
                                    height: 24.adaptSize,
                                    width: 24.adaptSize,
                                    alignment: Alignment.center,
                                  ),
                                );
                              }
                              index -= 1;

                              return Container(
                                margin:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                child: SizedBox(
                                  height: 88.v,
                                  width: 88.h,
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
                                              _prodController.adImages[index]
                                                          ['type'] ==
                                                      'file'
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.file(
                                                        File(_prodController
                                                                .adImages[index]
                                                            ['path']),
                                                        fit: BoxFit.cover,
                                                        height: 100.adaptSize,
                                                        width: 96.adaptSize,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        _prodController
                                                                .adImages[index]
                                                            ['path'],
                                                        fit: BoxFit.cover,
                                                        height: 100.adaptSize,
                                                        width: 96.adaptSize,
                                                      )),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 10.h,
                                                    bottom: 4.v,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        size: 20,
                                                        color: _prodController
                                                                            .adImages[
                                                                        index]
                                                                    ['path'] ==
                                                                widget.product!
                                                                    .image
                                                            ? ZAHRA_RED
                                                            : WHITE_COLOR,
                                                        fill: 0.5,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        "Main Img",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: WHITE_COLOR),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CustomIconButton(
                                        onTap: () {
                                          if (_prodController.adImages[index]
                                                  ['type'] ==
                                              'file') {
                                            _prodController.removeImageInUpdate(
                                                _prodController.adImages[index]
                                                    ['path']);
                                            return;
                                          }
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12.0))),
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    content: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Positioned(
                                                              right: 10,
                                                              top: -15,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          WHITE_COLOR,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50)),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 22,
                                                                    child:
                                                                        CustomImageView(
                                                                      imagePath:
                                                                          ImageConstant
                                                                              .imgVuesaxLinearUserRemove,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  height: 80,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/zahra-logo.png"),
                                                                ),
                                                                Center(
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "Delete Image",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          "Are you sure you want to delete image? If you deleted it, you may not be able to restore it again.",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                16,
                                                                            vertical:
                                                                                12),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                height: 42.h,
                                                                                child: CustomElevatedButton(
                                                                                  onPressed: () {
                                                                                    _prodController.deleteMedia(adId: widget.product!.id, mediaId: _prodController.adImages[index]!['id']);

                                                                                    Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
                                                                                  },
                                                                                  text: "Yes, i'm sure".tr,
                                                                                  margin: EdgeInsets.only(right: 6.h),
                                                                                  buttonStyle: CustomButtonStyles.none,
                                                                                  decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: CustomOutlinedButton(
                                                                                buttonStyle: OutlinedButton.styleFrom(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                  ),
                                                                                  side: BorderSide(width: 1.0, color: Color(0XFFD20653)),
                                                                                ),
                                                                                onPressed: () => Navigator.pop(context),
                                                                                height: 42.v,
                                                                                text: "Cancle",
                                                                                margin: EdgeInsets.only(left: 6.h),
                                                                                buttonTextStyle: CustomTextStyles.titleMediumPink60001_1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                        },
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
                        SizedBox(height: 16.v),
                        _buildFrame(context),
                        SizedBox(height: 16.v),
                      ],
                    ),
                  ),
                  // SizedBox(height: 79.v),
                ],
              ),
            ),
          );
        }),
        bottomNavigationBar: _buildUpdateSection(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildUploadAttachmentsSection(BuildContext context) {
    return GetBuilder(builder: (ProductController _prodCntr) {
      return Padding(
        padding: EdgeInsets.only(right: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Add image ",
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
            Text(
              "(${_prodCntr.adImages.length}/20)",
              style: CustomTextStyles.bodyMediumBluegray900,
            ),
          ],
        ),
      );
    });
  }

  /// Section Widget
  Widget _buildMainImg(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 4.h,
          bottom: 4.v,
        ),
        child: CustomRadioButton(
          text: "Main img",
          value: "Main img",
          groupValue: radioGroup,
          padding: EdgeInsets.symmetric(vertical: 1.v),
          textStyle: CustomTextStyles.bodySmallOnPrimary,
          onChange: (value) {
            radioGroup = value;
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMainImg1(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 4.h,
          bottom: 4.v,
        ),
        child: CustomRadioButton(
          text: "Main img",
          value: "Main img",
          groupValue: radioGroup1,
          padding: EdgeInsets.symmetric(vertical: 1.v),
          textStyle: CustomTextStyles.bodySmallOnPrimary,
          onChange: (value) {
            radioGroup1 = value;
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProductVideoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 6.v),

        GetBuilder(builder: (ProductController _productController) {
          // _productController.generateVideoThumb(widget.product);

          return SizedBox(
            // height: 88.h,
            height: 120.h,
            width: 355.h,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 88.adaptSize,
                      width: 88.adaptSize,
                      padding: EdgeInsets.all(31.h),
                      decoration: AppDecoration.outlinePrimary2.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: CustomImageView(
                        // onTap: () => _productController.pickVideo(),
                        onTap: () => null,
                        imagePath: ImageConstant.imgPlus,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _productController.uint8lists
                              .map((e) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ZAHRA_RED.withOpacity(0.1),
                                    ),
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: SizedBox(
                                      height: 88.v,
                                      width: 88.h,
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
                                                              12),

                                                      // child: Text(e),
                                                      child: Image.asset(
                                                        "assets/images/logo.png",
                                                        fit: BoxFit.cover,
                                                        height: 100.adaptSize,
                                                        width: 96.adaptSize,
                                                      )),
                                                  // CustomImageView(
                                                  //   imagePath: ImageConstant
                                                  //       .imgRectangle288x88,
                                                  //   height: 100.adaptSize,
                                                  //   width: 88.adaptSize,
                                                  //   radius: BorderRadius.circular(
                                                  //     8.h,
                                                  //   ),
                                                  //   alignment: Alignment.center,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          CustomIconButton(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12.0))),
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            content: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0))),
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Stack(
                                                                  clipBehavior:
                                                                      Clip.none,
                                                                  children: [
                                                                    Positioned(
                                                                      right: 10,
                                                                      top: -15,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: () =>
                                                                            Navigator.of(context).pop(),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(4),
                                                                          decoration: BoxDecoration(
                                                                              color: WHITE_COLOR,
                                                                              borderRadius: BorderRadius.circular(50)),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                22,
                                                                            child:
                                                                                CustomImageView(
                                                                              imagePath: ImageConstant.imgVuesaxLinearUserRemove,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height:
                                                                              80,
                                                                          child:
                                                                              Image.asset("assets/images/zahra-logo.png"),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                "Delete Image",
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  "Are you sure you want to delete image? If you deleted it, you may not be able to restore it again.",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 15),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: SizedBox(
                                                                                        height: 42.h,
                                                                                        child: CustomElevatedButton(
                                                                                          onPressed: () {
                                                                                            _productController.deleteMedia(adId: widget.product!.id, mediaId: e['id']);

                                                                                            Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
                                                                                          },
                                                                                          text: "Yes, i'm sure".tr,
                                                                                          margin: EdgeInsets.only(right: 6.h),
                                                                                          buttonStyle: CustomButtonStyles.none,
                                                                                          decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: CustomOutlinedButton(
                                                                                        buttonStyle: OutlinedButton.styleFrom(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(12.0),
                                                                                          ),
                                                                                          side: BorderSide(width: 1.0, color: Color(0XFFD20653)),
                                                                                        ),
                                                                                        onPressed: () => Navigator.pop(context),
                                                                                        height: 42.v,
                                                                                        text: "Cancle",
                                                                                        margin: EdgeInsets.only(left: 6.h),
                                                                                        buttonTextStyle: CustomTextStyles.titleMediumPink60001_1,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ));
                                            },
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
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "رفع وتعديل ملفات الفيديو غير متاحة في هذه النسخة!",
                  style: TextStyle(color: Colors.amber[800]),
                )
              ],
            ),
          );
        }),
        // Text(widget.product!.videos_thumbs.toString()),
      ],
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductVideoSection(context),
      ],
    );
  }

  /// Section Widget
  Widget _buildUpdateSection(BuildContext context) {
    return GetBuilder(builder: (ProductController _prodCntr) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.h,
          vertical: 16.v,
        ),
        decoration: AppDecoration.fillOnPrimary,
        child: CustomElevatedButton(
          onPressed: () => _prodCntr.updateAd(1),
          text: "Update ",
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
        ),
      );
    });
  }
}
