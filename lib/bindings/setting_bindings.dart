
import 'package:get/get.dart';

import '../app/view_model/settings/setting_controller.dart';

class SettingBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
