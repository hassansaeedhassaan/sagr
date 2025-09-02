import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/message_three_screen/message_three_screen.dart';

import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Userprofile7ItemWidget extends StatelessWidget {
  const Userprofile7ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageThreeScreen())),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRectangle1248x48,
                  height: 48.adaptSize,
                  width: 48.adaptSize,
                  radius: BorderRadius.circular(
                    24.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jane Doe",
                        style: CustomTextStyles.titleMediumBluegray90001SemiBold,
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        "Hi, i want make enquiries about ...",
                        style: CustomTextStyles.bodyMediumGray60001,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.v),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 20.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                      ),
                      child: Text(
                        "10",
                        style: CustomTextStyles.labelLargeOnPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.v),
                  Text(
                    "12:55 am",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
