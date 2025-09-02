import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class UserprofilelistItemWidget extends StatelessWidget {
  const UserprofilelistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195.h,
      child: Column(
        children: [
          SizedBox(
            height: 135.v,
            width: 195.h,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRectangle12,
                  height: 135.v,
                  width: 195.h,
                  radius: BorderRadius.vertical(
                    top: Radius.circular(12.h),
                  ),
                  alignment: Alignment.center,
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
                            imagePath: ImageConstant.imgFavorite,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.customBorderBL12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7.v),
                Row(
                  children: [
                    Text(
                      "#cars",
                      style: CustomTextStyles.bodySmallOrange400,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 93.h),
                      child: Text(
                        " in 22/1/2023",
                        style: CustomTextStyles.bodySmall10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.v),
                Text(
                  "Mercedes-Benz ",
                  style: CustomTextStyles.titleSmallSemiBold,
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
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        "Dakahlia, Mansoura",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.v),
                Text(
                  "1000 EGP",
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
