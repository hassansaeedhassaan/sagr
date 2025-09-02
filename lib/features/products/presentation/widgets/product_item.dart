
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../data/colors.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../view/share_your_adds_one_screen/maps_screen.dart';
import '../../../../view/widgets/Forms/easy_app_text_form_field.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_outlined_button.dart';
import '../../../chat/presentation/controllers/conversations_controller.dart';
import '../../domain/entities/product.dart';

class ProductItem extends StatefulWidget {
  final Product obj;
  ProductItem({super.key, required this.obj});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _activePage = 0;


  final PageController _pageController = PageController(initialPage: 0);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(height: 12),
        // Text(widget.obj.images!.length.toString()),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            fit: StackFit.loose,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _activePage = value;
                        });
                      },
                      controller: _pageController,
                      itemCount: widget.obj.images!.length,
                      itemBuilder: (context, index) {
                        SizedBox(
                          height: 10,
                        );
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                                imageUrl: widget.obj.images![index]['file'],
                                fit: BoxFit.cover),
                          ),
                        );
                      })),
              Positioned(
                  top: 10,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                        color: MAZ_GREEN,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      "Negabble",
                      style: TextStyle(color: WHITE_COLOR),
                    ),
                  )),
              Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(4.h),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgFavorite)),
                        Padding(
                            padding: EdgeInsets.only(left: 8.h),
                            child: CustomIconButton(
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                    imagePath: ImageConstant.imgGroup58519))),
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
                      ],
                    ),
                  )),
              Positioned(
                bottom: 10,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: BLACK_COLOR,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (() {


                  


                          setState(() {
                            if (_activePage > 0) {
                              _activePage -= 1;
                            }
                          });

                          _pageController.animateToPage(_activePage,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);


          var offset = _scrollController.offset;

                          // _scrollController.jumpTo(offset - 102);
                          _scrollController.animateTo(offset - 90,
                              duration: Duration(microseconds: 200),
                              curve: Curves.easeIn);
                        
                        }),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: WHITE_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 80,
                          child: RawScrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.obj.images!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      _pageController.animateToPage(index,
                                          duration:
                                              Duration(microseconds: 10000),
                                          curve: Curves.easeIn);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: _activePage == index
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: GradientBoxBorder(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    ZAHRA_ORANGE,
                                                    ZAHRA_RED
                                                  ],
                                                ),
                                                width: 2,
                                              ),
                                            )
                                          : BoxDecoration(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.obj.images![index]
                                              ['file'],
                                          width: 80,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )),
                      GestureDetector(
                        onTap: (() {setState(() {
                              if (_activePage < widget.obj.images!.length - 1) {
                                _activePage += 1;
                               
                              }
                            });

 _pageController.animateToPage(_activePage,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn);


                               var offset = _scrollController.offset;

                                  _scrollController.animateTo(offset + 90,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn);

  }),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: WHITE_COLOR,
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

        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.h, vertical: 11.v),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        "#${widget.obj.category != null ? widget.obj.category!.name : 'None'}",
                                        style: CustomTextStyles
                                            .bodySmallOrange400),
                                    SizedBox(height: 2.v),
                                    SizedBox(
                                        width: 274.h,
                                        child: Text(widget.obj.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            // textAlign: TextAlign.justify,
                                            style: CustomTextStyles
                                                .titleMediumBluegray90001Medium))
                                  ])),
                              ProductPriceWidget(widget.obj)
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
                                    Text("${widget.obj.adUser!.name}",
                                        style: theme.textTheme.titleSmall),
                                    Row(children: [
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgLinkedinGray60001,
                                          height: 20.adaptSize,
                                          width: 20.adaptSize),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.h, top: 2.v),
                                          child: Text(
                                              "${widget.obj.nationality.name.capitalize}, ${widget.obj.state!.name.capitalize}, ${widget.obj.city!.name.capitalize}",
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
                                flex: 3,
                                child: widget.obj.price_type == "open_offer"
                                    ? _buildSendOfferButton(widget.obj, context)
                                    : _buildChatButton(widget.obj.id, context)),
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
                                flex: 3,
                                child: CustomOutlinedButton(
                                  onPressed: () => Get.toNamed(
                                      '/product_detail_screen',
                                      arguments: widget.obj.id),
                                  height: 42,
                                  buttonStyle: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    side: BorderSide(
                                        width: 1.0, color: Color(0XFFD20653)),
                                  ),
                                  text: "What's app",
                                  margin: EdgeInsets.only(left: 0.h),
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 0.h),
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.imgNavMessagePrimary,
                                      height: 22.adaptSize,
                                      width: 22.adaptSize,
                                    ),
                                  ),
                                )),
                            SizedBox(width: 5),
                            Expanded(
                                child: SizedBox(
                              child: CustomIconButton(
                                height: 42.adaptSize,
                                width: 40.adaptSize,
                                padding: EdgeInsets.all(10.h),
                                decoration: IconButtonStyleHelper.outlinePink,
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgCall,
                                ),
                              ),
                            )),
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
                      ])),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: SizedBox(
              //           height: 42.h,
              //           child: CustomElevatedButton(
              //             text: "Yes, i'm sure".tr,
              //             margin: EdgeInsets.only(right: 6.h),
              //             buttonStyle: CustomButtonStyles.none,
              //             decoration: CustomButtonStyles
              //                 .gradientPrimaryToOrangeDecoration,
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: CustomOutlinedButton(
              //           buttonStyle: OutlinedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12.0),
              //             ),
              //             side:
              //                 BorderSide(width: 1.0, color: Color(0XFFD20653)),
              //           ),
              //           onPressed: () => Navigator.pop(context),
              //           height: 42.v,
              //           text: "Cancle",
              //           margin: EdgeInsets.only(left: 6.h),
              //           buttonTextStyle:
              //               CustomTextStyles.titleMediumPink60001_1,
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        )
      ],
    );
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
              width: 150.h,
              text: "Send offer",
              leftIcon: Container(
                  margin: EdgeInsets.only(right: 0.h),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 0, 20, 0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: EasyAppTextFormField(
                                                onChanged: (value) =>
                                                    _cntr.offerPrice = value!,
                                                hintText: "Offer Price",
                                                labelText: "Offer Price",
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                        height: 42.h,
                                                        child: GetBuilder(builder:
                                                            (ConversationsController
                                                                _convCntr) {
                                                          return CustomElevatedButton(
                                                            onPressed: () =>
                                                                _convCntr
                                                                    .sendOffer(
                                                                        product
                                                                            .id!,
                                                                        context),
                                                            text:
                                                                "Send Offer".tr,
                                                            margin:
                                                                EdgeInsets.only(
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
}
