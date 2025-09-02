import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import '../../core/utils/image_constant.dart';
import '../../data/colors.dart';
import '../app_bar/appbar_leading_image.dart';

class BasicAppBar extends StatelessWidget {
  final String title;
  BasicAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      scrolledUnderElevation: 0,
      backgroundColor: WHITE_COLOR,
      leadingWidth: 39.h,
      leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(
            left: 16.h,
            top: 16.v,
            bottom: 16.v,
          )),
    );
  }
}
