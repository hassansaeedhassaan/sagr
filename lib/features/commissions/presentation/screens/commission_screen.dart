import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/commissions/presentation/controllers/commissions_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_outlined_button.dart';

class CommissionScreen extends StatelessWidget {
  final CommissionsController _controller;

  CommissionScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: GetBuilder<CommissionsController>(
          init: CommissionsController(Get.find()),
          builder: (CommissionsController _commissionCntr) {
            return Scaffold(
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

                    _commissionCntr.isLoadingList ?  Center(child: CircularProgressIndicator(),) : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _commissionCntr.commissions.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
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
                                    carName:
                                        "${_controller.commissions[index].advertisement!.name}",
                                    price: "Price",
                                    counterValue:
                                        "${_commissionCntr.commissions[index].amount} ${_commissionCntr.commissions[index].currency}",
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                   _commissionCntr.commissions.elementAt(index).is_paid == '1' ? _buildPayedButton(context) :  _buildPayButton(context),
                                    SizedBox(height: 11.v),
                                    Text(
                                      "Commission",
                                      style:
                                          CustomTextStyles.labelLargeGray60001,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.h),
                                      child: Text(
                                        "${_commissionCntr.commissions.elementAt(index).commission} ${_commissionCntr.commissions.elementAt(index).currency}",
                                        style: CustomTextStyles
                                            .titleMediumOrange400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    // SizedBox(height: 8.v),
                    // _buildPay1(context),
                    // SizedBox(height: 8.v),
                    // _buildPayed(context),
                    // SizedBox(height: 8.v),
                    // _buildPayed1(context),
                    // SizedBox(height: 5.v),
                  ],
                ),
              ),
              // bottomNavigationBar: _buildBottomBar(context),
            );
          }),
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
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  contentPadding: EdgeInsets.zero,
                  insetPadding: const EdgeInsets.all(15),
                  content: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GetBuilder<CommissionsController>(
                        init: CommissionsController(Get.find()),
                        builder: (CommissionsController _commissionCntr){
                        return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: 10,
                            top: -15,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(50)),
                                child: SizedBox(
                                  width: 22,
                                  child: CustomImageView(
                                    imagePath:
                                        ImageConstant.imgVuesaxLinearUserRemove,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                                // child: Image.asset(
                                //     "assets/images/zahra-logo.png"),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Pay By",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(

                                      onTap: () => _commissionCntr.setPaymentMethod('wallet'),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                              // color: PURPLE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 1, color: _controller.paymentMethod == 'wallet' ? ZAHRA_RED :  GREY_COLOR)),
                                          child: Row(
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgVuesaxTwotoneWallet,
                                                height: 20.adaptSize,
                                                width: 20.adaptSize,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: RichText(
                                                      text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Pay By Wallet".tr,
                                                      style: TextStyle(
                                                          color: BLACK_COLOR,
                                                          fontSize: 16)),
                                                  TextSpan(
                                                    text: " (6 SAR)",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ))),
                                              Container(
                                                  width: 20.h,
                                                  height: 20.h,
                                                  decoration: BoxDecoration(
                                                      // color: RED_COLOR,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: _controller.paymentMethod == 'wallet' ? ZAHRA_RED : GREY_COLOR)),
                                                  child: _controller.paymentMethod == 'wallet' ? Container(
                                                    height: 5,
                                                    margin: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: ZAHRA_RED,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50)),
                                                  ): Container())
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    
                                    GestureDetector(
                                       onTap: () => _commissionCntr.setPaymentMethod('card'),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                               margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                              // color: PURPLE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 1, color: _controller.paymentMethod == 'card' ? ZAHRA_RED :  GREY_COLOR)),
                                          child: Row(
                                            children: [
                                              CustomImageView(
                                                imagePath: ImageConstant
                                                    .imgVuesaxTwotoneCard,
                                                height: 20.adaptSize,
                                                width: 20.adaptSize,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: RichText(
                                                      text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Pay By Card".tr,
                                                      style: TextStyle(
                                                          color: BLACK_COLOR,
                                                          fontSize: 16)),
                                                
                                                ],
                                              ))),
                                              Container(
                                                  width: 20.h,
                                                  height: 20.h,
                                                  decoration: BoxDecoration(
                                                      // color: RED_COLOR,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: _controller.paymentMethod == 'card' ? ZAHRA_RED :GREY_COLOR  )),
                                                  child: _controller.paymentMethod == 'card' ? Container(
                                                    height: 5,
                                                    margin: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: ZAHRA_RED,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50)),
                                                  ): Container())
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: _controller.isLoadingPay ? Center(child: CircularProgressIndicator(),) : SizedBox(
                                              height: 48.h,
                                              child: CustomElevatedButton(
                                                onPressed: () => _controller.payAllCommissions(context),
                                                text: "Confirm".tr,
                                                margin:
                                                    EdgeInsets.only(right: 6.h),
                                                buttonStyle:
                                                    CustomButtonStyles.none,
                                                decoration: CustomButtonStyles
                                                    .gradientPrimaryToOrangeDecoration,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomOutlinedButton(
                                              buttonStyle:
                                                  OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Color(0XFFD20653)),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              height: 48.v,
                                              text: "Cancle",
                                              margin:
                                                  EdgeInsets.only(left: 6.h),
                                              buttonTextStyle: CustomTextStyles
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
                      );
                      }),
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
              "Payed".tr,
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
