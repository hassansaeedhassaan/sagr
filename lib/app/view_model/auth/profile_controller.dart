

import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sagr/models/customer_model.dart';
import 'package:sagr/repositories/auth_repository.dart';

class AccountController extends GetxController {
  late String phone;
  late String name;
  String password = "";
  RxBool obscureText = true.obs;

  RxString type = ''.obs;

  RxString _item = "".obs;

  final AuthRepository _authRepository;

  AccountController(this._authRepository);

  final _customerModel = CustomerModel().obs;

  Map<String, dynamic>? authenticatedUser;
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  String get item => _item.value;
  CustomerModel get customerModel => _customerModel.value;

  @override
  void onInit() async {
    super.onInit();

print("Hello, it's me");


  }

  @override
  void onReady() {
    super.onReady();
  }

  void userData() async {
    authenticatedUser = await GetStorage().read('userData');
  }

  userInfo() async {
    _isLoading.value = true;

    if (GetStorage().read('access_token') != '') {
      final response = await _authRepository.fetchUser();
      _customerModel.value = response;
    }

    _isLoading.value = false;

    update();
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeObscureText() {
    obscureText.value = !obscureText.value;
  }

  setType(ty) {
    type.value = ty;
  }

  Future<void> updateUser(context) async {
    _isLoading.value = true;
    try {
      // print(GetStorage().read('userData'));

      final Map<String, dynamic> body = {
        'name': name,
      };

      await _authRepository.updateData(body).then((data) {
        GetStorage().write('userData', data);

        // GetStorage().write('loggedInUserPhone', data.phone);
        // GetStorage().write('loggedInUserName', data.name);

        // Get.snackbar('', '',
        //     titleText: Padding(
        //       padding: EdgeInsets.only(top: 10, bottom: 0),
        //       child: Text("تم حفظ البيانات بنجاح"),
        //     ),
        //     instantInit: false);
        Flushbar(
          // title: "Hey Ninja",
          titleColor: Colors.white,
          // message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          // backgroundColor: Colors.red,
          boxShadows: [
            BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0),
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0)
          ],
          backgroundGradient:
              LinearGradient(colors: [Colors.blueGrey, Colors.black]),
          isDismissible: false,
          duration: Duration(seconds: 4),
          icon: Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),

          showProgressIndicator: false,
          progressIndicatorBackgroundColor: Colors.blueGrey,
          // titleText: Text(
          //   "Hello Hero",
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
          // ),
          messageText: Text(
            "تم حفظ البيانات بنجاح",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
                fontFamily: "ShadowsIntoLightTwo"),
          ),
        )..show(context);

        // if (data.type != 'admin') {
        //   Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        //     Get.offAllNamed('/main');

        //     //  Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false);
        //   });
        // }

        update();
        //        print( GetStorage().read('userData'));

        //   GetStorage().write('userData', data);
        //   GetStorage().write('access_token', data.api_token);

        //   if (data.api_token != "") {
        //     Get.snackbar("Success", "Success Login");
        //     Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        //       Get.offAllNamed('/main');
        //     });
        //   } else {
        //     Get.offAllNamed('/login');
        //   }
      });
      _isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", e.toString());
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // await _authRepository.logout().then((data) {
      //   Get.snackbar("Success", "Success logged out");
      //   Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      //     Get.offAllNamed('/login');
      //   });
      // });
      _isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      _isLoading.value = false;
    }
  }
}
