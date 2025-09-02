import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/chat/presentation/controllers/conversations_controller.dart';
import 'package:sagr/features/comments/data/models/comment_model.dart';
import 'package:sagr/features/comments/presentation/comments_controller.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/presentation/controllers/product_controller.dart';
import 'package:sagr/features/products/presentation/controllers/products/related_ads_controller.dart';
import 'package:sagr/features/products/presentation/widgets/product_item.dart';
import 'package:sagr/view/feature_ads_page/widgets/userprofile_item_widget.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';

import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_image_view.dart';

// ignore_for_file: must_be_immutable
class AdsDetailsScreen extends StatelessWidget {
  AdsDetailsScreen({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  TextEditingController replayValueEditTextController = TextEditingController();

  TextEditingController replayvalueController = TextEditingController();

  TextEditingController replayValueEditTextController1 =
      TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(Get.find(), Get.find()),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              // title: Text("a kasjd j"),
              title: Text("Ad Details".tr),
              scrolledUnderElevation: 0,
              backgroundColor: WHITE_COLOR,
            ),
            body: controller.productsLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: SizeUtils.width,
                    child: SingleChildScrollView(
                        child: controller.productsLoading
                            ? CircularProgressIndicator()
                            : Column(children: [
                                // _buildComponent(context),
                                // SizedBox(height: 22.v),
                                // _buildNegotiable(context, controller.product!),
                                // SizedBox(height: 12.v),

                               Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: ProductItem(obj: controller.product!),),

                                // Text(controller.product.toString()),
                                // controller.productsLoading
                                //     ? Text("Loading...")
                                //     : _buildFrameColumn(
                                //         context, controller.product!),
                                
                                SizedBox(height: 12.v),
                                _buildFrameColumn1(
                                    context, controller.product!),
                                SizedBox(height: 12.v),
                                GetBuilder<CommentsController>(
                                    init: CommentsController(Get.find()),
                                    builder: (CommentsController _controller) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16.h),
                                          padding: EdgeInsets.all(12.h),
                                          decoration: AppDecoration
                                              .fillOnPrimary
                                              .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder12),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text: "Comments ",
                                                              style: CustomTextStyles
                                                                  .titleMediumff363333),
                                                          TextSpan(
                                                              text:
                                                                  "(${_controller.comments.length})",
                                                              style: CustomTextStyles
                                                                  .bodyMediumffd20653)
                                                        ]),
                                                        textAlign:
                                                            TextAlign.left)),
                                                SizedBox(height: 12.v),
                                                Container(
                                                    decoration: AppDecoration
                                                        .fillOnPrimary
                                                        .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder12),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            // height: 200,
                                                            child: ListView
                                                                .builder(
                                                                    reverse:
                                                                        true,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemCount: _controller
                                                                        .comments
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      return Column(
                                                                        children: [
// Text(GetStorage().read("userData").toString()),

                                                                          // _controller.productsLoading? CircularProgressIndicator() : Text(_controller.products[index].user!.name!),
                                                                          //  _buildFrameRow2(context,
                                                                          //                                           text1: "${_controller.comments[index].user!.name!}",
                                                                          //                                           text2: "${_controller.comments.elementAt(index).comment!}",
                                                                          //                                           text3: "${_controller.comments.elementAt(index).created_at!}",
                                                                          //                                           text4: "replay",
                                                                          //                                           text5: "Edit",
                                                                          //                                           text6: "Delete"),

                                                                          //                                       SizedBox(height: 17.v),
                                                                          //                                       _buildFrameRow4(context, _controller.comments[index]),
                                                                          //                                       SizedBox(height: 17.v),

                                                                          //                                       Divider(),

                                                                          SizedBox(
                                                                              height: 7.v),
                                                                          _buildFrameRow6(
                                                                              context,
                                                                              _controller.comments[i]),
                                                                          SizedBox(
                                                                              height: 12.v),
                                                                          _controller.comments[i].childs!.length == 0
                                                                              ? SizedBox.shrink()
                                                                              : Padding(
                                                                                  padding: EdgeInsets.only(left: 48.h),
                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    CustomImageView(imagePath: ImageConstant.imgRectangle1232x32, height: 32.adaptSize, width: 32.adaptSize, radius: BorderRadius.circular(16.h), margin: EdgeInsets.only(bottom: 88.v)),
                                                                                    Expanded(
                                                                                        child: ListView.builder(
                                                                                            reverse: false,
                                                                                            itemCount: _controller.comments[i].childs!.length,
                                                                                            shrinkWrap: true,
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            itemBuilder: (context, index) {
                                                                                              return Padding(
                                                                                                  padding: EdgeInsets.only(left: 8.h),
                                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                    Row(children: [
                                                                                                      Text(_controller.comments.elementAt(i).childs![index].user!.name.toString(), style: CustomTextStyles.titleMediumBluegray900Medium),
                                                                                                      CustomImageView(imagePath: ImageConstant.imgNotification, height: 20.adaptSize, width: 20.adaptSize, margin: EdgeInsets.only(left: 5.h))
                                                                                                    ]),
                                                                                                    SizedBox(height: 8.v),
                                                                                                    Container(
                                                                                                        padding: EdgeInsets.all(7.h),
                                                                                                        decoration: _controller.updatedComment != 0 && _controller.updatedComment == _controller.comments.elementAt(i).childs![index].id ? AppDecoration.outlinePrimary.copyWith(borderRadius: BorderRadiusStyle.customBorderBL8) : AppDecoration.outlinePrimary.copyWith(borderRadius: BorderRadiusStyle.customBorderBL8, border: Border.all(width: 0, color: Colors.transparent)),
                                                                                                        child: SizedBox(
                                                                                                            width: 270.h,
                                                                                                            child: _controller.updatedComment != 0 && _controller.updatedComment == _controller.comments.elementAt(i).childs![index].id
                                                                                                                ? Row(
                                                                                                                    children: [
                                                                                                                      Expanded(
                                                                                                                        child: TextFormField(onChanged: (value) => _controller.replay = value, initialValue: _controller.comments.elementAt(i).childs![index].comment),
                                                                                                                      ),
                                                                                                                      IconButton(onPressed: () => _controller.updateComment(controller.product!.id), icon: Icon(Icons.send))
                                                                                                                    ],
                                                                                                                  )
                                                                                                                : RichText(
                                                                                                                    text: TextSpan(children: [
                                                                                                                      // TextSpan(text: "Very ", style: CustomTextStyles.bodyMediumff333333),
                                                                                                                      TextSpan(text: _controller.comments.elementAt(i).childs![index].comment, style: CustomTextStyles.bodyMediumff333333)
                                                                                                                    ]),
                                                                                                                    textAlign: TextAlign.left))),
                                                                                                    SizedBox(height: 8.v),
                                                                                                    Padding(padding: EdgeInsets.only(right: 0.h), child: _buildFrameRow1(adId: controller.product!.id!, comment: _controller.comments.elementAt(i).childs![index], context, h: "8h", replayText: "replay", editText: "Edit", deleteText: "Delete"))
                                                                                                  ]));
                                                                                            }))
                                                                                  ])),

                                                                          SizedBox(
                                                                              height: 12.v),
                                                                          _buildFrameRow4(
                                                                              context,
                                                                              _controller.comments[i]),
                                                                          SizedBox(
                                                                              height: 5.v),
                                                                          _controller.comments.first.id != _controller.comments[i].id
                                                                              ? Divider()
                                                                              : SizedBox.shrink(),
                                                                          SizedBox(
                                                                              height: 5.v),
                                                                        ],
                                                                      );
                                                                    }),
                                                          ),

                                                          //  _buildFrameRow2(context,
                                                          //       text1: "ali Ali",
                                                          //       text2: "Very nice product",
                                                          //       text3: "8h",
                                                          //       text4: "replay",
                                                          //       text5: "Edit",
                                                          //       text6: "Delete"),

                                                          //   SizedBox(height: 17.v),
                                                          //   _buildFrameRow4(context),
                                                          //   SizedBox(height: 17.v),
                                                          //   Divider(),
                                                          //   _buildFrameRow2(context,
                                                          //       text1: "ali Ali",
                                                          //       text2: "Very nice product",
                                                          //       text3: "8h",
                                                          //       text4: "replay",
                                                          //       text5: "Edit",
                                                          //       text6: "Delete"),
                                                          //   SizedBox(height: 17.v),
                                                          //   _buildFrameRow4(context),
                                                          //                                       _buildFrameRow4(context, _controller.comments[index]),
                                                          // SizedBox(height: 17.v),
                                                          // Divider(),
                                                          SizedBox(height: 7.v),
                                                          // _buildFrameRow6(context, _controller.comments[index]),

                                                          // _buildFrameRow8(context),
                                                          // SizedBox(height: 12.v),
                                                          // Divider(),
                                                          // SizedBox(height: 7.v),
                                                          // _buildFrameRow2(context,
                                                          //     text1: "ali Ali",
                                                          //     text2:
                                                          //         "Very nice product",
                                                          //     text3: "8h",
                                                          //     text4: "replay",
                                                          //     text5: "Edit",
                                                          //     text6: "Delete"),
                                                          // SizedBox(height: 17.v),
                                                          // _buildFrameRow10(context)
                                                        ])),
                                                SizedBox(height: 24.v),
                                                Text("View More",
                                                    style: CustomTextStyles
                                                        .titleSmallPrimary_1)
                                              ]));
                                      //  return  _buildFrameRow8(context);
                                      //  return  _buildFrameRow8(context);
                                      //  return  _buildFrameRow8(context);
                                    }),
                                SizedBox(height: 10.v),

                                SizedBox(
                                  width: SizeUtils.width,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.h),
                                    padding: EdgeInsets.all(12.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Related ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        InkWell(
                                          child: Text("See More"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                GetBuilder<RelatedAdsController>(
                                    init: RelatedAdsController(
                                        Get.find(), controller.product!.id!),
                                    builder: (RelatedAdsController
                                        _relatedAdsController) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.h),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 247.v,
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 8.h,
                                            crossAxisSpacing: 8.h,
                                          ),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: _relatedAdsController
                                              .products.length,
                                          itemBuilder: (context, index) {
                                            return ProductItemWidget(
                                              product: _relatedAdsController
                                                      .products[index]
                                                  as ProductModel,
                                            );
                                          },
                                        ),
                                      );
                                    }),

                                SizedBox(height: 10.v),
                              ]))),
            // bottomNavigationBar: _buildBottomBar(context)
          );
        });
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 39.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowDown,
            margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v)),
        title: AppbarSubtitle(
            text: "Ads Details", margin: EdgeInsets.only(left: 16.h)),
        styleType: Style.bgFill);
  }

  /// Section Widget
  Widget _buildComponent(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
        decoration: AppDecoration.fillOnPrimary,
        child: CustomSearchView(
            controller: searchController,
            hintText: "Search for ads...",
            contentPadding:
                EdgeInsets.only(top: 12.v, right: 30.h, bottom: 12.v)));
  }

  /// Section Widget
  Widget _buildNegotiableButton(BuildContext context) {
    return CustomElevatedButton(
        height: 28.v,
        width: 80.h,
        text: "Negotiable",
        buttonStyle: CustomButtonStyles.fillTealA,
        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary);
  }

  /// Section Widget
  Widget _buildNegotiableButton1(BuildContext context) {
    return CustomElevatedButton(
        height: 28.v,
        width: 80.h,
        text: "Negotiable",
        buttonStyle: CustomButtonStyles.fillTealA,
        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary);
  }

  /// Section Widget
  Widget _buildNegotiable(BuildContext context, Product? product) {
    return SizedBox(
        height: 268.v,
        width: double.infinity,
        child: Stack(alignment: Alignment.center, children: [
          // Align(
          //     alignment: Alignment.topCenter,
          //     child: Padding(
          //         padding: EdgeInsets.fromLTRB(12.h, 12.v, 12.h, 228.v),
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               SizedBox(
          //                   width: 136.h,
          //                   child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Expanded(
          //                             child: Padding(
          //                                 padding: EdgeInsets.only(right: 4.h),
          //                                 child: CustomIconButton(
          //                                     height: 28.adaptSize,
          //                                     width: 28.adaptSize,
          //                                     padding: EdgeInsets.all(4.h),
          //                                     child: CustomImageView(
          //                                         imagePath: ImageConstant
          //                                             .imgFavorite)))),
          //                         Expanded(
          //                             child: Padding(
          //                                 padding: EdgeInsets.symmetric(
          //                                     horizontal: 4.h),
          //                                 child: CustomIconButton(
          //                                     height: 28.adaptSize,
          //                                     width: 28.adaptSize,
          //                                     padding: EdgeInsets.all(5.h),
          //                                     child: CustomImageView(
          //                                         imagePath: ImageConstant
          //                                             .imgGroup58519)))),
          //                         Expanded(
          //                             child: Padding(
          //                                 padding: EdgeInsets.symmetric(
          //                                     horizontal: 4.h),
          //                                 child: CustomIconButton(
          //                                     height: 28.adaptSize,
          //                                     width: 28.adaptSize,
          //                                     padding: EdgeInsets.all(5.h),
          //                                     child: CustomImageView(
          //                                         imagePath: ImageConstant
          //                                             .imgVuesaxLinearFlag)))),
          //                         Expanded(
          //                             child: Padding(
          //                                 padding: EdgeInsets.only(left: 4.h),
          //                                 child: CustomIconButton(
          //                                     height: 28.adaptSize,
          //                                     width: 28.adaptSize,
          //                                     padding: EdgeInsets.all(5.h),
          //                                     child: CustomImageView(
          //                                         imagePath: ImageConstant
          //                                             .imgSearch))))
          //                       ])),
          //               _buildNegotiableButton(context)
          //             ]))),

          GetBuilder<ProductController>(
              init: ProductController(Get.find(), Get.find()),
              builder: (fCntr) {
                return InkWell(
                  child: CustomImageView(
                      imagePath: fCntr.productImage,
                      height: 268.v,
                      width: 398.h,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(12.h),
                      alignment: Alignment.center),
                );
              }),

          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.fromLTRB(12.h, 12.v, 12.h, 228.v),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite)),
                        product!.type == 'premium'
                            ? Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: CustomIconButton(
                                    height: 28.adaptSize,
                                    width: 28.adaptSize,
                                    padding: EdgeInsets.all(5.h),
                                    child: CustomImageView(
                                        imagePath:
                                            ImageConstant.imgGroup58519)))
                            : SizedBox.shrink(),
                        Padding(
                            padding: EdgeInsets.only(left: 8.h),
                            child: CustomIconButton(
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                    imagePath:
                                        ImageConstant.imgVuesaxLinearFlag))),
                        Padding(
                            padding: EdgeInsets.only(left: 8.h),
                            child: CustomIconButton(
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                    imagePath: ImageConstant.imgSearch))),
                        Spacer(),
                        product?.isNegotiable == true
                            ? Expanded(child: _buildNegotiableButton1(context))
                            : SizedBox.shrink()
                      ]))),

          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 68.v,
                  width: 383.h,
                  margin: EdgeInsets.only(bottom: 8.v),
                  child: Stack(alignment: Alignment.center, children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 157.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.h, vertical: 3.v),
                            decoration: AppDecoration.fillOnPrimary1.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.roundedBorder12),
                            child: Text("photo 1/10 ${product!.images!.length}",
                                style: CustomTextStyles.labelLargeOnPrimary))),
                    Align(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  var offset = _scrollController.offset;

                                  // _scrollController.jumpTo(offset - 102);
                                  _scrollController.animateTo(offset - 124,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeIn);
                                },
                                child: CustomImageView(
                                    imagePath: ImageConstant.imgArrowLeft,
                                    height: 24.adaptSize,
                                    width: 24.adaptSize,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 22.v)),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 8.h),
                                      child: RawScrollbar(
                                        controller: _scrollController,
                                        child: GetBuilder<ProductController>(
                                            init: ProductController(
                                                Get.find(), Get.find()),
                                            builder: (pCntr) {
                                              return Center(
                                                child: ListView.builder(
                                                    controller:
                                                        _scrollController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        product.images!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () => pCntr
                                                            .setProductImage(product
                                                                    .images!
                                                                    .elementAt(
                                                                        index)[
                                                                'file']),
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      index == 0
                                                                          ? 5
                                                                          : 5,
                                                                  vertical: 0),
                                                          child: Center(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.h),
                                                              child:
                                                                  Image.network(
                                                                product.images!
                                                                        .elementAt(
                                                                            index)[
                                                                    'file'],
                                                                height: 60.v,
                                                                width: 59.h,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              );
                                            }),
                                      )
                                      // child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     children: [
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant
                                      //               .imgRectangle457,
                                      //           height: 60.v,
                                      //           width: 59.h,
                                      //           radius:
                                      //               BorderRadius.circular(8.h)),
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant
                                      //               .imgRectangle462,
                                      //           height: 60.v,
                                      //           width: 59.h,
                                      //           radius:
                                      //               BorderRadius.circular(8.h),
                                      //           margin:
                                      //               EdgeInsets.only(left: 4.h)),
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant
                                      //               .imgRectangle459,
                                      //           height: 60.v,
                                      //           width: 59.h,
                                      //           radius:
                                      //               BorderRadius.circular(8.h),
                                      //           margin:
                                      //               EdgeInsets.only(left: 4.h)),
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant
                                      //               .imgRectangle462,
                                      //           height: 60.v,
                                      //           width: 59.h,
                                      //           radius:
                                      //               BorderRadius.circular(8.h),
                                      //           margin:
                                      //               EdgeInsets.only(left: 4.h)),
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant
                                      //               .imgRectangle459,
                                      //           height: 60.v,
                                      //           width: 59.h,
                                      //           radius:
                                      //               BorderRadius.circular(8.h),
                                      //           margin:
                                      //               EdgeInsets.only(left: 4.h))
                                      //     ])

                                      )),
                              InkWell(
                                onTap: () {
                                  var offset = _scrollController.offset;

                                  _scrollController.animateTo(offset + 124,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeIn);
                                  // _scrollController.jumpTo(offset + 100);
                                  //               _scrollController.animateTo(-50,
                                  // duration: Duration(seconds: 1), curve: Curves.easeIn);
                                },
                                child: CustomImageView(
                                    imagePath: ImageConstant.imgArrowRight,
                                    height: 24.adaptSize,
                                    width: 24.adaptSize,
                                    margin: EdgeInsets.only(
                                        left: 8.h, top: 22.v, bottom: 22.v)),
                              )
                            ]))
                  ])))
        ]));
  }

  /// Section Widget
  Widget _buildIPurchasedButton(BuildContext context) {
    return CustomElevatedButton(
        height: 45.v,
        text: "I Purchased ",
        leftIcon: Container(
            margin: EdgeInsets.only(right: 8.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgThumbsupOnprimary,
                height: 22.adaptSize,
                width: 22.adaptSize)),
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary);
  }

  /// Section Widget
  Widget _buildFrameColumn(BuildContext context, Product product) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 11.v),
        decoration: AppDecoration.fillOnPrimary
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          "#${product.category != null ? product.category!.name : 'None'}",
                          style: CustomTextStyles.bodySmallOrange400),
                      SizedBox(height: 2.v),
                      SizedBox(
                          width: 274.h,
                          child: Text(product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              // textAlign: TextAlign.justify,
                              style: CustomTextStyles
                                  .titleMediumBluegray90001Medium))
                    ])),
                ProductPriceWidget(product)
              ]),
              SizedBox(height: 10.v),
              Row(children: [
                CustomImageView(
                    imagePath: ImageConstant.imgEllipse1,
                    height: 42.adaptSize,
                    width: 42.adaptSize,
                    radius: BorderRadius.circular(21.h),
                    onTap: () {
                      onTapImgCircleImage(context);
                    }),
                Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${product.adUser!.name}",
                              style: theme.textTheme.titleSmall),
                          Row(children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgLinkedinGray60001,
                                height: 20.adaptSize,
                                width: 20.adaptSize),
                            Padding(
                                padding: EdgeInsets.only(left: 8.h, top: 2.v),
                                child: Text(
                                    "${product.nationality.name.capitalize}, ${product.state!.name.capitalize}, ${product.city!.name.capitalize}",
                                    style: CustomTextStyles
                                        .bodySmallBluegray90001))
                          ])
                        ]))
              ]),
              SizedBox(height: 16.v),
              // _buildIPurchasedButton(context),
              Row(
                children: [
                  Expanded(
                    child: product.price_type == "open_offer"
                        ? _buildSendOfferButton(product, context)
                        : _buildChatButton(product.id, context),
                  ),
                  SizedBox(width: 5),

                  //  Expanded(
                  //   child: Container(
                  //   height: 40.adaptSize,
                  //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //     // decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //          CustomImageView(
                  //            imagePath: ImageConstant.imgNavMessagePrimary,
                  //          ),
                  //          SizedBox(width: 5),
                  //           Text("What's app")
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                      child: CustomOutlinedButton(
                    onPressed: () => Get.toNamed('/product_detail_screen',
                        arguments: product.id),
                    height: 42,
                    buttonStyle: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: BorderSide(width: 1.0, color: Color(0XFFD20653)),
                    ),
                    text: "What's app",
                    margin: EdgeInsets.only(left: 0.h),
                    leftIcon: Container(
                      margin: EdgeInsets.only(right: 4.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgNavMessagePrimary,
                        height: 22.adaptSize,
                        width: 22.adaptSize,
                      ),
                    ),
                  )),
                  SizedBox(width: 5),
                  SizedBox(
                    child: CustomIconButton(
                      height: 42.adaptSize,
                      width: 40.adaptSize,
                      padding: EdgeInsets.all(10.h),
                      decoration: IconButtonStyleHelper.outlinePink,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCall,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 40,
                  //   height: 40.adaptSize,

                  //   child: Container(

                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: RED_COLOR
                  //     ),
                  //     child: Icon(Icons.call),
                  //   ),
                  // )
                ],
              ),
            ]));
  }

  /// Section Widget
  Widget _buildFrameColumn1(BuildContext context, Product product) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 11.h, vertical: 10.v),
        decoration: AppDecoration.fillOnPrimary
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                    padding: EdgeInsets.only(top: 2.v),
                    child: Text("Description",
                        style: CustomTextStyles.titleMediumBluegray900)),
                Container(
                    width: 133.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.v),
                    decoration: AppDecoration.fillOnPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder4),
                    child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Translate ",
                              style: CustomTextStyles.titleSmallffd20653),
                          TextSpan(
                              text: "to English",
                              style: CustomTextStyles.titleSmallffd20653)
                        ]),
                        textAlign: TextAlign.left))
              ]),
              SizedBox(height: 8.v),
              SizedBox(
                  width: 374.h,
                  child: Text(product.description!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: CustomTextStyles.bodyLargeGray60001
                          .copyWith(height: 1.50))),
            ]));
  }

  /// Section Widget
  Widget _buildReplayValueEditText(BuildContext context) {
    return Container(
      child: CustomTextFormField(
          controller: replayValueEditTextController,
          hintText: "Reply",
          contentPadding: EdgeInsets.all(12.h)),
    );
  }

  /// Section Widget
  Widget _buildFrameRow4(BuildContext context, CommentModel comment) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (AuthController authController) {
          return !authController.isLoggedIn
              ? Text("Not Logged in")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      CustomImageView(
                          imagePath: ImageConstant.imgEllipse132x32,
                          height: 32.adaptSize,
                          width: 32.adaptSize,
                          radius: BorderRadius.circular(12.h),
                          margin: EdgeInsets.only(bottom: 38.v)),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        authController
                                            .authenticatedUser!['name']!,
                                        style: CustomTextStyles
                                            .titleMediumBluegray900Medium),
                                    SizedBox(height: 8.v),
                                    GetBuilder<CommentsController>(
                                        init: CommentsController(Get.find()),
                                        builder: (CommentsController
                                            _commentController) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                  child: SizedBox(
                                                height: 40,
                                                child: EasyAppTextFormField(
                                                    hintText: "Reply",
                                                    labelText: "Reply",
                                                    onChanged: (value) =>
                                                        _commentController
                                                            .replay = value),
                                              )),
                                              InkWell(
                                                onTap: () => _commentController
                                                    .storeComment(comment),
                                                child: Container(
                                                  width: 50,
                                                  child: Icon(
                                                    Icons.send,
                                                    color: GREY_COLOR,
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                  ])))
                    ]);
        });
  }

  /// Section Widget
  Widget _buildFrameRow6(BuildContext context, CommentModel comment) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
              imagePath: ImageConstant.imgRectangle1240x40,
              height: 40.adaptSize,
              width: 40.adaptSize,
              radius: BorderRadius.circular(20.h),
              margin: EdgeInsets.only(bottom: 53.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFrameRow(context,
                            dynamicText: comment.user!.name!),
                        SizedBox(height: 5.v),
                        Container(
                            width: 326.h,
                            padding: EdgeInsets.all(8.h),
                            decoration: AppDecoration.fillGray.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderBL8),
                            child: Text(comment.comment!,
                                style: theme.textTheme.bodyMedium)),
                        SizedBox(height: 5.v),
                        Row(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.v),
                              child: Text(comment.created_at!,
                                  style: theme.textTheme.bodySmall)),
                          CustomImageView(
                              imagePath: ImageConstant.imgUserBlueGray90001,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 12.h, top: 3.v, bottom: 3.v)),
                          Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Text("reply",
                                  style: theme.textTheme.bodyMedium))
                        ])
                      ])))
        ]);
  }

  /// Section Widget
  Widget _buildReplayvalue(BuildContext context) {
    return CustomTextFormField(
        controller: replayvalueController,
        hintText: "Reply",
        contentPadding: EdgeInsets.all(12.h));
  }

  /// Section Widget
  Widget _buildFrameRow8(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
              imagePath: ImageConstant.imgEllipse132x32,
              height: 32.adaptSize,
              width: 32.adaptSize,
              radius: BorderRadius.circular(16.h),
              margin: EdgeInsets.only(bottom: 38.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(children: [
                    Text("Eman Elsherbiny",
                        style: CustomTextStyles.titleMediumBluegray900Medium),
                    SizedBox(height: 8.v),
                    _buildReplayvalue(context)
                  ])))
        ]);
  }

  /// Section Widget
  Widget _buildReplayValueEditText1(BuildContext context) {
    return CustomTextFormField(
        controller: replayValueEditTextController1,
        hintText: "Reply",
        textInputAction: TextInputAction.done,
        contentPadding: EdgeInsets.all(12.h));
  }

  /// Section Widget
  Widget _buildFrameRow10(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
              imagePath: ImageConstant.imgEllipse132x32,
              height: 32.adaptSize,
              width: 32.adaptSize,
              radius: BorderRadius.circular(16.h),
              margin: EdgeInsets.only(bottom: 38.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(children: [
                    Text("Eman Elsherbiny",
                        style: CustomTextStyles.titleMediumBluegray900Medium),
                    SizedBox(height: 8.v),
                    _buildReplayValueEditText1(context)
                  ])))
        ]);
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
    });
  }

  /// Common widget
  Widget _buildFrameRow(
    BuildContext context, {
    required String dynamicText,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(dynamicText,
          style: CustomTextStyles.titleMediumBluegray900Medium
              .copyWith(color: appTheme.blueGray900)),
      CustomImageView(
          imagePath: ImageConstant.imgNotification,
          height: 20.adaptSize,
          width: 20.adaptSize,
          margin: EdgeInsets.only(left: 5.h))
    ]);
  }

  /// Common widget
  Widget _buildFrameRow1(
    BuildContext context, {
    required CommentModel comment,
    required int adId,
    required String h,
    required String replayText,
    required String editText,
    required String deleteText,
  }) {
    return Row(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 3.v),
          child: Text(h,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: appTheme.gray60001))),
      CustomImageView(
          imagePath: ImageConstant.imgUserBlueGray90001,
          height: 18.adaptSize,
          width: 18.adaptSize,
          margin: EdgeInsets.only(left: 12.h, top: 3.v, bottom: 3.v)),
      InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: false,
              useSafeArea: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: WHITE_COLOR,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomTextFormField(
                          autofocus: true,
                        )),
                        Icon(Icons.send)
                      ],
                    ),
                  ),
                );
              });
        },
        child: Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(replayText,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: appTheme.blueGray90001))),
      ),
      GetBuilder<CommentsController>(
          init: CommentsController(Get.find()),
          builder: (CommentsController _commentController) {
            return InkWell(
              onTap: () => _commentController.setForEdit(comment.id),
              child: Row(
                children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgEdit,
                      height: 18.adaptSize,
                      width: 18.adaptSize,
                      margin:
                          EdgeInsets.only(left: 12.h, top: 3.v, bottom: 3.v)),
                  Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                          _commentController.updatedComment > 0 &&
                                  _commentController.updatedComment ==
                                      comment.id
                              ? "Editing"
                              : editText,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: appTheme.blueGray90001)))
                ],
              ),
            );
          }),
      CustomImageView(
          imagePath: ImageConstant.imgThumbsUp,
          height: 18.adaptSize,
          width: 18.adaptSize,
          margin: EdgeInsets.only(left: 12.h, top: 3.v, bottom: 3.v)),
      Padding(
          padding: EdgeInsets.only(left: 8.h),
          child: InkWell(
            onTap: () => {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: EdgeInsets.zero,
                        insetPadding: const EdgeInsets.all(15),
                        content: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: 10,
                                  top: -15,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: WHITE_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: SizedBox(
                                        width: 22,
                                        child: CustomImageView(
                                          imagePath: ImageConstant
                                              .imgVuesaxLinearUserRemove,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                      // child: Image.asset(
                                      //     "assets/images/zahra-logo.png"),
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Delete Comment",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Are you sure you want to delete your comment?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GetBuilder<
                                                          CommentsController>(
                                                      init: CommentsController(
                                                          Get.find()),
                                                      builder: (CommentsController
                                                          _controllerComment) {
                                                        return SizedBox(
                                                          height: 42.h,
                                                          child:
                                                              CustomElevatedButton(
                                                            onPressed: () {
                                                              _controllerComment
                                                                  .delete(
                                                                      comment,
                                                                      adId);

                                                              Future.delayed(Duration(
                                                                      milliseconds:
                                                                          500))
                                                                  .then(
                                                                      (value) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            },
                                                            text:
                                                                "Yes, i'm sure"
                                                                    .tr,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 6.h),
                                                            buttonStyle:
                                                                CustomButtonStyles
                                                                    .none,
                                                            decoration:
                                                                CustomButtonStyles
                                                                    .gradientPrimaryToOrangeDecoration,
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                Expanded(
                                                  child: CustomOutlinedButton(
                                                    buttonStyle: OutlinedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      side: BorderSide(
                                                          width: 1.0,
                                                          color: Color(
                                                              0XFFD20653)),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    height: 42.v,
                                                    text: "Cancle",
                                                    margin: EdgeInsets.only(
                                                        left: 6.h),
                                                    buttonTextStyle:
                                                        CustomTextStyles
                                                            .titleMediumPink60001_1,
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
                      ))
            },
            child: Text(deleteText,
                style: CustomTextStyles.bodyMediumRed500
                    .copyWith(color: appTheme.red500)),
          ))
    ]);
  }

  /// Common widget
  Widget _buildFrameRow2(
    BuildContext context, {
    required String text1,
    required String text2,
    required String text3,
    required String text4,
    required String text5,
    required String text6,
  }) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
              imagePath: ImageConstant.imgRectangle1240x40,
              height: 40.adaptSize,
              width: 40.adaptSize,
              radius: BorderRadius.circular(20.h),
              margin: EdgeInsets.only(bottom: 53.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(text1,
                              style: CustomTextStyles
                                  .titleMediumBluegray900Medium
                                  .copyWith(color: appTheme.blueGray900)),
                          CustomImageView(
                              imagePath: ImageConstant.imgNotification,
                              height: 20.adaptSize,
                              width: 20.adaptSize,
                              margin: EdgeInsets.only(left: 5.h))
                        ]),
                        SizedBox(height: 5.v),
                        Container(
                            width: 326.h,
                            padding: EdgeInsets.all(8.h),
                            decoration: AppDecoration.fillGray.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderBL8),
                            child: Text(text2,
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: appTheme.blueGray90001))),
                        SizedBox(height: 5.v),
                        Row(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.v),
                              child: Text(text3,
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: appTheme.gray60001))),
                          CustomImageView(
                              imagePath: ImageConstant.imgUserBlueGray90001,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 12.h, top: 3.v, bottom: 3.v)),
                          Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Text(text4,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: appTheme.blueGray90001))),
                          CustomImageView(
                              imagePath: ImageConstant.imgEdit,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 12.h, top: 3.v, bottom: 3.v)),
                          Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Text(text5,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: appTheme.blueGray90001))),
                          CustomImageView(
                              imagePath: ImageConstant.imgThumbsUp,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 12.h, top: 3.v, bottom: 3.v)),
                          Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: Text(text6,
                                  style: CustomTextStyles.bodyMediumRed500
                                      .copyWith(color: appTheme.red500)))
                        ])
                      ])))
        ]);
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        //   return AppRoutes.featureAdsPage;
        // case BottomBarEnum.Category:
        //   return AppRoutes.categoryPage;
        // case BottomBarEnum.Message:
        return "/";
      case BottomBarEnum.More:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      // case AppRoutes.featureAdsPage:
      //   return FeatureAdsPage();
      // case AppRoutes.categoryPage:
      //   return CategoryPage();
      default:
        return DefaultWidget();
    }
  }

  /// Navigates to the popUpScreen when the action is triggered.
  onTapImgCircleImage(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.popUpScreen);
  }
}

Widget _buildChatButton(adId, BuildContext context) {
  return GetBuilder<ConversationsController>(
      init: ConversationsController(Get.find()),
      builder: (ConversationsController _convCntr) {
        return CustomElevatedButton(
          onPressed: () => _convCntr.openChat(adId, context),
          height: 42.v,
          text: "Chat",
          margin: EdgeInsets.only(right: 0.h),
          leftIcon: Container(
            margin: EdgeInsets.only(right: 8.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgSettingsOnprimary,
              height: 22.adaptSize,
              width: 22.adaptSize,
            ),
          ),
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
          buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
        );
      });
}

/// Section Widget
Widget _buildSendOfferButton(Product product, BuildContext context) {
  return GetBuilder<ConversationsController>(
      init: ConversationsController(Get.find()),
      builder: (ConversationsController _cntr) {
        return CustomElevatedButton(
            height: 42.v,
            width: 140.h,
            text: "Send offer",
            leftIcon: Container(
                margin: EdgeInsets.only(right: 4.h),
                child: CustomImageView(
                    imagePath: ImageConstant.imgSave,
                    height: 22.adaptSize,
                    width: 22.adaptSize)),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
            buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        contentPadding: EdgeInsets.zero,
                        insetPadding: const EdgeInsets.all(15),
                        content: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: 10,
                                  top: -15,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: WHITE_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: SizedBox(
                                        width: 22,
                                        child: CustomImageView(
                                          imagePath: ImageConstant
                                              .imgVuesaxLinearUserRemove,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Send Offer",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 0, 20, 0),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl: product.image!,
                                                    width: 75,
                                                    height: 75,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                    child: Text(
                                                  product.name,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: EasyAppTextFormField(
                                              onChanged: (value) => _cntr.offerPrice = value!,
                                              hintText: "Offer Price",
                                              labelText: "Offer Price",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                      height: 42.h,
                                                      child:
                                                          GetBuilder(builder: (ConversationsController _convCntr){
                                                            return CustomElevatedButton(
                                                        onPressed: () =>
                                                            _convCntr.sendOffer(product.id!, context),
                                                        text: "Send Offer".tr,
                                                        margin: EdgeInsets.only(
                                                            right: 6.h),
                                                        buttonStyle:
                                                            CustomButtonStyles
                                                                .none,
                                                        decoration:
                                                            CustomButtonStyles
                                                                .gradientPrimaryToOrangeDecoration,
                                                      );
                                                          })),
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
              // GestureDetector(

              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 11.v),
              //       child: Text(
              //         "Delete Account",
              //         style: CustomTextStyles.titleMediumSemiBold,
              //       ),
              //     ));

              // _cntr.sendOffer();
              // onTapSendOfferButton(context);
            });
      });
}

class ProductPriceWidget extends StatelessWidget {
  final Product? product;
  const ProductPriceWidget(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16.h, bottom: 22.v),
        child: Column(children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 1.h),
                  child: Text(" in ${product!.created_at}",
                      style: CustomTextStyles.bodySmall10))),
          Text(
            product!.price_type == "open_offer" ? "Open Offer".tr : "",
            style: TextStyle(color: Colors.green),
          ),
          product!.price_type == "open_offer"
              ? Row(
                  children: [
                    Text("${product!.min_price} ${product!.currency}",
                        style: theme.textTheme.titleMedium)
                  ],
                )
              : Text("${product!.price} ${product!.currency}",
                  style: theme.textTheme.titleMedium)
        ]));
  }
}
