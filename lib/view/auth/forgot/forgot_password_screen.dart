
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/view_model/auth/forgot/forgot_password_controller.dart';
import '../../widgets/Forms/custom_button.dart';
import '../../widgets/Forms/custom_link_button.dart';
import '../../widgets/Forms/custom_phone_form_field.dart';
import '../../widgets/app_locale_switcher.dart';
import '../../widgets/custom_text.dart';

class ForgotPasswordScreenOLD extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final ForgotPasswordController _controller;

  ForgotPasswordScreenOLD(this._controller);

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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "back to login",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: CustomText(
                              text: "forgot_password_title".tr,
                              style: TextStyle(fontSize: 28.0)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: "enter_phone".tr,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomPhoneFormField(
                      onSave: (value) => _controller.phone = value!),
                  SizedBox(height: 40),
                  Obx(() => Visibility(
                      visible: !_controller.isLoading.value,
                      child: CustomButton(
                        text: "login".tr,
                        onPress: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            _controller.forgot();
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
                  SizedBox(height: 50.0),
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
