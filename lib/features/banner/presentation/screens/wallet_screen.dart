import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/cards/presentation/controllers/cards_controller.dart';
import 'package:sagr/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/appbar/basic_app_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';

class WalletScreen extends StatelessWidget {
  final WalletController _controller;
  WalletScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(66),
            child: BasicAppBar(title: "Wallet")),
        // appBar: AppBar(
        //   title: Text("Wallet"),
        // ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWalletFrame(context),
                    SizedBox(height: 12.v),
                    _buildRechargeByFrame(context),
                  ],
                ),
              )),
              SizedBox(height: 24.v),
              Obx(() => !_controller.enableRecharge
                  ? Container()
                  : _controller.isLoadingPay
                      ? SizedBox(
                          width: 186.h,
                          child: Stack(
                            children: <Widget>[
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(8.h)),
                              //   height: 50.h,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(12.h),
                              //     child: GradientProgressIndicator(
                              //       gradient: LinearGradient(
                              //         // begin: Alignment(0.0, 1),
                              //         end: Alignment(1.0, 1),
                              //         colors: [
                              //           theme.colorScheme.primary,
                              //           appTheme.orange400,
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Charging...",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: WHITE_COLOR),
                                ),
                                alignment: Alignment.bottomCenter,
                              ),
                            ],
                          ),
                        )
                      : CustomElevatedButton(
                          onPressed: () => _controller.confirmCharge(context),
                          width: 186.h,
                          text: "Confirm",
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        )),
              SizedBox(height: 5.v),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildWalletFrame(BuildContext context) {
    return Container(
      width: 398.h,
      padding: EdgeInsets.symmetric(
        horizontal: 17.h,
        vertical: 24.v,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          //  begin: Alignment(-0.11, -0.23),
          end: Alignment(1.09, 1.21),
          colors: [
            theme.colorScheme.primary,
            appTheme.orange400,
          ],
        ),
        borderRadius: BorderRadiusStyle.roundedBorder16,
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgFrame1261153940,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 9.h,
                top: 5.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Balance",
                    style: CustomTextStyles.bodyMediumNunitoSansOnPrimary,
                  ),
                  SizedBox(height: 1.v),
                  Obx(() => _controller.isLoadingList
                      ? Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 90,
                            child: LinearProgressIndicator(
                              minHeight: 10,
                            ),
                          ),
                        )
                      : Text(
                          "${_controller.wallet.balance!} ${_controller.wallet.currency!}",
                          style:
                              CustomTextStyles.headlineSmallNunitoSansOnPrimary,
                        )),
                ],
              ),
            ),
          ),
          Obx(() => CustomElevatedButton(
                onPressed: () => _controller.onRecharage(),
                height: 42.v,
                width: 118.h,
                text: !_controller.enableRecharge ? "Recharge".tr : "Cancel".tr,
                buttonStyle: CustomButtonStyles.fillOnPrimaryTL12,
                buttonTextStyle: CustomTextStyles.titleMediumPink60001SemiBold,
              ))
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRechargeByFrame(BuildContext context) {
    return Obx(() => !_controller.enableRecharge
        ? Container()
        : Container(
            padding: EdgeInsets.all(12.h),
            decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: GetBuilder<CardsController>(
                init: CardsController(Get.find()),
                builder: (CardsController _cardController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Obx(() =>  EasyAppTextFormField(
                        hintText: "",
                        labelText: "",
                        initialValue: _controller.amount.toString(),
                        onChanged: (value) => _controller.setAmount(value),
                      )),
                      SizedBox(height: 10),
                      Text(
                        "Rechage by :".tr,
                        style:
                            CustomTextStyles.titleMediumBluegray90001SemiBold_1,
                      ),
                      SizedBox(height: 6.v),
                      SizedBox(
                        child: _cardController.isLoadingList
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: _cardController.cards.map((card) {
                                  return Obx(() => Container(
                                        height: 30.h,
                                        child: GestureDetector(
                                          onTap: () =>
                                              _controller.setPaymentId(card.id),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                child: SvgPicture.asset(
                                                  ImageConstant
                                                      .imgSettingsGray900,

                                                  fit: BoxFit.contain,
                                                  // colorFilter:
                                                  //     ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn),
                                                ),
                                              ),
                                              SizedBox(width: 40),
                                              Container(
                                                height: 20.adaptSize,
                                                width: 20.adaptSize,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: _controller
                                                                    .paymentId ==
                                                                card.id
                                                            ? ZAHRA_RED
                                                            : GREY_COLOR
                                                                .withOpacity(
                                                                    0.2)),
                                                    color: GREY_COLOR
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child:
                                                    _controller.paymentId ==
                                                            card.id
                                                        ? Container(
                                                            width: 10,
                                                            height: 10,
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .all(4),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        ZAHRA_RED,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12))),
                                                          )
                                                        : SizedBox.shrink(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              ),
                      )
                    ],
                  );
                }),
          ));
  }
}
