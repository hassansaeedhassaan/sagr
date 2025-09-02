// import 'package:eltikia_s_application6/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../theme/app_decoration.dart';
import '../custom_image_view.dart';

// ignore: must_be_immutable
class AppbarTitleCircleimage extends StatelessWidget {
  AppbarTitleCircleimage({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadiusStyle.roundedBorder16,
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 37.adaptSize,
          width: 37.adaptSize,
          fit: BoxFit.contain,
          radius: BorderRadius.circular(
            18.h!,
          ),
        ),
      ),
    );
  }
}
