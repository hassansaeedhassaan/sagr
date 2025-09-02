import 'package:get/get.dart';

import '../../../repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository;

  RegisterController(this._authRepository);

  String? name, email, password, phone, confirmationPassword;

  RxString gender = 'male'.obs;
  RxBool obscureText = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeObscureText() {
    obscureText.value = !obscureText.value;
  }

  Future<void> register({required String apiToken}) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmationPassword,
      'api_token': apiToken
    };

    try {
      isLoading.value = true;

      await _authRepository.RegisterComplete(body).then((data) {
        final response = new Map<String, dynamic>.from(data);

        if (response['status'] == 200) {
          // return response;
          Get.snackbar("", "Registeration Completed Successfullt".tr);
          Future.delayed(Duration(milliseconds: 1000)).then((value) {
            Get.offAllNamed('/login');
          });
        }
      });

      isLoading.value = false;
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }

  void changeGender(String type) {
    gender.value = type;
  }
}
