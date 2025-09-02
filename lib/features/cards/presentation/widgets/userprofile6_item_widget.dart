import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Userprofile6ItemWidget extends StatelessWidget {
  final CardModel card;
  const Userprofile6ItemWidget({Key? key, required this.card})
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
          
          card.brand == "visa"?  CustomImageView(
            imagePath: ImageConstant.imgSettingsGray900,
            height: 14.v,
            width: 48.h,
            margin: EdgeInsets.only(bottom: 29.v),
          ): SizedBox.shrink(),
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
                "*${card.last_four_numbers}",
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
                "${card.expire_month}/${card.expire_year}",
                style: CustomTextStyles.bodyMediumGray60001,
              ),
            ],
          ),
          Spacer(
            flex: 29,
          ),

          card.is_default != true ? Container(
            alignment: Alignment.center,
            height: 20.adaptSize,
            width: 20.adaptSize,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: GREY_COLOR.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(50)
            ),
            
          ):Container(
            alignment: Alignment.center,
            height: 20.adaptSize,
            width: 20.adaptSize,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: ZAHRA_RED.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(50)
            ),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: ZAHRA_RED,
                borderRadius: BorderRadius.circular(50)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
