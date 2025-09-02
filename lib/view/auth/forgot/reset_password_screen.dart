import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../app/view_model/auth/forgot/reset_password_controller.dart';
import '../../widgets/Forms/custom_button.dart';
import '../../widgets/Forms/custom_link_button.dart';
import '../../widgets/Forms/custom_password_form_field.dart';
import '../../widgets/app_locale_switcher.dart';
import '../../widgets/custom_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final ResetPasswordController _controller;

  ResetPasswordScreen(this._controller);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff8f8f8),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CustomText(
                              text: "reset_password".tr,
                              style:
                                  TextStyle(fontSize: 28.0, fontFamily: "TJB")),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // CustomText(
                        //   text: "login_first".tr,
                        //   style: TextStyle(color: Colors.blueGrey),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Obx(() => CustomPasswordFormField(
                        labelText: "password".tr,
                        hintText: "enter_password".tr,
                        onSave: (value) => _controller.password = value!,
                        obscureText: _controller.obscureText.value,
                        onChangeTextSecure: _controller.changeObscureText,
                        onValidate: (value) {
                          if (value?.length == 0) {
                            return "field_required";
                          
                          } else {
                            return null;
                          }
                        },
                      )),
                  SizedBox(height: 25),
                  Obx(() => CustomPasswordFormField(
                        labelText: "confirm_password".tr,
                        hintText: "enter_confirm_passowrd".tr,
                        obscureText: _controller.obscureText.value,
                        onChangeTextSecure: _controller.changeObscureText,
                        onSave: (value) =>
                            _controller.confirmationPassword = value!,
                        onValidate: (value) {
                          if (value?.length == 0) {
                            return "field_required";
                          
                          } else if (value != _controller.password) {
                            return "not_matched";
                          } else {
                            return null;
                          }
                        },
                      )),
                  SizedBox(
                    height: 40.0,
                  ),
                  Obx(() => Visibility(
                      visible: !_controller.isLoading.value,
                      child: CustomButton(
                        text: "save_password".tr,
                        onPress: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            _controller.reset();
                          }
                        },
                      ))),
                  Obx(() => Visibility(
                      visible: _controller.isLoading.value,
                      child: CircularProgressIndicator())),
                  CustomLinkButton(
                    text: 'don\'t have account?',
                    onPress: () {},
                  ),
                  SizedBox(height: 20.0),
                  AppLocaleSwitcher()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
