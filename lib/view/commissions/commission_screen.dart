import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';

class CommissionScreen extends StatelessWidget {
  CommissionScreen({Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper (
      body: Scaffold(
        appBar: AppBar(
          title: Text("My Commissions"),
        ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              _buildPayAllCommissions(context),
              SizedBox(height: 12.v),
              _buildPay(context),
              SizedBox(height: 8.v),
              _buildPay1(context),
              SizedBox(height: 8.v),
              _buildPayed(context),
              SizedBox(height: 8.v),
              _buildPayed1(context),
              SizedBox(height: 5.v),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
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
        text: "My Commissions",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildPayAllCommissions(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                contentPadding: EdgeInsets.zero,
                                insetPadding: const EdgeInsets.all(15),
                                content: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          right: 10,
                                          top: -15,
                                          child: GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: WHITE_COLOR,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: SizedBox(
                                                width: 22,
                                                child: CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgVuesaxLinearUserRemove,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 80,
                                              child: Image.asset(
                                                  "assets/images/zahra-logo.png"),
                                            ),
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Delete Account",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Are you sure you want to delete your account? If you delete your account, you may not be able to sign in again.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 42.h,
                                                            child:
                                                                CustomElevatedButton(
                                                              text:
                                                                  "Yes, i'm sure".tr
                                                                      ,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          6.h),
                                                              buttonStyle:
                                                                  CustomButtonStyles
                                                                      .none,
                                                              decoration:
                                                                  CustomButtonStyles
                                                                      .gradientPrimaryToOrangeDecoration,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              CustomOutlinedButton(
                                                            buttonStyle:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              side: BorderSide(
                                                                  width: 1.0,
                                                                  color: Color(
                                                                      0XFFD20653)),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            height: 42.v,
                                                            text: "Cancle",
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 6.h),
                                                            buttonTextStyle:
                                                                CustomTextStyles
                                                                    .titleMediumPink60001_1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));

                      
               
                    
      },
      text: "Pay all commissions",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
    );
  }

  /// Section Widget
  Widget _buildPayButton(BuildContext context) {
    return CustomOutlinedButton(
       buttonStyle: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        side: BorderSide(width: 1.0, color: Color(0XFFD20653)),
      ),
      width: 86.h,
      text: "Pay",
    );
  }

  /// Section Widget
  Widget _buildPay(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.v),
            child: _buildFrame(
              context,
              carName: "Mercedes-Benz ",
              price: "Price",
              counterValue: "1200 SR",
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPayButton(context),
              SizedBox(height: 11.v),
              Text(
                "Commission",
                style: CustomTextStyles.labelLargeGray60001,
              ),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: Text(
                  "100 SR",
                  style: CustomTextStyles.titleMediumOrange400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  /// Section Widget
  Widget _buildPay1(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.v),
            child: _buildFrame(
              context,
              carName: "Mercedes-Benz ",
              price: "Price",
              counterValue: "1200 SR",
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPayButton(context),
              SizedBox(height: 11.v),
              Text(
                "Commission",
                style: CustomTextStyles.labelLargeGray60001,
              ),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: Text(
                  "100 SR",
                  style: CustomTextStyles.titleMediumOrange400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPayedButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0XFF0EC784).withOpacity(0.1)),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCheckmarkTealA70001,
            height: 22.adaptSize,
            width: 22.adaptSize,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
            child: Text(
              "Payed",
              style: TextStyle(color: Color(0XFF0EC784), fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPayed(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.v),
            child: _buildFrame(
              context,
              carName: "Mercedes-Benz ",
              price: "Price",
              counterValue: "1200 SR",
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPayedButton(context),
              SizedBox(height: 11.v),
              Text(
                "Commission",
                style: CustomTextStyles.labelLargeGray60001,
              ),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: Text(
                  "100 SR",
                  style: CustomTextStyles.titleMediumOrange400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPayedButton1(BuildContext context) {
    return CustomElevatedButton(
      height: 36.v,
      width: 130.h,
      text: "Payed",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkTealA70001,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillTealATL8,
      buttonTextStyle: CustomTextStyles.titleMediumTealA70001,
    );
  }

  /// Section Widget
  Widget _buildPayed1(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.v),
            child: _buildFrame(
              context,
              carName: "Mercedes-Benz ",
              price: "Price",
              counterValue: "1200 SR",
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPayedButton(context),
              SizedBox(height: 0.v),
              Text(
                "Commission",
                style: CustomTextStyles.labelLargeGray60001,
              ),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: Text(
                  "100 SR",
                  style: CustomTextStyles.titleMediumOrange400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  /// Common widget
  Widget _buildFrame(
    BuildContext context, {
    required String carName,
    required String price,
    required String counterValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          carName,
          style: CustomTextStyles.titleMediumBluegray90001SemiBold.copyWith(
            color: appTheme.blueGray90001,
          ),
        ),
        SizedBox(height: 23.v),
        Text(
          price,
          style: CustomTextStyles.labelLargeGray60001.copyWith(
            color: appTheme.gray60001,
          ),
        ),
        Text(
          counterValue,
          style: CustomTextStyles.titleMediumBluegray90001SemiBold_1.copyWith(
            color: appTheme.blueGray90001,
          ),
        ),
      ],
    );
  }



}
