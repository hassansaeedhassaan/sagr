import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/utilities/local_storage/locale_storage.dart';
import 'package:sagr/view/widgets/Forms/custom_text_form_field.dart';
import 'package:sagr/view/widgets/common_app_bar.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';

import '../../app/view_model/auth/account_controller.dart';
import '../widgets/Forms/custom_button.dart';

class AccountEditScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final AccountController _controller;

  AccountEditScreen(this._controller, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: CommonAppBar(title: "Edit Account".tr),
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
                      //   "Edit Account".tr,
                      //   style: TextStyle(
                      //       fontSize: 20,
                      //       color: Color(0xff202020),
                      //       fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        "Edit Account Information".tr,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffBCBCBC)),
                      )
                      // Padding(
                      //   padding:
                      //       EdgeInsetsDirectional.fromSTEB(40, 40, 40, 0),
                      //   child: Image.asset('assets/images/logo__blue.png'),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                      //   child: CustomText(
                      //       text: "welcome".tr,
                      //       style: const TextStyle(fontSize: 28.0)),
                      // ),
                      // const SizedBox(height: 10),
                      // CustomText(
                      //   text: "login_first".tr,
                      //   style: const TextStyle(color: Colors.blueGrey),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                CustomTextFormField(
                  labelText: "اسم المستخدم",
                  hintText: "اسم المستخدم",
                  initialValue:  LocaleStorage().authenticatedUserName,
                  onSave: (value) => _controller.name = value!,
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  enable: false,
                  labelText: "رقم الجوال",
                  hintText: "رقم الجوال",
                  initialValue: _controller.authenticatedUser?['phone'] ?? "",
                  onSave: (value) => _controller.phone = value!,
                ),

                SizedBox(
                  height: 20,
                ),
                // Container(
                //   margin: const EdgeInsets.only(left: 4, right: 4),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       LabelTextFormField(text: "البريد الالكتروني"),
                //       SizedBox(height: 5),
                //       TextFormField(
                //         textAlignVertical: TextAlignVertical.bottom,
                //         style: TextStyle(fontSize: 18, height: 1.2),
                //         keyboardType: TextInputType.emailAddress,
                //         cursorColor: BLACK_COLOR,
                //         onSaved: (value) => _controller.phone = value!,
                //         validator: (value) {
                //           if (value?.length == 0) {
                //             return "phone_field_required".tr;
                //           } else if (value!.length < 9) {
                //             return "phone_short".tr;
                //           } else {
                //             return null;
                //           }
                //         },
                //         // enableInteractiveSelection: false,
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         initialValue:
                //             _controller.authenticatedUser?['email'] ?? "",
                //         decoration: InputDecoration(
                //             suffixIcon: Icon(Icons.edit),
                //             isCollapsed: true,
                //             enabled: true,
                //             isDense: true,
                //             contentPadding: const EdgeInsets.only(
                //                 top: 0, right: 10.0, bottom: 15, left: 20.0),
                //             border: const OutlineInputBorder(
                //               borderRadius: BorderRadius.all(
                //                 Radius.circular(10.0),
                //               ),
                //               borderSide: BorderSide(color: Colors.red),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //               borderSide: const BorderSide(
                //                   color: Color(0xffeeeeee), width: 1.0),
                //             ),
                //             errorBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //               borderSide: const BorderSide(
                //                   color: Color(0xffEF3939), width: 1.0),
                //             ),
                //             errorStyle: TextStyle(
                //                 overflow: TextOverflow.fade,
                //                 color: Color.fromARGB(255, 204, 11, 11),
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 12,
                //                 height: 0.8),
                //             focusedErrorBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //               borderSide: const BorderSide(
                //                   color: Color(0xffEF3939), width: 1.0),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //               borderSide: const BorderSide(
                //                 color: Color(0xffeeeeee),
                //                 width: 1.0,
                //               ),
                //             ),
                //             filled: true,
                //             hintStyle: const TextStyle(
                //                 fontSize: 14.0,
                //                 color: Colors.grey,
                //                 fontWeight: FontWeight.w500),
                //             hintText: "الرجاء ادخال البريد الالكتروني",
                //             fillColor: Colors.white70),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 20),
                _controller.authenticatedUser?['type'] == 'admin'
                    ? Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  color: AMBER_COLOR.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                size: 18,
                              ),
                            ),
                            Container(
                              // alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(
                                  left: 4, right: 0, top: 0),
                              child: GestureDetector(
                                onTap: () => Get.toNamed('/change/password'),
                                child: Text(
                                  " تغيير كلمة المرور ",
                                  style: TextStyle(
                                      color: BLACK_COLOR,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink(),

                // CustomPhoneFormField(
                //     onSave: (value) => _controller.phone = value),
                // SizedBox(height: 25),
                // Obx(() => CustomPasswordFormField(
                //       labelText: "password".tr,
                //       hintText: "enter_password".tr,
                //       obscureText: _controller.obscureText.value,
                //       onSave: (value) => _controller.password = value,
                //       onChangeTextSecure: _controller.changeObscureText,
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
                const SizedBox(height: 40.0),
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
                    visible: !_controller.isLoading,
                    child: CustomButton(
                      text: "Save Changes".tr,
                      onPress: () {
                        // Get.to(() => TotalPage());
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _controller.updateUser(context);
                        }
                      },
                    ))),
                Obx(() => Visibility(
                    visible: _controller.isLoading,
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
