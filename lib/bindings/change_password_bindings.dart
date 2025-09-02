import 'package:sagr/app/view_model/auth/change_password_controller.dart';
import 'package:sagr/repositories/change_password_repository.dart';
import 'package:get/get.dart';

class ChangePasswordBindings implements Bindings {
  @override
  void dependencies() {   

    Get.put(ChangePasswordRepository(Get.find()), permanent: true);
    Get.put(ChangePasswordController(Get.find()), permanent: true);
    
  }
}
