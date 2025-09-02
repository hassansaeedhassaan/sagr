import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Userprofilelist1ItemWidget extends StatelessWidget {

  String? type;

  Userprofilelist1ItemWidget(this.type, {Key? key})
      : super(
          key: key,
        );

  String radioGroup = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 6.h),
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 12.v,
            ),
            decoration: AppDecoration.outlinePrimary1.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
              
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgVuesaxLinearCrown,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Premium",
                    style: CustomTextStyles.titleMediumErrorContainerMedium,
                  ),
                ),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgContrast,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
                
              ],
            ),
          ),
        ),

        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 6.h),
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 12.v,
            ),
            decoration: AppDecoration.outlinePrimary1.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
              border: Border.all(color: GREY_COLOR)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CustomImageView(
                //   imagePath: ImageConstant.imgVuesaxLinearCrown,
                //   height: 24.adaptSize,
                //   width: 24.adaptSize,
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Normal",
                    style: CustomTextStyles.titleMediumErrorContainerMedium,
                  ),
                ),
                Spacer(),
               CustomImageView(
                  imagePath: ImageConstant.imgContrastPrimarycontainer,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
                
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}
