import 'package:sagr/config/app_config.dart';
import 'package:sagr/repositories/change_password_repository.dart';
import 'package:get/get.dart';
// ignore: library_prefixes

class ChangePasswordController extends GetxController {
 
  final ChangePasswordRepository _changePasswordRepository;

  ChangePasswordController(this._changePasswordRepository);

  late String phone;

  String old_password = "", new_password = "", confirm_new_password = "";

  RxBool obscureText = true.obs;
  RxBool obscureTextNewPssword = true.obs;
  RxBool obscureTextConfirmPssword = true.obs;

  RxBool isLoading = false.obs;

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

  changeObscureTextNewPassword() {
    obscureTextNewPssword.value = !obscureTextNewPssword.value;
  }

  changeObscureTextConfirmPassword() {
    obscureTextConfirmPssword.value = !obscureTextConfirmPssword.value;
  }

  Future<void> changePassword(context) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        'old_password': old_password,
        'password': new_password,
        'password_confirmation': confirm_new_password
      };

      await _changePasswordRepository.changePassword(body).then((response) {
      
        if (response.data['status'] == 200) {

          SharedData().showAlert(context, 'تم حفظ البيانات بنجاح');

          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            Get.toNamed('/account_edit');
          });
          
        }
      });
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }
}
