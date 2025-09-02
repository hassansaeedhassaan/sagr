// import 'package:eltikia_s_application6/core/app_export.dart';
// import 'package:eltikia_s_application6/widgets/custom_elevated_button.dart';
// import 'package:eltikia_s_application6/widgets/custom_icon_button.dart';
// import 'package:eltikia_s_application6/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/widgets/Common/location_widget.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_outlined_button.dart';

// ignore: must_be_immutable
class Userprofile4ItemWidget extends StatelessWidget {
  late ProductModel product;
  Userprofile4ItemWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 107.v,
                width: 110.h,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      height: 113.v,
                      width: 125.h,
                      child: ClipRRect(
                        child: Image.network(product.image!, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8.h,
                          top: 8.v,
                        ),
                        child: Row(
                          children: [
                            CustomIconButton(
                              height: 28.adaptSize,
                              width: 28.adaptSize,
                              padding: EdgeInsets.all(4.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgClosePrimary,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.h),
                              child: CustomIconButton(
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                                padding: EdgeInsets.all(5.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgGroup58519,
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
              SizedBox(
                height: 113.v,
                width: 237.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 1.v,
                          right: 1.h,
                        ),
                        child: Text(
                          " in ${product.created_at}",
                          style: CustomTextStyles.bodySmall10,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 113.v,
                        width: 237.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 237.h,
                                margin: EdgeInsets.only(top: 18.v),
                                child: Text(
                                  "${product.name}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "#cars",
                                      style:
                                          CustomTextStyles.bodySmallOrange400_1,
                                    ),
                                    SizedBox(height: 44.v),
                                    LocationWidget(
                                        location:
                                            "${product.nationality.name}, ${product.city!.name}"),
                                    SizedBox(height: 6.v),
                                    Text(
                                      "${product.price} ${product.currency} ",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
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
          SizedBox(height: 15.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        height: 42.v,
                        text: "Chat ",
                        margin: EdgeInsets.only(right: 4.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 8.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgSettingsOnprimary,
                            height: 22.adaptSize,
                            width: 22.adaptSize,
                          ),
                        ),
                        buttonStyle: CustomButtonStyles.none,
                        decoration: CustomButtonStyles
                            .gradientPrimaryToOrangeDecoration,
                        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      ),
                    ),
                    Expanded(
                      child: CustomOutlinedButton(
                        onPressed: () => Get.toNamed('/product_detail_screen', arguments: product.id),
                        height: 42,
                        buttonStyle: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side:
                              BorderSide(width: 1.0, color: Color(0XFFD20653)),
                        ),
                        text: "View",
                        margin: EdgeInsets.only(left: 4.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 8.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgEyePrimary,
                            height: 22.adaptSize,
                            width: 22.adaptSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: CustomIconButton(
                  height: 42.adaptSize,
                  width: 42.adaptSize,
                  padding: EdgeInsets.all(11.h),
                  decoration: IconButtonStyleHelper.outlinePink,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVolume,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
