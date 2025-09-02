import 'package:get/get.dart';

import '../../data/datasource/pages_data_source.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/usecases/get_categories.dart';

class PagesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PagesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => PagesRepositoryImpl(Get.find<PagesDataSourceImpl>()));
    Get.put(PagesUsecase(Get.find<PagesRepositoryImpl>()),
        permanent: true);
  }
}
