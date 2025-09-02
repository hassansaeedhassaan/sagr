import 'package:sagr/app/view_model/auth/forgot/reset_password_controller.dart';
import 'package:sagr/repositories/reset_password_repository.dart';
import 'package:get/get.dart';

class ResetPasswordBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordRepository(Get.find()));
    Get.lazyPut(() => ResetPasswordController());
  }
}
