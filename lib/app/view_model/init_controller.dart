import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utilities/local_storage/locale_storage.dart';

class InitController extends GetxController {
  InitController();

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();

    token();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void token() async {
    _isLoading.value = true;

    LocaleStorage localeStorage = LocaleStorage();



    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      localeStorage.updatedLanguage.then((language) {

        if (language == '') {
          GetStorage().write('lang', "ar");
          Get.toNamed('/home');
        }
        Get.toNamed('/home');
      });

      _isLoading.value = false;

      update();
    });
  }
}
