import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import 'package:sagr/features/auth/presentation/controllers/login_controller.dart';
import 'package:sagr/view/forgot_password_screen/forgot_password_screen.dart';
import 'package:sagr/view/widgets/Forms/custom_password_form_field.dart';
import 'package:sagr/view/widgets/app_locale_switcher.dart';
import '../../../../widgets/intl_phone.dart';

class LoginScreen extends StatelessWidget {
  final LoginController _controller;

  LoginScreen(this._controller, {Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppLocaleSwitcher(),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Image.asset('assets/images/sagr-logo.png',
                          width: 100),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Welcome Back".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Sign in to continue".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 22),

                    _label("Phone Number".tr),
                    const SizedBox(height: 6),
                    IntlPhoneNumberInput(
                      initialCountryCode: 'SA',
                      textDirection: TextDirection.ltr,
                      onValidated: (phoneNumber) =>
                          _controller.phone = phoneNumber.phoneNumber,
                    ),
                    const SizedBox(height: 16),

                    _label("password".tr),
                    const SizedBox(height: 6),
                    Obx(() => CustomPasswordFormField(
                          labelText: "password".tr,
                          hintText: "enter_password".tr,
                          obscureText: _controller.obscureText.value,
                          onSave: (value) => _controller.password = value!,
                          onChangeTextSecure: _controller.changeObscureText,
                          onValidate: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required".tr;
                            } else if (value.length < 6) {
                              return "password_short".tr;
                            }
                            return null;
                          },
                        )),

                    const SizedBox(height: 10),
                    _rememberForgotRow(context),
                    const SizedBox(height: 22),

                    Obx(() => SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _controller.isLoading.value
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      _controller.login();
                                    }
                                  },
                            child: _controller.isLoading.value
                                ? AppLoader.inline(color: Colors.white)
                                : Text(
                                    "Log in".tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        )),

                    const SizedBox(height: 20),
                    _createAccountRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textBody,
        ),
      ),
    );
  }

  Widget _rememberForgotRow(BuildContext context) {
    return Row(
      children: [
        Obx(() => InkWell(
              onTap: _controller.acceptAgree,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _controller.agree
                          ? AppTheme.brand
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _controller.agree
                            ? AppTheme.brand
                            : AppTheme.textHint,
                        width: 1.4,
                      ),
                    ),
                    child: _controller.agree
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Remember Me".tr,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textBody),
                  ),
                ],
              ),
            )),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          ),
          child: Text(
            "Forget password ?".tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.brand,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ".tr,
          style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
        ),
        GestureDetector(
          onTap: () => Get.toNamed('/create_account'),
          child: Text(
            "Create Account".tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.brand,
            ),
          ),
        ),
      ],
    );
  }
}
