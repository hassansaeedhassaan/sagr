import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utilities/localizations/app_language.dart';

class AppLocaleSwitcher extends StatelessWidget {
  const AppLocaleSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLanguage>(
        init: AppLanguage(),
        builder: (controller) {
          return DropdownButton(
            items: [
               DropdownMenuItem(
                child: Text("ARABIC"),
                value: 'ar',
              ),
              DropdownMenuItem(
                child: Text("English"),
                value: 'en',
              ),
            ],
            value: controller.appLocale,
            onChanged: (value) {
              print(value);
              controller.changeLanguage(value.toString());
              Get.updateLocale(Locale(value.toString()));
            },
          );
        });
  }
}
