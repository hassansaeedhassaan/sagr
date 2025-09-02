import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Userprofile6ItemWidget extends StatelessWidget {
  const Userprofile6ItemWidget({Key? key})
      : super(
          key: key,
        );

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSettingsGray900,
            height: 14.v,
            width: 48.h,
            margin: EdgeInsets.only(bottom: 29.v),
          ),
          Spacer(
            flex: 31,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "universal ",
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 1.v),
              Text(
                "*7755",
                style: CustomTextStyles.bodyMediumGray60001,
              ),
            ],
          ),
          Spacer(
            flex: 39,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date Expire",
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                "05/24",
                style: CustomTextStyles.bodyMediumGray60001,
              ),
            ],
          ),
          Spacer(
            flex: 29,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgContrastPrimarycontainer,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.only(bottom: 23.v),
          ),
        ],
      ),
    );
  }
}
