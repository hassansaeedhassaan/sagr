import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/image_constant.dart';

import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/login_controller.dart';
import 'package:sagr/theme/custom_button_style.dart';
import 'package:sagr/theme/custom_text_style.dart';
import 'package:sagr/view/forgot_password_screen/forgot_password_screen.dart';
import 'package:sagr/view/widgets/Forms/custom_email_form_field.dart';
import 'package:sagr/view/widgets/Forms/custom_password_form_field.dart';
import 'package:sagr/view/widgets/app_locale_switcher.dart';
import 'package:sagr/widgets/custom_elevated_button.dart';
import 'package:sagr/widgets/custom_image_view.dart';
import 'package:sagr/widgets/go_to_map.dart';

import '../../../../theme/app_decoration.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/appbar/unauthenticated_appbar.dart';
import 'registration_success_page.dart';

class LoginScreen extends StatelessWidget {
  // final _formKey = GlobalKey<FormState>();
  final LoginController _controller;

  // LoginController _controller = Get.put(LoginController(Get.find()));

  LoginScreen(this._controller, {Key? key}) : super(key: key);

  final TextEditingController passwordFloatingTextFieldController =
      TextEditingController();

  final TextEditingController passwordEditTextController =
      TextEditingController();

  final bool rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xfff6f6f6),
backgroundColor: WHITE_COLOR,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: 398.h,
              margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 5.v),
              padding: EdgeInsets.symmetric(
                horizontal: 12.h,
                vertical: 10.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              child: Column(
                children: [
                  Image.asset("assets/images/sagr-logo.png", width: 200,),
                  // AppLocaleSwitcher(),
                  // Align(
                  //   alignment: AlignmentDirectional.center,
                  //   child: Text(
                  //     "Welcome Back".tr,
                  //     style: theme.textTheme.titleLarge,
                  //   ),
                  // ),
                  SizedBox(height: 50.v),
                  // Align(
                  //   alignment: AlignmentDirectional.center,
                  //   child: Container(
                  //     // width: 304.h,
                  //     // margin: EdgeInsets.only(right: 69.h),
                  //     child: Text(
                  //       "Enter your email and password to sign in to your account"
                  //           .tr,
                  //       maxLines: 2,
                  //       textAlign: TextAlign.center,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: CustomTextStyles.bodyMediumGray50001,
                  //     ),
                  //   ),
                  // ),
                  // AppLocaleSwitcher(),
                  SizedBox(height: 15.v),
                  CustomEmailFormField(
                    onSave: (value) => _controller.phone = value!,
                    initialValue: _controller.phone,
                    labelText: "Email / Phone Number".tr,
                    hintText: "Enter Email or phone".tr,
                    onValidate: (value) {
                      if (value?.length == 0) {
                        return "Field Required".tr;
                      } else {
                        return null;
                      }
                    },
                  ),
        
                  // _buildEmailOrPhoneTextField(context),
                  SizedBox(height: 15.v),
        
                  CustomPasswordFormField(
                    
                    labelText: "Password".tr,
                    hintText: "Password".tr,
                    onSave: (value) => _controller.password = value!,
                    onValidate: (value) {
                      if (value?.length == 0) {
                        return "Field Required".tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  // _buildPasswordEditText(context),
                  SizedBox(height: 15.v),
                  _buildFrameRow(context),
                  SizedBox(height: 40.v),
        
                  Obx(() => _controller.isLoading == true
                      ? CircularProgressIndicator()
                      : CustomElevatedButton(
                          onPressed: _controller.isLoading == true
                              ? null
                              : () {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    _controller.login();
                                  }
                                },
                          text: _controller.isLoading == true
                              ? "Login..."
                              : "Log in".tr,
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        )),
                  SizedBox(height: 23.v),
                 
      

                  GestureDetector(
                    onTap: () => Get.toNamed('/create_account'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Don’t have an account? ".tr,
                            style: CustomTextStyles.titleMedium16!.copyWith(
                              fontSize: 14.fSize,
                              color: Color.fromARGB(255, 131, 131, 131),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Create Account".tr,
                            style: CustomTextStyles.titleMedium14.copyWith(color: BLACK_COLOR, ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => InkWell(
              onTap: () => _controller.acceptAgree(),
              child: Container(
                height: 21.adaptSize,
                width: 21.adaptSize,
                margin: EdgeInsets.only(bottom: 0.v, top: 2),
                child: _controller.agree != true
                    ? SizedBox.shrink()
                    : Center(
                        child: Icon(
                        Icons.check,
                        size: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                        weight: 10,
                        opticalSize: 20,
                      )),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.4,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    borderRadius: BorderRadius.circular(6)),
              ),
            )),

       

        Expanded(
            child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.h, 0, 0, 0),
          child: Text("Remember Me".tr),
        )),

        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
          child: Padding(
            padding: EdgeInsets.only(top: 2.v),
            child: Text(
              "Forget password ?".tr,
              style: CustomTextStyles.titleSmallPrimary_1.copyWith(color: BLACK_COLOR),
            ),
          ),
        ),
      ],
    );
  }


  /// Section Widget
  Widget _buildFrameRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 11.v,
              bottom: 9.v,
            ),
            child: SizedBox(
              width: 165.h,
              child: Divider(
                color: appTheme.gray300,
              ),
            ),
          ),
        ),
        Text(
          "OR".tr,
          style: CustomTextStyles.titleMediumBluegray9000116,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 11.v,
              bottom: 9.v,
            ),
            child: SizedBox(
              width: 165.h,
              child: Divider(
                color: appTheme.gray300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildLogInByGmailButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.v,
      text: "Log in by gmail".tr,
      leftIcon: Container(
        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 20.h, 0),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogle,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: Color(0xfffff4e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
      buttonTextStyle: CustomTextStyles.titleSmallBold,
    );
  }
}
