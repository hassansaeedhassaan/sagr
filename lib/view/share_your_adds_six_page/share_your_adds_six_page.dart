import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/presentation/controllers/product_controller.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:sagr/view/widgets/Forms/textarea_form_field.dart';

import '../../core/utils/image_constant.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/categories/presentation/controllers/categories_controller.dart';
import '../../features/countries/presentation/controllers/countries_controller.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/Common/custom_dropdown.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_image_view.dart';
import '../share_your_adds_six_page/widgets/userprofilelist1_item_widget.dart';

import 'package:flutter/material.dart';

import '../widgets/Forms/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class ShareYourAddsSixPage extends StatefulWidget {
  final Product? product;
  const ShareYourAddsSixPage(this.product, {Key? key})
      : super(
          key: key,
        );

  @override
  ShareYourAddsSixPageState createState() => ShareYourAddsSixPageState();
}

class ShareYourAddsSixPageState extends State<ShareYourAddsSixPage>
    with AutomaticKeepAliveClientMixin<ShareYourAddsSixPage> {
  TextEditingController electronicsLabelController = TextEditingController();

  TextEditingController titleTextFieldController = TextEditingController();

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

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];
  String? selectedValue;
  TextEditingController phoneNumberEditTextController = TextEditingController();

  TextEditingController inputEditTextController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ProductController>(
          init: ProductController(Get.find(), Get.find()),
          builder: (ProductController _prodCntr) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.v),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.h),
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
                                  "Add info",
                                  style: CustomTextStyles
                                      .titleMediumBluegray90001_1,
                                ),
                                SizedBox(height: 5.v),
                                // _buildElectronicsLabel(context),
                                CategoryDropDown(_prodCntr.categoryName),
                                // DropdownButtonHideUnderline(
                                //   child: DropdownButton2<String>(
                                //     iconStyleData: IconStyleData(
                                //         icon: Container(
                                //       margin: EdgeInsets.symmetric(horizontal: 14.h),
                                //       child: CustomImageView(
                                //         imagePath:
                                //             ImageConstant.imgCheckmarkGray50001,
                                //         height: 20.adaptSize,
                                //         width: 20.adaptSize,
                                //       ),
                                //     )),
                                //     isExpanded: true,
                                //     hint: Text(
                                //       'Select Item',
                                //       style: TextStyle(
                                //         fontSize: 14,
                                //         color: Theme.of(context).hintColor,
                                //       ),
                                //     ),
                                //     items: items
                                //         .map((item) => DropdownMenuItem(
                                //               value: item,
                                //               child: Text(
                                //                 item,
                                //                 style: const TextStyle(
                                //                   fontSize: 14,
                                //                 ),
                                //               ),
                                //             ))
                                //         .toList(),
                                //     value: selectedValue,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         selectedValue = value;
                                //       });
                                //     },
                                //     buttonStyleData: ButtonStyleData(
                                //         padding: EdgeInsets.symmetric(horizontal: 0),
                                //         height: 48,
                                //         // width: 200,

                                //         decoration: BoxDecoration(
                                //             color: WHITE_COLOR,
                                //             borderRadius: BorderRadius.circular(12),
                                //             border: Border.all(
                                //                 width: 1,
                                //                 color: GREY_COLOR.withOpacity(0.3)))),
                                //     dropdownStyleData: DropdownStyleData(
                                //       elevation: 0,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(12),
                                //           color: const Color.fromARGB(
                                //               255, 240, 240, 240)),
                                //       maxHeight: 200,
                                //     ),
                                //     menuItemStyleData: const MenuItemStyleData(
                                //       height: 40,
                                //     ),
                                //     // dropdownSearchData: DropdownSearchData(
                                //     //   searchInnerWidgetHeight: 50,
                                //     //   searchInnerWidget: Container(
                                //     //     height: 50,
                                //     //     padding: const EdgeInsets.only(
                                //     //       top: 8,
                                //     //       bottom: 4,
                                //     //       right: 8,
                                //     //       left: 8,
                                //     //     ),
                                //     //     child: TextFormField(
                                //     //       expands: true,
                                //     //       maxLines: null,
                                //     //       decoration: InputDecoration(
                                //     //         isDense: true,
                                //     //         contentPadding: const EdgeInsets.symmetric(
                                //     //           horizontal: 10,
                                //     //           vertical: 8,
                                //     //         ),
                                //     //         hintText: 'Search for an item...',
                                //     //         hintStyle: const TextStyle(fontSize: 12),
                                //     //         border: OutlineInputBorder(
                                //     //           borderRadius: BorderRadius.circular(8),
                                //     //         ),
                                //     //       ),
                                //     //     ),
                                //     //   ),
                                //     //   searchMatchFn: (item, searchValue) {
                                //     //     return item.value.toString().contains(searchValue);
                                //     //   },
                                //     // ),
                                //     //This to clear the search value when you close the menu
                                //     onMenuStateChange: (isOpen) {
                                //       if (!isOpen) {
                                //         // textEditingController.clear();
                                //       }
                                //     },
                                //   ),
                                // ),
                                SizedBox(height: 15.v),
                                CustomTextFormField(
                                  labelText: "Ad title",
                                  hintText: "Ad title",
                                  initialValue: _prodCntr.title,
                                  onSave: (value) => _prodCntr.title = value!,
                                  // initialValue: widget.product!.name,
                                ),
                                // _buildTitleTextField(context),
                                SizedBox(height: 10.v),
                                SizedBox(
                                    height: 70,
                                    child: TextareaFormField(
                                      labelText: "Description",
                                      hintText: "Description",
                                      initialValue: _prodCntr.description!,
                                      onSave: (value) =>
                                          _prodCntr.description = value!,
                                    )),
                                // SizedBox(height: 15.v),

                                // _buildDescriptionStack(context),
                                SizedBox(height: 10.v),

                                PriceTypeDropdown(widget.product),

                                SizedBox(height: 12.v),

                                _prodCntr.priceType ==  'fixed'? SizedBox(
                                        child: 
                                        
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: GREY_COLOR
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(8.h)
                                              // color: PURPLE_COLOR
                                              ),
                                          child: Row(
                                            children: [
                                              Expanded(child: 
                                              TextFormField(
                                                initialValue: widget.product!.price,
                                                onSaved: (value) => _prodCntr.price = value,
                                                      decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Price',
                                                  ),
                                              )
                                              // TextField(
                                              //   controller: TextEditingController()..value = widget.product!.price!,
                                              //   onChanged: (value) => _prodCntr.price = value,
                                              //     decoration: InputDecoration(
                                              //       border: InputBorder.none,
                                              //       hintText: 'Price',
                                              //     ),
                                              //   )
                                                ),
                                              SizedBox(
                                                width: 75,
                                                child: PriceCurrencyDropdown(
                                                    widget.product),
                                              )
                                            ],
                                          ),
                                        ),
                                      ) : Container(
                                  decoration: BoxDecoration(color: WHITE_COLOR),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: 
                                        
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: GREY_COLOR
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(8.h)
                                              // color: PURPLE_COLOR
                                              ),
                                          child: TextField(
                                      controller: TextEditingController()..text = widget.product!.min_price!,
                                                onChanged: (value) => _prodCntr.minPrice = value,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Price',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                       SizedBox(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: GREY_COLOR
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(8.h)
                                              // color: PURPLE_COLOR
                                              ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: TextField(
                                                  controller: TextEditingController()..text = widget.product!.price!,
                                                      onChanged: (value) => _prodCntr.price = value,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Max Price',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 75,
                                                child: PriceCurrencyDropdown(
                                                    widget.product),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                // _buildPriceRow(context),
                                SizedBox(height: 12.v),
                                EasyAppTextFormField(

                                  
                                    initialValue: _prodCntr.phone,
                                    onSave: (value) =>  _prodCntr.phone = value,
                                    labelText: "Phone",
                                    hintText: "Phone"),
                                SizedBox(height: 12.v),
                                EasyAppTextFormField(
                                             initialValue: _prodCntr.product!.whatsapp_number,
                                    labelText: "Whatsapp",
                                              onSave: (value) =>  _prodCntr.whatsapp = value,
                                    hintText: "Whatsapp"),

                                SizedBox(height: 12.v),
                                // _buildUserProfileList(context),



                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                         onTap: () => _prodCntr.updateAdType('free'),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 6.h),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                            vertical: 12.v,
                                          ),
                                          decoration: AppDecoration
                                              .outlinePrimary1
                                              .copyWith(
                                                  borderRadius: BorderRadiusStyle
                                                      .roundedBorder12,
                                                  border: Border.all(
                                                      color:
                                                          _prodCntr.type ==
                                                                  'free'
                                                              ? ZAHRA_RED
                                                              : GREY_COLOR)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // CustomImageView(
                                              //   imagePath: ImageConstant.imgVuesaxLinearCrown,
                                              //   height: 24.adaptSize,
                                              //   width: 24.adaptSize,
                                              // ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.h),
                                                child: Text(
                                                  "Normal",
                                                  style: CustomTextStyles
                                                      .titleMediumErrorContainerMedium,
                                                ),
                                              ),
                                              Spacer(),
                                        
                                              _prodCntr.type == 'free'
                                                  ? CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgContrast,
                                                      height: 20.adaptSize,
                                                      width: 20.adaptSize,
                                                    )
                                                  : CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgContrastPrimarycontainer,
                                                      height: 20.adaptSize,
                                                      width: 20.adaptSize,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _prodCntr.updateAdType('premium'),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 6.h),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                            vertical: 12.v,
                                          ),
                                          decoration: AppDecoration
                                              .outlinePrimary1
                                              .copyWith(
                                                  borderRadius: BorderRadiusStyle
                                                      .roundedBorder12,
                                                  border: Border.all(
                                                      color:
                                                          _prodCntr.type !=
                                                                  'free'
                                                              ? ZAHRA_RED
                                                              : GREY_COLOR)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgVuesaxLinearCrown,
                                                height: 24.adaptSize,
                                                width: 24.adaptSize,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.h),
                                                child: Text(
                                                  "Premium",
                                                  style: CustomTextStyles
                                                      .titleMediumErrorContainerMedium,
                                                ),
                                              ),
                                              Spacer(),
                                              _prodCntr.type != 'free'
                                                  ? CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgContrast,
                                                      height: 20.adaptSize,
                                                      width: 20.adaptSize,
                                                    )
                                                  : CustomImageView(
                                                      imagePath: ImageConstant
                                                          .imgContrastPrimarycontainer,
                                                      height: 20.adaptSize,
                                                      width: 20.adaptSize,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.v),
                                GetBuilder<ProductController>(
                                    init: ProductController(Get.find(), Get.find()),
                                    builder:
                                        (ProductController _productController) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CustomAnimatedToggleSwitch<
                                                    bool>(
                                                  current:
                                                      _productController.status,
                                                  values: [false, true],
                                                  spacing: 0.0,
                                                  indicatorSize:
                                                      Size.square(18.0),
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  animationCurve: Curves.linear,
                                                  onChanged: (b) =>
                                                      _productController
                                                          .toggleStatus(),
                                                  iconBuilder:
                                                      (context, local, global) {
                                                    return const SizedBox();
                                                  },
                                                  cursors: ToggleCursors(
                                                      defaultCursor:
                                                          SystemMouseCursors
                                                              .click),
                                                  onTap: (_) =>
                                                      _productController
                                                          .toggleStatus(),
                                                  iconsTappable: false,
                                                  wrapperBuilder:
                                                      (context, global, child) {
                                                    return SizedBox(
                                                      width: 40,
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Positioned(
                                                              left: 0.0,
                                                              right: 0.0,
                                                              height: 20.0,
                                                              child: Container(
                                                                width: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _productController.status ==
                                                                          true
                                                                      ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              1)
                                                                      : Color.lerp(
                                                                          Colors
                                                                              .black26,
                                                                          theme
                                                                              .colorScheme
                                                                              .background,
                                                                          global
                                                                              .position),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                              )),
                                                          child,
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  foregroundIndicatorBuilder:
                                                      (context, global) {
                                                    return SizedBox.fromSize(
                                                      size:
                                                          global.indicatorSize,
                                                      child: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: WHITE_COLOR,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black38,
                                                                spreadRadius:
                                                                    0.05,
                                                                blurRadius: 1.1,
                                                                offset: Offset(
                                                                    0.0, 0.8))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Active",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CustomAnimatedToggleSwitch<
                                                    bool>(
                                                  current:
                                                      _productController.sold,
                                                  values: [false, true],
                                                  spacing: 0.0,
                                                  indicatorSize:
                                                      Size.square(18.0),
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  animationCurve: Curves.linear,
                                                  onChanged: (b) =>
                                                      _productController
                                                          .toggleSold(),
                                                  iconBuilder:
                                                      (context, local, global) {
                                                    return const SizedBox();
                                                  },
                                                  cursors: ToggleCursors(
                                                      defaultCursor:
                                                          SystemMouseCursors
                                                              .click),
                                                  onTap: (_) =>
                                                      _productController
                                                          .toggleSold(),
                                                  iconsTappable: false,
                                                  wrapperBuilder:
                                                      (context, global, child) {
                                                    return SizedBox(
                                                      width: 40,
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Positioned(
                                                              left: 0.0,
                                                              right: 0.0,
                                                              height: 20.0,
                                                              child: Container(
                                                                width: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _productController.sold ==
                                                                          true
                                                                      ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              1)
                                                                      : Color.lerp(
                                                                          Colors
                                                                              .black26,
                                                                          theme
                                                                              .colorScheme
                                                                              .background,
                                                                          global
                                                                              .position),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                              )),
                                                          child,
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  foregroundIndicatorBuilder:
                                                      (context, global) {
                                                    return SizedBox.fromSize(
                                                      size:
                                                          global.indicatorSize,
                                                      child: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              _productController
                                                                      .sold
                                                                  ? WHITE_COLOR
                                                                  : WHITE_COLOR,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black38,
                                                                spreadRadius:
                                                                    0.05,
                                                                blurRadius: 1.1,
                                                                offset: Offset(
                                                                    0.0, 0.8))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Sold".tr,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.v),
                          _buildFrame(context),
                        ],
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
  Widget _buildElectronicsLabel(BuildContext context) {
    return CustomFloatingTextField(
      controller: electronicsLabelController,
      labelText: "Category",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Category",
      suffix: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkGray50001,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
      ),
      suffixConstraints: BoxConstraints(
        maxHeight: 57.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildTitleTextField(BuildContext context) {
    return CustomFloatingTextField(
      controller: titleTextFieldController,
      labelText: "Title",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Title",
      suffix: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkGray50001,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
      ),
      suffixConstraints: BoxConstraints(
        maxHeight: 58.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildDescriptionStack(BuildContext context) {
    return SizedBox(
      height: 88.v,
      width: 376.h,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13.h,
                vertical: 16.v,
              ),
              decoration: AppDecoration.outlineGray.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
              child: SizedBox(
                width: 348.h,
                child: Text(
                  "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet ",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style:
                      CustomTextStyles.titleMediumBluegray90001Medium.copyWith(
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 17.v,
              width: 70.h,
              margin: EdgeInsets.only(left: 18.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.v),
                      child: SizedBox(
                        width: 70.h,
                        child: Divider(
                          color: theme.colorScheme.onPrimary.withOpacity(1),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Description",
                      style: theme.textTheme.bodySmall,
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

  /// Section Widget
  Widget _buildPriceRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 7.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 8.h,
              top: 3.v,
              bottom: 4.v,
            ),
            child: Text(
              "Price",
              style: CustomTextStyles.bodyMediumErrorContainer,
            ),
          ),
          CustomDropDown(
            width: 52.h,
            icon: Container(
              margin: EdgeInsets.fromLTRB(4.h, 6.v, 8.h, 6.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowdownPrimary,
                height: 16.adaptSize,
                width: 16.adaptSize,
              ),
            ),
            hintText: "SR",
            hintStyle: CustomTextStyles.bodySmallPrimary,
            items: dropdownItemList1,
            borderDecoration:
                DropDownStyleHelper.gradientSecondaryContainerToOrange,
            filled: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  // /// Section Widget
  // Widget _buildPhoneNumberEditText(BuildContext context) {
  //   return CustomTextFormField(
  //     controller: phoneNumberEditTextController,
  //     hintText: "Phone number",
  //     hintStyle: CustomTextStyles.bodyMediumErrorContainer,
  //     textInputType: TextInputType.phone,
  //   );
  // }

  // /// Section Widget
  // Widget _buildInputEditText(BuildContext context) {
  //   return CustomTextFormField(
  //     controller: inputEditTextController,
  //     hintText: "WhatSAPP number",
  //     hintStyle: CustomTextStyles.bodyMediumErrorContainer,
  //     textInputAction: TextInputAction.done,
  //     textInputType: TextInputType.number,
  //   );
  // }

  /// Section Widget
  Widget _buildUserProfileList(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (
        context,
        index,
      ) {
        return SizedBox(
          height: 12.v,
        );
      },
      itemCount: 1,
      itemBuilder: (context, index) {
        return Userprofilelist1ItemWidget('');
      },
    );
  }

  /// Section Widget
  Widget _buildUpdateButton(BuildContext context) {
    return GetBuilder(builder: (ProductController _productController) {
      return CustomElevatedButton(
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            _productController.updateAd(2);
          }
        },
        text: "Update ",
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
      );
    });
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 16.v,
      ),
      decoration: AppDecoration.fillOnPrimary,
      child: _buildUpdateButton(context),
    );
  }
}

class PriceTypeDropdown extends StatelessWidget {
  Product? product;
  PriceTypeDropdown(this.product, {super.key});

  final List<String> dropdownItemList = ["Fixed Price", "Offer Price"];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (ProductController _productController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: GREY_COLOR.withOpacity(0.4)),
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<String?>(
                // onChange: (int index) => print(index),
                onChange: (int index) =>
                    _productController.updateAdPriceType(dropdownItemList[index]),
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
                child: Text(_productController.priceType == "fixed"
                    ? "Fixed Price"
                    : "Offer Price"),
              );
            }),
      );
    });
  }
}

class PriceCurrencyDropdown extends StatelessWidget {
  Product? product;
  PriceCurrencyDropdown(this.product, {super.key});

  final List<String> dropdownItemList = ["SA", "AMD", 'EGP'];
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (ProductController _productController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: WHITE_COLOR,
            gradient: LinearGradient(
              //  begin: Alignment(-0.11, -0.23),
              end: Alignment(1.0, 0.8),
              colors: [
                theme.colorScheme.primary.withOpacity(0.2),
                appTheme.orange400.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: GetBuilder<CountriesController>(
            init: CountriesController(Get.find()),
            builder: (catCntr) {
              return CustomDropdownV2<String?>(
                onChange: (int index) => print(index),
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: ZAHRA_RED,
                  size: 24,
                ),
                // onChange: (int index) =>
                //     _productController.setPriceType(dropdownItemList[index]),
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 30,
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
                child: Text(
                  product!.currency!,
                  style:
                      TextStyle(color: ZAHRA_RED, fontWeight: FontWeight.w600),
                ),
              );
            }),
      );
    });
  }
}

class CategoryDropDown extends StatelessWidget {
  final String? category;
  const CategoryDropDown(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (ProductController _prodCntr) {
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
                // onChange: (int index) => print(""),
                onChange: (int index) =>
                    _prodCntr.setCurrentCategory(catCntr.categories[index]),
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
                child: Text(_prodCntr.categoryName.toString()),
              );
            }),
      );
    });
  }
}

