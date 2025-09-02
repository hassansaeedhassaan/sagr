import 'package:get/get.dart';

import '../../data/datasource/language_data_source.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../domain/usecases/get_language.dart';

class LanguagesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguagesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => LanguageRepositoryImpl(Get.find<LanguagesDataSourceImpl>()));
    Get.put(LanguageUsecase(Get.find<LanguageRepositoryImpl>()),
        permanent: true);
  }
}
