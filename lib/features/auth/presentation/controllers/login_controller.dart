import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/data/strings.dart';
import 'package:sagr/repositories/auth_repository.dart';

import '../../../../widgets/messages.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  late String phone = '';
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
  final RxBool _agree = true.obs;
  final RxBool _agree_error_message = false.obs;

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
    // Guard: the phone field is not a Form field, so validate() can pass with an
    // empty/stale phone. Block the request and surface a clear message instead.
    if (phone.trim().isEmpty) {
      Get.snackbar("Error!".tr, 'Required'.tr);
      return;
    }

    isLoading.value = true;
    try {
      // Backend (Api/V1/LoginController) reads `phone` + `password` and returns
      // a flat { access_token: <string>, token_type, user }.
      final body = {"phone": phone, "password": password};

      final data = await _authRepository.login(body);

      // Response shape varies (`{data: {...}}` vs flat) and access_token may be
      // an object `{token: ...}` or a plain string — handle all cases.
      final raw = Map<String, dynamic>.from(data.data);
      final payload = raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'])
          : raw;

      final tokenField = payload['access_token'];
      final String? token =
          tokenField is Map ? tokenField['token']?.toString() : tokenField?.toString();

      if (token == null || token.isEmpty) {
        throw 'missing_access_token';
      }

      GetStorage().write('access_token', token);
      GetStorage().write('accessTypeData', payload['token_type'] ?? tokenField);
      GetStorage().write('userData', payload['user']);

      isLoading.value = false;

      MessageHelper.showSuccessSnackbar(
        title: 'تم بنجاح',
        message: AppStrings.SUCCESS_LOGIN.tr,
        onTap: () {},
      );

      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAllNamed('/home');
    } catch (e) {
      print(e);
      isLoading.value = false;
      Get.snackbar("Error!".tr, 'wrong'.tr);
    }

    update();
  }

  
}
