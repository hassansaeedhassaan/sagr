import 'package:get/get.dart';

import '../controllers/create_ad_controller.dart';


class CreateAdBindings implements Bindings {
  @override
  void dependencies() {
      Get.lazyPut(() => CreateAdController(Get.find()));
  }

}
