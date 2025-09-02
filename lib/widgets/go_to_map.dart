import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/widgets/custom_elevated_button.dart';
import 'package:sagr/widgets/custom_icon_button.dart';
import 'package:sagr/widgets/custom_outlined_button.dart';

import '../core/utils/image_constant.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../theme/custom_button_style.dart';
import '../theme/custom_text_style.dart';
import '../view/share_your_adds_one_screen/maps_screen.dart';
import '../view/share_your_adds_three_screen/share_your_adds_three_screen.dart';
import 'custom_image_view.dart';

GetBuilder<AuthController> GoToMap(BuildContext context, List<Product> products) {



  return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (AuthController _authController) {
        return GestureDetector(

            onTap: () {

              if (_authController.isLoggedIn) {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => MapsScreen(products)));
              }else{
                

                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.all(15),
                      content: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
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
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          "Login First".tr,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Are you sure you want to delete your account ? If you delete your account, you may not be able to sign in again.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 15),
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
                                                child: SizedBox(
                                                  height: 42.h,
                                                  child: CustomElevatedButton(
                                                    onPressed: () => Get.toNamed("/login"),
                                                    text: "Yes, i'm sure".tr,
                                                    margin: EdgeInsets.only(
                                                        right: 6.h),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    side: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Color(0XFFD20653)),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  height: 42.v,
                                                  text: "Cancle",
                                                  margin: EdgeInsets.only(
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
              }

            },
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: CustomIconButton(
                height: 35.v,
                width: 40.h,
                padding: EdgeInsets.all(5.h),
                decoration: IconButtonStyleHelper.fillOnPrimary,
                child: CustomImageView(
                  imagePath: ImageConstant.imgUser,
                ),
              ),
            ));
      });

}

/// Section Widget
Widget buildLogInByAppleButton(BuildContext context) {
  return CustomElevatedButton(
    onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => ShareYourAddsThreeScreen())),
    height: 48.v,
    text: "Log in by Apple".tr,
    leftIcon: Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 0, 20.h, 0),
      child: CustomImageView(
        imagePath: ImageConstant.imgApplelogo,
        height: 24.adaptSize,
        width: 24.adaptSize,
      ),
    ),
    buttonStyle: CustomButtonStyles.fillGray,
    buttonTextStyle: CustomTextStyles.titleSmallBold,
  );

}