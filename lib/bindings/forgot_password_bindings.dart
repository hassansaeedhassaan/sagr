import 'package:sagr/app/view_model/auth/forgot/forgot_password_controller.dart';
import 'package:sagr/repositories/forgot_password_repository.dart';
import 'package:get/get.dart';

class ForgotPasswordBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordRepository(Get.find()));
    Get.lazyPut(() => ForgotPasswordController());
  }
}
