import 'package:sagr/utilities/localizations/ar.dart';
import 'package:sagr/utilities/localizations/en.dart';
import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': ar,
        'en': en,
      };
}
