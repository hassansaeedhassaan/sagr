import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/appbar/build_core_app_bar.dart';
import '../../data/colors.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_iconbutton.dart';
import '../../widgets/app_bar/appbar_title_image.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../category_page/widgets/category1_item_widget.dart';
import '../category_page/widgets/category_item_widget.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore_for_file: must_be_immutable
class CategoryPage extends StatelessWidget {
  CategoryPage({Key? key})
      : super(
          key: key,
        );

  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];


  TextEditingController checkmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(77), child: BuildCoreAppBar()),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 12.v),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.v, left: 5),
                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                decoration: AppDecoration.fillOnPrimary.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder12,
              ),
                child: SingleChildScrollView(
                  child: GetBuilder<CategoriesController>(
                    init: CategoriesController(Get.find()),
                    builder: (CategoriesController categoryController) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: categoryController.categories
                              .map((e) => Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    decoration: BoxDecoration(
                                        color: categoryController
                                                    .selectedCategory.id ==
                                                e.id
                                            ? GREY_COLOR.withOpacity(0.2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 40,
                                    width: 120,
                                    child: InkWell(
                                      onTap: () => categoryController
                                          .getChildLevelOne(e.id!),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Image.network(
                                              e.image!,
                                              width: 32.adaptSize,
                                              height: 32.adaptSize,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8.h,
                                              top: 8.v,
                                              bottom: 6.v,
                                            ),
                                            child: FittedBox(
                                              child: SizedBox(
                                                width: 70,
                                                child: Text(
                                                  e.name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: CustomTextStyles
                                                      .bodySmallBluegray90001
                                                      .copyWith(
                                                          color: appTheme
                                                              .blueGray90001,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                      //   return Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     SizedBox(height: 8.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 1",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),

                      //     SizedBox(height: 16.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle39254,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //     SizedBox(height: 24.v),
                      //     _buildComponent(
                      //       context,
                      //       userImage: ImageConstant.imgRectangle392541x32,
                      //       categoryCounterText: "Category 2",
                      //     ),
                      //   ],
                      // );
                    },
                  ),
                ),
              ), ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 70.v,
      leadingWidth: 53.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgGlobe,
        margin: EdgeInsets.only(
          left: 15.h,
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
            left: 16.h,
            top: 16.v,
            right: 16.h,
          ),
        ),
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgClockPrimary,
          margin: EdgeInsets.only(
            left: 8.h,
            top: 16.v,
            right: 32.h,
          ),
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildCategory(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 0),
        padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 4),
        decoration: AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder8,
        ),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 100.v,
            crossAxisCount: 3,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.h,
          ),
          physics: BouncingScrollPhysics(),
          itemCount: 12,
          itemBuilder: (context, index) {
            // return CategoryItemWidget();
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCategory1(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 100.v,
          crossAxisCount: 3,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.h,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Category1ItemWidget();
        },
      ),
    );
  }

  /// Common widget
  Widget _buildComponent(
    BuildContext context, {
    required String userImage,
    required String categoryCounterText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: userImage,
          height: 32.adaptSize,
          width: 32.adaptSize,
          radius: BorderRadius.circular(
            6.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.h,
            top: 8.v,
            bottom: 6.v,
          ),
          child: Text(
            categoryCounterText,
            style: CustomTextStyles.bodySmallBluegray90001.copyWith(
              color: appTheme.blueGray90001,
            ),
          ),
        ),
      ],
    );
  }
}
