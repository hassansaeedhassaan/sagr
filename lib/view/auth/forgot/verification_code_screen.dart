import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import '../../../app/view_model/auth/forgot/forgot_password_controller.dart';
import '../../widgets/Forms/custom_button.dart';
import '../../widgets/Forms/custom_link_button.dart';
import '../../widgets/app_locale_switcher.dart';
import '../../widgets/custom_text.dart';

class VerificationScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final ForgotPasswordController _controller;

  VerificationScreen(this._controller);

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
                              text: "verification_code".tr,
                              style: TextStyle(fontSize: 28.0)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: "enter_verification_code".tr,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // CustomPhoneFormField(
                  //     onSave: (value) => _controller.phone = value),
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: VerificationCode(
                        textStyle: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900]),
                        keyboardType: TextInputType.number,
                        // in case underline color is null it will use primaryColor: Colors.red from Theme
                        underlineColor: Colors.amber,
                        length: 4,
                        autofocus: true,
                        itemSize: 84,
                        // clearAll is NOT required, you can delete it
                        // takes any widget, so you can implement your design
                        clearAll: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'clear all',
                            style: TextStyle(
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                                color: Colors.blue[700]),
                          ),
                        ),
                        onCompleted: (String value) {
                          // setState(() {
                          _controller.code = value;

                          print("completed");
                          if (_controller.code.isNotEmpty) {
                            _controller.checkVerificationCode();
                          }
                          // });
                        },
                        onEditing: (bool value) {
                          // setState(() {
                          //   _onEditing = value;
                          // });
                          // if (!_onEditing) FocusScope.of(context).unfocus();
                        },
                      )),
                  SizedBox(height: 40),
                  Obx(() => Visibility(
                      visible: !_controller.isLoading.value,
                      child: CustomButton(
                        text: "login".tr,
                        onPress: () {
                          if (_controller.code.isNotEmpty) {
                            _controller.checkVerificationCode();
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
