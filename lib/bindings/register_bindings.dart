import 'package:sagr/app/view_model/auth/register_controller.dart';
import 'package:sagr/app/view_model/auth/register_phone_controller.dart';
import 'package:get/get.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(Get.find()));
    Get.lazyPut(() => RegisterPhoneController(Get.find()));

  }
}
