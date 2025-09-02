import 'package:get/get.dart';

import '../../data/datasource/featured_ads_data_source.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/usecases/get_categories.dart';

class FeaturedAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CategoriesRepositoryImpl(Get.find<CategoriesDataSourceImpl>()));
    Get.put(CategoriesUsecase(Get.find<CategoriesRepositoryImpl>()),
        permanent: true);
  }
}
