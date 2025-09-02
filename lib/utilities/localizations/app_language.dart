import 'package:get_storage/get_storage.dart';
import 'package:sagr/utilities/local_storage/locale_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLanguage extends GetxController {

  String appLocale = 'ar';

  RxString selectLocale = "".obs;


  @override
  void onInit() async {

    super.onInit();

    LocaleStorage localeStorage = LocaleStorage();

    appLocale = (await localeStorage.selectedLanguage);

    Get.updateLocale(Locale(appLocale));

    selectLocale.value = appLocale;

    update();

  }
 

  void changeLanguage(String locale) async {

    LocaleStorage localeStorage = LocaleStorage();

    if (appLocale == locale) return;

    appLocale = locale;

    localeStorage.saveLanguage(locale);
    
    Get.updateLocale(Locale(locale));

    GetStorage().write('updatedLanguage', locale);

    update();
  }


  void saveSelectLocale(String locale) {

 
    selectLocale.value = locale;
    GetStorage().write('updatedLanguage', locale);
    update();
  }
}
