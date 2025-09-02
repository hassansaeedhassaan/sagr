import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Category1ItemWidget extends StatelessWidget {
  const Category1ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgRectangle3925476x76,
          height: 76.adaptSize,
          width: 76.adaptSize,
          radius: BorderRadius.circular(
            12.h,
          ),
        ),
        SizedBox(height: 6.v),
        Text(
          "Electronics",
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
