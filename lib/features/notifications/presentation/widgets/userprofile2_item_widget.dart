import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Userprofile2ItemWidget extends StatelessWidget {

  final NotificationModel notification;
  const Userprofile2ItemWidget(this.notification,{Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.all(0),
      color: notification.is_read == true ? Colors.transparent :  theme.colorScheme.onPrimary.withOpacity(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Container(
        height: 92.v,
        width: 398.h,
        padding: EdgeInsets.symmetric(
          horizontal: 8.h,
          vertical: 11.v,
        ),
        decoration: notification.is_read == true  ? BoxDecoration() :AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgRectangle1248x48,
              height: 48.adaptSize,
              width: 48.adaptSize,
              radius: BorderRadius.circular(
                24.h,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 0.h),
                    child: Text(
                      "${notification.content} ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyLargeErrorContainer,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${notification.created_at} ${notification.is_read}",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
