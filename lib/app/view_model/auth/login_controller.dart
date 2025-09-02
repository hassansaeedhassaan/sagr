import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  late String phone;
  String password = "";
  RxBool obscureText = true.obs;
  RxBool obscureTextNew = true.obs;
  RxBool isLoading = false.obs;
  RxString type = ''.obs;

  late RxString _phoneErrorMsg = ''.obs;
  late RxString _passwordErrorMsg = ''.obs;

  String get phoneErrorMsg => _phoneErrorMsg.value;
  String get passwordErrorMsg => _passwordErrorMsg.value;

  validationMessageSetter(type, value) {
    // _phoneErrorMsg.value = 'Required';
    if (type == 'phone') {
      if (value?.length == 0) {
        _phoneErrorMsg.value = 'Required';
      } else if (value!.length < 9) {
        _phoneErrorMsg.value = 'Short';
      } else {
        _phoneErrorMsg.value = '';
      }
    }

    update();
  }
  RxBool _agree = true.obs;
  RxBool _agree_error_message = false.obs;

  bool get agree => _agree.value;
  bool get agree_error_message => _agree_error_message.value;


  void acceptAgree() {
    _agree.value = !_agree.value;
    _agree_error_message.value = false;
    update();
  }

  @override
  void onInit() async {
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

  changeObscureTextNew() {
    obscureTextNew.value = !obscureTextNew.value;
  }

  setType(ty) {
    type.value = ty;
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {"user_name": phone, "password": password};

      await _authRepository.login(body).then((data) {

        final response = Map<String, dynamic>.from(data.data['data']);

        GetStorage().write('userData', response['user']);

        GetStorage().write('access_token', response['access_token']['token']);
        
        GetStorage().write('accessTypeData', response['access_token']);

        if (response['access_token']['token'] != "") {
          
          Get.snackbar("Success Message".tr, "");

          Future.delayed(const Duration(milliseconds: 1500)).then((value) =>  Get.offAllNamed('/home_screen'));
        }
      });
      isLoading.value = false;
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }



    update();
  }

  
}
