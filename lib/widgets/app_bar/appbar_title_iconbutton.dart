// import 'package:eltikia_s_application6/core/app_export.dart';
// import 'package:eltikia_s_application6/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../custom_icon_button.dart';
import '../custom_image_view.dart';

// ignore: must_be_immutable
class AppbarTitleIconbutton extends StatelessWidget {
  AppbarTitleIconbutton({
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
    return GestureDetector(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 22.adaptSize,
          width: 22.adaptSize,
          decoration: IconButtonStyleHelper.fillGray,
          child: CustomImageView(
            imagePath: ImageConstant.imgSearch141BlueGray90001,
          ),
        ),
      ),
    );
  }
}
