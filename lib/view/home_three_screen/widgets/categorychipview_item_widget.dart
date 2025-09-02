import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class CategorychipviewItemWidget extends StatelessWidget {
  const CategorychipviewItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.only(
        left: 8.h,
        top: 7.v,
        bottom: 7.v,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        "Caregory",
        style: TextStyle(
          color: appTheme.blueGray90001,
          fontSize: 14.fSize,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
      ),
      deleteIcon: CustomImageView(
        imagePath: ImageConstant.imgArrowdownGray60001,
        height: 16.adaptSize,
        width: 16.adaptSize,
        margin: EdgeInsets.only(left: 4.h, right: 4),
      ),
      onDeleted: () {},
      selected: false,
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      selectedColor: appTheme.orange400.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0, color: GREY_COLOR.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(
          5.h,
        ),
      ),
      onSelected: (value) {},
    );
  }
}
