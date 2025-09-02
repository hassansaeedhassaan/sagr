import 'package:get/get.dart';
import 'package:sagr/view/home_three_screen/home_three_screen.dart';
import 'package:sagr/widgets/app_bar/appbar_leading_image.dart';
import 'package:sagr/widgets/app_bar/appbar_title_image.dart';
import 'package:sagr/widgets/app_bar/custom_app_bar.dart';
import 'package:sagr/widgets/custom_elevated_button.dart';
import 'package:sagr/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/appbar/unauthenticated_appbar.dart';
import '../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(77), child: UnAuthenticatedAppBar()),
      body: SizedBox(
        width: SizeUtils.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: 398.h,
              margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 30.v),
              padding: EdgeInsets.symmetric(
                horizontal: 4.h,
                vertical: 10.v,
              ),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        "Create account",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 304.h,
                      margin: EdgeInsets.only(
                        left: 8.h,
                        right: 77.h,
                      ),
                      child: Text(
                        "Enter your email and password to sign in to your account",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.bodyMediumGray50001,
                      ),
                    ),
                  ),
                  SizedBox(height: 23.v),
                  _buildPassword(context),
                  SizedBox(height: 12.v),
                  _buildEmail(context),
                  SizedBox(height: 12.v),
                  _buildPhoneNumber(context),
                  SizedBox(height: 12.v),
                  _buildPassword1(context),
                  SizedBox(height: 12.v),
                  _buildConfirmPassword(context),
                  SizedBox(height: 12.v),
                  _buildFrame(context),
                  SizedBox(height: 23.v),
                  _buildCreateAccountButton(context),
                  SizedBox(height: 23.v),
                  _buildFrame1(context),
                  SizedBox(height: 16.v),
                  _buildLogInByGmailButton(context),
                  SizedBox(height: 12.v),
                  _buildLogInByAppleButton(context),
                  SizedBox(height: 16.v),


                   GestureDetector(
                 onTap: () => Get.toNamed('/login'),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Already have an account? ".tr,
                          style: CustomTextStyles.titleMedium16!.copyWith(
                              fontSize: 14.fSize,
                              color: Color.fromARGB(255, 110, 110, 110),
                              ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Login".tr,
                          style: CustomTextStyles.titleMedium14,
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
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 64.v,
      leadingWidth: 47.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 20.v,
          bottom: 19.v,
        ),
      ),
      centerTitle: true,
      title: AppbarTitleImage(
        imagePath: ImageConstant.imgLayer1,
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        autofocus: false,
        controller: passwordController,
        hintText: "Name",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: emailController,
        autofocus: false,
        hintText: "Email",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.emailAddress,
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: phoneNumberController,
        hintText: "Phone Number",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.phone,
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: passwordController1,
        hintText: "Password",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.visiblePassword,
        suffix: Container(
          margin: EdgeInsets.fromLTRB(30.h, 13.v, 16.h, 13.v),
          child: CustomImageView(
            imagePath: ImageConstant.imgEye,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 50.v,
        ),
        obscureText: true,
        contentPadding: EdgeInsets.only(
          left: 16.h,
          top: 15.v,
          bottom: 15.v,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: confirmPasswordController,
        hintText: "Confirm Password",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        suffix: Container(
          margin: EdgeInsets.fromLTRB(30.h, 13.v, 16.h, 13.v),
          child: CustomImageView(
            imagePath: ImageConstant.imgEyeGray50001,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 50.v,
        ),
        obscureText: true,
        contentPadding: EdgeInsets.only(
          left: 16.h,
          top: 15.v,
          bottom: 15.v,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8.h,
          right: 24.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgCheckmark,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 18.v),
            ),
            Expanded(
              child: Container(
                width: 322.h,
                margin: EdgeInsets.only(left: 12.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By ",
                        style: CustomTextStyles.titleSmallff333333,
                      ),
                      TextSpan(
                        text: "signing up, I agree with the",
                        style: CustomTextStyles.titleSmallff333333,
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      TextSpan(
                        text: "Terms ",
                        style: CustomTextStyles.titleSmallffd20653.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: "of Use",
                        style: CustomTextStyles.titleSmallffd20653.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      TextSpan(
                        text: "& ",
                        style: CustomTextStyles.titleSmallff333333,
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: CustomTextStyles.titleSmallffd20653.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCreateAccountButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeThreeScreen())),
      text: "Cteate Account",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: Row(
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
                width: 169.h,
                child: Divider(
                  color: appTheme.gray300,
                ),
              ),
            ),
          ),
          Text(
            "OR",
            style: CustomTextStyles.titleMediumBluegray9000116,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 11.v,
                bottom: 9.v,
              ),
              child: SizedBox(
                width: 169.h,
                child: Divider(
                  color: appTheme.gray300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLogInByGmailButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.v,
      text: "Log in by gmail",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.h),
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







  /// Section Widget
  Widget _buildLogInByAppleButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.v,
      text: "Log in by Apple",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.h),
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
}
