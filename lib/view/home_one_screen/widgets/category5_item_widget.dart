import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Category5ItemWidget extends StatelessWidget {
  const Category5ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgRectangle3925470x70,
          height: 70.adaptSize,
          width: 70.adaptSize,
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
