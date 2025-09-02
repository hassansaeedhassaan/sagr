import 'package:get/get.dart';


class ResetPasswordController extends GetxController {
  ResetPasswordController();

  late String phone, password, confirmationPassword, code;
  RxBool isLoading = false.obs;
  RxBool obscureText = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    phone = Get.arguments;
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeObscureText() {
    obscureText.value = !obscureText.value;
  }

  Future<void> reset() async {
    isLoading.value = true;



    // print("From Forgot Password Controller: " + phone);
    try {
      final Map<String, dynamic> body = {
        'phone': phone,
        'password': password,
        'password_confirmation': confirmationPassword
      };

  
  print(body);
      // await _resetPasswordService.reset(body).then((data) {
      //   if (data['status'] == 200) {
      //     Get.snackbar("Success", data['message']);
      //     Future.delayed(Duration(milliseconds: 1000)).then((value) {
      //       Get.toNamed('/login');
      //     });
      //   }
      // });
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }
}
