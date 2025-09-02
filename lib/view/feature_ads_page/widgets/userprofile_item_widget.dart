
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/products/data/models/product_model.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class ProductItemWidget extends StatelessWidget {

  final ProductModel? product;
  const ProductItemWidget({Key? key, this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 135.v,
          width: 195.h,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [


              Container(
                 alignment: Alignment.center,
                 height: 135.v,
                width: 195.h,
                child: ClipRRect(
                  borderRadius:  BorderRadius.vertical(
                  top: Radius.circular(12.h),
                ),
                  child: Image.network(product!.image!),
                ),
              ),


              // CustomImageView(
              //   imagePath: ImageConstant.imgRectangle12,
              //   height: 135.v,
              //   width: 195.h,
              //   radius: BorderRadius.vertical(
              //     top: Radius.circular(12.h),
              //   ),
              //   alignment: Alignment.center,
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.h,
                    top: 8.v,
                  ),
                  child: Row(
                    children: [
                      // CustomIconButton(
                      //   height: 28.adaptSize,
                      //   width: 28.adaptSize,
                      //   padding: EdgeInsets.all(4.h),
                      //   child: CustomImageView(
                      //     imagePath: ImageConstant.imgFavorite,
                      //   ),
                      // ),
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.h,
            vertical: 6.v,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
            borderRadius: BorderRadiusStyle.customBorderBL12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#cars",
                    style: CustomTextStyles.bodySmallOrange400,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.h),
                    child: Text(
                      " in ${product!.created_at}",
                      style: CustomTextStyles.bodySmall10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.v),
              SizedBox(
           
                child: Text(
                "${product!.name} ",
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleSmallSemiBold,
              ),
              ),
              SizedBox(height: 5.v),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgLinkedin,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      top: 1.v,
                      bottom: 2.v,
                    ),
                  ),
                  FittedBox(child: Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "Dakahlia, Mansoura",
                      style: theme.textTheme.bodySmall,
                    ),
                  )),
                ],
              ),
              SizedBox(height: 10.v),
              Text(
                "${product!.price} ${product!.currency}",
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
