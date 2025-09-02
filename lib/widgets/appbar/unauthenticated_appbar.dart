
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../data/colors.dart';

class UnAuthenticatedAppBar extends StatelessWidget {
  const UnAuthenticatedAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: true,
        leadingWidth: 60.h,
      //   leading: AppbarLeadingImage(

      //   imagePath: ImageConstant.imgArrowDown,
      //   margin: EdgeInsets.only(
      //     left: 24.h,
      //     top: 20.v,
      //     bottom: 19.v,
      //   ),
      // ),
      toolbarHeight: 100, // Set this height
      title: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset("assets/images/sagr-logo.png", width: 80),
      ),
      backgroundColor: WHITE_COLOR,
      foregroundColor: BLACK_COLOR,
    );
  }
}
