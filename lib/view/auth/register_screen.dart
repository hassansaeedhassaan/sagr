
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/view_model/auth/register_controller.dart';
import '../../data/colors.dart';
import '../widgets/Forms/custom_button.dart';
import '../widgets/Forms/custom_link_button.dart';
import '../widgets/Forms/custom_password_form_field.dart';
import '../widgets/Forms/custom_text_form_field.dart';
import '../widgets/Forms/gender_row.dart';
import '../widgets/custom_text.dart';

class RegisterScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final RegisterController _controller;

  RegisterScreen(this._controller);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WHITE_COLOR,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(40, 40, 40, 0),
                          child: Image.asset('assets/images/logo__blue.png'),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                        //   child: CustomText(
                        //       text: "register".tr,
                        //       style: TextStyle(fontSize: 28.0)),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          text: "enter_your_data".tr,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // CustomPhoneFormField(
                  //     onSave: (value) => _controller.phone = value),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    initialValue: "",
                    labelText: "name".tr,
                    hintText: "enter_name".tr,
                    onSave: (value) => _controller.name = value!,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    initialValue: "",
                    labelText: "email".tr,
                    hintText: "enter_email".tr,
                    onSave: (value) => _controller.email = value!,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => CustomPasswordFormField(
                        labelText: "password".tr,
                        hintText: "enter_password".tr,
                        obscureText: _controller.obscureText.value,
                        onSave: (value) => _controller.password = value!,
                        onChangeTextSecure: _controller.changeObscureText,
                        onValidate: (value) {
                          if (value?.length == 0) {
                            return "field_required";
                          } else{
                            return null;
                          }
                        },
                      )),
                  const SizedBox(height: 20),
                  Obx(() => CustomPasswordFormField(
                        labelText: "confirm_password".tr,
                        hintText: "enter_password".tr,
                        obscureText: _controller.obscureText.value,
                        onSave: (value) =>
                            _controller.confirmationPassword = value!,
                        onChangeTextSecure: _controller.changeObscureText,
                        onValidate: (value) {
                          if (value?.length == 0) {
                            return "field_required";
                         
                          } else {
                            return null;
                          }
                        },
                      )),
                  const SizedBox(height: 20.0),
                  Obx(
                    () => GenderRow(
                      genderValue: _controller.gender.value,
                      // onChangeGender: _controller.changeGender,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  Obx(() => Visibility(
                      visible: !_controller.isLoading.value,
                      child: CustomButton(
                        text: "register".tr,
                        onPress: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            _controller.register(apiToken: "");
                          }
                        },
                      ))),
                  Obx(() => Visibility(
                      visible: _controller.isLoading.value,
                      child: const CircularProgressIndicator())),
                  CustomLinkButton(
                    text: "dnot_have_an_account".tr,
                    onPress: () {},
                  ),
                  // SizedBox(height: 20.0),
                  // AppLocaleSwitcher()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
