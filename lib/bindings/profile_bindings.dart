import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => ProfileController(Get.find()));

  }
}
