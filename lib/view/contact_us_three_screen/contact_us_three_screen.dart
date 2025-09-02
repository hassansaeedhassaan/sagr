import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

class ContactUsThreeScreen extends StatelessWidget {
  ContactUsThreeScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    
    return  MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
           leadingWidth: 39.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
      title: AppbarSubtitle(
        text: "How to become Primum",
        margin: EdgeInsets.only(left: 16.h),
      )
        ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              _buildFrame(context),
              SizedBox(height: 12.v),
              _buildFrame1(context),
              SizedBox(height: 29.v),
              CustomElevatedButton(
                text: "Pay",
                buttonStyle: CustomButtonStyles.none,
                decoration:
                    CustomButtonStyles.gradientPrimaryToOrangeDecoration,
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }



  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Who",
                  style: CustomTextStyles.titleLargeff333333,
                ),
                TextSpan(
                  text: " we are ?",
                  style: CustomTextStyles.titleLargeff333333,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 17.v),
          SizedBox(
            width: 374.h,
            child: Text(
              "Striving to meet your daily need, our website was designed to facilitates as a seller (wholesaler or retailer) or as buyer, selling or buying new or used items and goods. With capabilities of hosting and attending wide varieties of daily and weekly auctions for different items.\n\nSpend less time. Make more money.With ease and shortcut the way of reaching your potential customers so you can sell and buy all kind of products and items.\n\nWith security and safety as our top priorities, make your transactions with confidence at any time.",
              maxLines: 14,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: theme.textTheme.bodyLarge!.copyWith(
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Container(
        height: 137.v,
        width: 398.h,
        decoration: AppDecoration.gradientSecondaryContainerToOrange.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 24.v),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "we ",
                        style: CustomTextStyles.titleLargeffd20653,
                      ),
                      TextSpan(
                        text: "are global and grow ",
                        style: CustomTextStyles.titleLargeffd20653,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            
            CustomImageView(
              imagePath: ImageConstant.imgGroup1000,
              height: 180.v,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgEllipse35,
              height: 42.v,
              width: 51.h,
              radius: BorderRadius.circular(
                16.h,
              ),
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(
                left: 13.h,
                bottom: 19.v,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 30.h,
                  bottom: 0.v,
                  left: 30.h,

                  
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
            
                  // right: 303.h,
                  bottom: 23.v,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "+900",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "Products",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
              Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
             
                  // right: 303.h,
                  bottom: 23.v,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "+150",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "Sellers",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
              Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  // right: 303.h,
                  bottom: 23.v,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "+4",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "Countries",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

                    ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
