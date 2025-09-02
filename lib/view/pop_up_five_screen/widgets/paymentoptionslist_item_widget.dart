import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class PaymentoptionslistItemWidget extends StatelessWidget {
  const PaymentoptionslistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.h,
        vertical: 12.v,
      ),
      decoration: AppDecoration.outlinePrimary1.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgThumbsUpGray60001,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Pay ",
                        style: CustomTextStyles.titleMediumff4f4f4f,
                      ),
                      TextSpan(
                        text: "by",
                        style: CustomTextStyles.titleMediumff4f4f4f,
                      ),
                      TextSpan(
                        text: " wallet ",
                        style: CustomTextStyles.titleMediumff4f4f4f,
                      ),
                      TextSpan(
                        text: "(1200SR)",
                        style: CustomTextStyles.titleMediumff0ec784,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          CustomImageView(
            imagePath: ImageConstant.imgContrast,
            height: 20.adaptSize,
            width: 20.adaptSize,
          ),
        ],
      ),
    );
  }
}
