import 'package:get/get.dart';

import '../app/view_model/auth/login_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginViewModel());
  }
}
