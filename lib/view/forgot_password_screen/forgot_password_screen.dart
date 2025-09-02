import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/view/reset/reset_password_screen.dart';
import 'package:sagr/widgets/app_bar/appbar_leading_image.dart';
import 'package:sagr/widgets/app_bar/appbar_title_image.dart';
import 'package:sagr/widgets/app_bar/custom_app_bar.dart';
import 'package:sagr/widgets/custom_elevated_button.dart';
import 'package:sagr/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/appbar/unauthenticated_appbar.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
          preferredSize: Size.fromHeight(77), child: UnAuthenticatedAppBar()),
   
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: 398.h,
              margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 5.v),
              padding: EdgeInsets.all(12.h),
              decoration: AppDecoration.fillOnPrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 2.v),
                  Text(
                    "Forget password",
                    style: CustomTextStyles.titleLargePoppins,
                  ),
                  SizedBox(height: 1.v),
                  Container(
                    width: 322.h,
                    margin: EdgeInsets.only(right: 51.h),
                    child: Text(
                      "Enter your email so that we can send you password reset link",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyMediumGray50001.copyWith(
                        height: 1.57,
                      ),
                    ),
                  ),
                  SizedBox(height: 21.v),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "Email",
                    autofocus: false,
                    hintStyle: CustomTextStyles.bodyMediumErrorContainer,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    obscureText: true,
                  ),
                  SizedBox(height: 24.v),
                  CustomElevatedButton(
                    onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetPasswordScreen())),
                    text: "Send",
                    buttonStyle: CustomButtonStyles.none,
                    decoration:
                        CustomButtonStyles.gradientPrimaryToOrangeDecoration,
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
}
