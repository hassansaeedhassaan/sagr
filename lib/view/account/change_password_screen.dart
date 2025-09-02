import 'package:flutter/material.dart';
import 'package:sagr/app/view_model/auth/change_password_controller.dart';
import 'package:sagr/view/auth/widgets/Forms/label_text_form_field.dart';
import 'package:sagr/view/widgets/common_app_bar.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import '../widgets/Forms/custom_button.dart';

class ChangePassworsScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final ChangePasswordController _controller;

  // LoginController _controller = Get.put(LoginController(Get.find()));

  ChangePassworsScreen(this._controller, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: CommonAppBar(title: "Change Password".tr),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                color: WHITE_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   "Change Password".tr,
                      //   style: TextStyle(
                      //       fontSize: 20,
                      //       color: Color(0xff202020),
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // Text(
                      //   "change_password_caption".tr,
                      //   style:
                      //       TextStyle(fontSize: 14, color: Color(0xffBCBCBC)),
                      // )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelTextFormField(text: "كلمة المرور القديمة"),
                      SizedBox(height: 5),
                      Obx(() => TextFormField(
                            style: TextStyle(fontSize: 18),
                            textAlignVertical: TextAlignVertical.bottom,
                            obscureText: _controller.obscureText.value,
                            obscuringCharacter: '●',
                            keyboardType: TextInputType.text,
                            cursorColor: BLACK_COLOR,
                            onSaved: (value) =>
                                _controller.old_password = value!,
                            validator: (value) {
                              if (value?.length == 0) {
                                return "field_required".tr;
                              } else if (value!.length < 8) {
                                return "password_short";
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                enabled: true,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () => _controller.changeObscureText(),
                                  child: Icon(
                                    !_controller.obscureText.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: GREY_COLOR,
                                    size: 20,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 15,
                                    right: 10.0,
                                    bottom: 10,
                                    left: 20.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 154, 147)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xffeeeeee), width: 1.0),
                                ),
                                errorStyle: TextStyle(
                                    overflow: TextOverflow.fade,
                                    color: Color.fromARGB(255, 204, 11, 11),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 0.8),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      width: 1.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xffeeeeee),
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500),
                                hintText: "●●●●●●●●●●●",
                                fillColor: Colors.white70),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelTextFormField(text: "كلمة المرور"),
                      SizedBox(height: 5),
                      Obx(() => TextFormField(
                            style: TextStyle(fontSize: 18),
                            textAlignVertical: TextAlignVertical.bottom,
                            obscureText: _controller.obscureTextNewPssword.value,
                            obscuringCharacter: '●',
                            keyboardType: TextInputType.text,
                            cursorColor: BLACK_COLOR,
                            onSaved: (value) =>
                                _controller.new_password = value!,
                            validator: (value) {
                              if (value?.length == 0) {
                                return "field_required".tr;
                              } else if (value!.length < 8) {
                                return "password_short";
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                enabled: true,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () => _controller.changeObscureTextNewPassword(),
                                  child: Icon(
                                    !_controller.obscureTextNewPssword.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: GREY_COLOR,
                                    size: 20,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 15,
                                    right: 10.0,
                                    bottom: 10,
                                    left: 20.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 154, 147)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xffeeeeee), width: 1.0),
                                ),
                                errorStyle: TextStyle(
                                    overflow: TextOverflow.fade,
                                    color: Color.fromARGB(255, 204, 11, 11),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 0.8),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      width: 1.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xffeeeeee),
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500),
                                hintText: "●●●●●●●●●●●",
                                fillColor: Colors.white70),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelTextFormField(text: "تأكيد كلمة المرور"),
                      SizedBox(height: 5),
                      Obx(() => TextFormField(
                            style: TextStyle(fontSize: 18),
                            textAlignVertical: TextAlignVertical.bottom,
                            obscureText: _controller.obscureTextConfirmPssword.value,
                            obscuringCharacter: '●',
                            keyboardType: TextInputType.text,
                            cursorColor: BLACK_COLOR,
                            onSaved: (value) =>
                                _controller.confirm_new_password = value!,
                            validator: (value) {
                              if (value?.length == 0) {
                                return "field_required".tr;
                              } else if (value!.length < 8) {
                                return "password_short";
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                enabled: true,
                                isDense: true,
                                suffixIcon: GestureDetector(
                                  onTap: () => _controller.changeObscureTextConfirmPassword(),
                                  child: Icon(
                                    !_controller.obscureTextConfirmPssword.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: GREY_COLOR,
                                    size: 20,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 15,
                                    right: 10.0,
                                    bottom: 10,
                                    left: 20.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 154, 147)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xffeeeeee), width: 1.0),
                                ),
                                errorStyle: TextStyle(
                                    overflow: TextOverflow.fade,
                                    color: Color.fromARGB(255, 204, 11, 11),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 0.8),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      width: 1.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xffeeeeee),
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500),
                                hintText: "●●●●●●●●●●●",
                                fillColor: Colors.white70),
                          ))
                    ],
                  ),
                ),
                // CustomPhoneFormField(
                //     onSave: (value) => _controller.phone = value),
                // SizedBox(height: 25),
                // Obx(() => CustomPasswordFormField(
                //       labelText: "password".tr,
                //       hintText: "enter_password".tr,
                //       obscureText: _controller.obscureText.value,
                //       onSave: (value) => _controller.password = value,
                //       onChangeTextSecure: ()=>_controller.changeObscureText,
                //       onValidate: (value) {
                //         if (value.length == 0) {
                //           return "field_required";
                //         } else if (value.length < 6) {
                //           return "password_short";
                //         } else {
                //           return null;
                //         }
                //       },
                //     )),
                const SizedBox(
                  height: 40.0,
                ),
                // Container(
                //     padding: EdgeInsets.only(top: 5.0, bottom: 50.0),
                //     // color: Colors.red,
                //     alignment: Alignment.topRight,
                //     child: InkWell(
                //       onTap: () => Get.toNamed('/forgot/password'),
                //       child: Text("forgot_password".tr,
                //           style: TextStyle(
                //               fontSize: 14.0,
                //               color: Colors.grey,
                //               fontFamily: FONT_FAMILY)),
                //     )),
                Obx(() => Visibility(
                    visible: !_controller.isLoading.value,
                    child: CustomButton(
                      text: "Confirm".tr,
                      onPress: () {
                        // Get.to(() => TotalPage());
                         _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _controller.changePassword(context);
                        }
                      },
                    ))),
                Obx(() => Visibility(
                    visible: _controller.isLoading.value,
                    child: const CircularProgressIndicator())),

                // const SizedBox(height: 25.0),
                //    const AppLocaleSwitcher()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
