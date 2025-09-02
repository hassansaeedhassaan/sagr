import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sagr/view/auth/widgets/Forms/label_text_form_field.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/data/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../app/view_model/auth/forgot/forgot_password_controller.dart';
import '../../app/view_model/auth/login_controller.dart';
import '../profile/Total/view.dart';
import '../widgets/Forms/custom_button.dart';
import '../widgets/app_locale_switcher.dart';
import '../widgets/custom_text.dart';
import '../widgets/fixed_app_bottom_bars.dart';

class ForgotScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordController _controller;

  // LoginController _controller = Get.put(LoginController(Get.find()));

  ForgotScreen(this._controller, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 80, // Set this height
        title: Text(
          "تسجيل الدخول",
          style:
              TextStyle(fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WHITE_COLOR,
        foregroundColor: BLACK_COLOR,
        elevation: 0,
      ),
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
                      Text(
                        "إستعادة كلمة المرور",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff202020),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "برجاء ادخال رقم الجوال المسجل لدينا من قبل",
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

                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Text(
                      //   "رقم الجوال",
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //       color: BLACK_COLOR),
                      // ),

                      LabelTextFormField(text: 'Phone'.tr, required: true),

                      SizedBox(height: 5),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 18, height: 1),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: BLACK_COLOR,
                        onSaved: (value) => _controller.phone = value!,
                        validator: (value) {
                          if (value?.length == 0) {
                            return "phone_field_required".tr;
                          } else if (value!.length < 9) {
                            return "phone_short".tr;
                          } else {
                            return null;
                          }
                        },
                        // enableInteractiveSelection: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                            isCollapsed: true,
                            enabled: true,
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                                top: 18, right: 10.0, bottom: 12, left: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffeeeeee), width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            errorStyle: TextStyle(
                                overflow: TextOverflow.fade,
                                color: Color.fromARGB(255, 204, 11, 11),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 0.8),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
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
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            hintText: "الرجاء ادخال رقم الجوال",
                            fillColor: Colors.white70),
                      ),
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
                      text: "confirm".tr,
                      onPress: () {
                        // Get.to(() => TotalPage());
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _controller.forgot().then((value) {
                             if (value) {
                              showMaterialModalBottomSheet(
                                backgroundColor: GetStorage().read('app_type') == 'tools' ? Color(0xffd32026): Color(0xff0A458B),
                                expand: false,
                                useRootNavigator: true,
                                context: context,
                                builder: (context) => Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 38, left: 40, right: 40),
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: WHITE_COLOR.withOpacity(0.8),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10))),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 50),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 10, 0),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 8, top: 16),
                                            child: GestureDetector(
                                              onTap: () => Get.back(),
                                              child: SvgPicture.asset(
                                                  "assets/icons/close.svg"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                    .only(
                                                start: 20, top: 0, end: 20),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/code.svg'),
                                                      Container(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topStart,
                                                        child: Text(
                                                          "رمز التحقق",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      BLACK_COLOR), // like <h1> in HTML
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topStart,
                                                        child: Text(
                                                          "برجاء ادخال كود التحقق المرسل اليك عبر الجوال",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.copyWith(
                                                                  color: Color(
                                                                      0xffBCBCBC)), // like <h1> in HTML
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        child: PinCodeTextField(
                                                          keyboardType: TextInputType.phone,
                                                          length: 4,
                                                          textStyle: TextStyle(
                                                              fontSize: 26,
                                                              height: 1.6),
                                                          obscureText: false,
                                                          animationType:
                                                              AnimationType
                                                                  .fade,
                                                          pinTheme: PinTheme(
                                                            borderWidth: 1,
                                                            shape:
                                                                PinCodeFieldShape
                                                                    .box,
                                                            inactiveColor:
                                                                Color(
                                                                    0xffeeeeee),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            // fieldHeight: 50,
                                                            fieldWidth: 75,
                                                            // activeFillColor:
                                                            //     Colors.white,
                                                          ),
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      300),

                                                          enableActiveFill:
                                                              false,
                                                          // errorAnimationController: errorController,
                                                          // controller: textEditingController,
                                                          onCompleted: (v) {
                                                            _controller
                                                                .setConfirmCode(
                                                                    v);
                                                          },
                                                          onChanged: (value) {
                                                            _controller
                                                                .setConfirmCode(
                                                                    value);
                                                            print(value);
                                                            // setState(() {
                                                            //   currentText = value;
                                                            // });
                                                          },
                                                          beforeTextPaste:
                                                              (text) {
                                                            print(
                                                                "Allowing to paste $text");
                                                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                            return true;
                                                          },
                                                          appContext: context,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  " لم تستلم الكود؟",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              BLACK_COLOR)),
                                                              GestureDetector(
                                                                onTap: () =>
                                                                    print(
                                                                        "sadsad"),
                                                                child: Text(
                                                                    "اضغط هنا",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "الوقت المتبقي: ",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            BLACK_COLOR),
                                                              ),
                                                              Text("00:59",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge
                                                                      ?.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              BLACK_COLOR))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      CustomButton(
                                                        text: "تأكيد ",
                                                        onPress: () => _controller.checkVerificationCode(),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
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

