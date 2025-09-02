import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_outlined_button.dart';

// ignore: must_be_immutable
class Userprofile3ItemWidget extends StatelessWidget {
  final Product product;

  Userprofile3ItemWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 5.v,
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
              product.image == ""
                  ? Container(
                      decoration: BoxDecoration(
                          color: GREY_COLOR.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: SizedBox(
                        height: 105.v,
                        width: 110.h,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      width: 110.h, height: 105.v, imageUrl: product.image!,
                      fit: BoxFit.cover,
                      ),
                  ),
              // CustomImageView(
              //   imagePath: ImageConstant.imgRectangle11,
              //   height: 105.v,
              //   width: 110.h,
              //   radius: BorderRadius.circular(
              //     12.h,
              //   ),
              // ),
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
                                margin: EdgeInsets.only(top: 22.v),
                                child: Text(
                                  "${product.name}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.justify,
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
                                      "#${product.category?.name!}",
                                      style:
                                          CustomTextStyles.bodySmallOrange400_1,
                                    ),
                                    SizedBox(height: 44.v),
                                    Row(
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant.imgLinkedin,
                                          height: 20.adaptSize,
                                          width: 20.adaptSize,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 4.h),
                                          child: Text(
                                            "${product.nationality.name.capitalize}, ${product.state!.name}, ${product.city!.name}",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.v),
                                    Text(
                                      "${product.price} ${product.currency}",
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
                child: CustomElevatedButton(
                  onPressed: () => Get.toNamed('/product_detail_screen', arguments: product.id!, preventDuplicates: true),
                  height: 42.v,
                  text: "View" ,
                  margin: EdgeInsets.only(right: 4.h),
                  leftIcon: Container(
                    margin: EdgeInsets.only(right: 8.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgEyeOnprimary,
                      height: 22.adaptSize,
                      width: 22.adaptSize,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.none,
                  decoration:
                      CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                  buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                ),
              ),
              Expanded(
                child: CustomOutlinedButton(

                  onPressed: () => Get.toNamed('/product_info', arguments: product.id, preventDuplicates: true),
                  buttonStyle: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    side: BorderSide(width: 1.0, color: Color(0XFFD20653)),
                  ),
                  height: 42.v,
                  text: "Edit",
                  margin: EdgeInsets.only(left: 4.h),
                  leftIcon: Container(
                    margin: EdgeInsets.only(right: 8.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgMenu,
                      height: 22.adaptSize,
                      width: 22.adaptSize,
                    ),
                  ),
                  buttonTextStyle: CustomTextStyles.titleMediumPink60001,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
