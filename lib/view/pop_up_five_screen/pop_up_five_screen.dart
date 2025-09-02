import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import '../pop_up_five_screen/widgets/paymentoptionslist_item_widget.dart';

import 'package:flutter/material.dart';

class PopUpFiveScreen extends StatelessWidget {
  const PopUpFiveScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 319.v,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 24.v,
                    ),
                    decoration: AppDecoration.fillOnPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Pay by",
                          style: theme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 22.v),
                        _buildPaymentOptionsList(context),
                        SizedBox(height: 24.v),
                        _buildFrameRow(context),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 16.v,
                  width: 32.h,
                  margin: EdgeInsets.only(right: 16.h),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVuesaxLinearUserRemove,
                    height: 16.v,
                    width: 32.h,
                    radius: BorderRadius.circular(
                      8.h,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentOptionsList(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            height: 12.v,
          );
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return PaymentoptionslistItemWidget();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: "Confirm",
            margin: EdgeInsets.only(right: 6.h),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
          ),
        ),
        Expanded(
          child: CustomOutlinedButton(
            height: 50.v,
            text: "Cancle",
            margin: EdgeInsets.only(left: 6.h),
            buttonTextStyle: CustomTextStyles.titleMediumPink60001_1,
          ),
        ),
      ],
    );
  }
}
