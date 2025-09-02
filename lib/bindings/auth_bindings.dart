
import 'package:sagr/features/auth/presentation/controllers/login_controller.dart';
import 'package:sagr/repositories/auth_repository.dart';
import 'package:get/get.dart';


class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(Get.find()));
    Get.lazyPut(() => LoginController(Get.find()));
    // Get.lazyPut(() => AuthService(Get.find()));
    //  Get.lazyPut(() => CategoryRepository(Get.find()));
  }  
}
