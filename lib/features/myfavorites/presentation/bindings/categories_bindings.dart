import 'package:get/get.dart';

import '../../data/datasources/product_data_source.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/usecases/get_favorite_products.dart';

class FavoriteAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => FavoriteProductsRepositoryImpl(Get.find<FavoriteDataSourceImpl>()));
    Get.put(FavoriteProductUsecase(Get.find<FavoriteProductsRepositoryImpl>()),
        permanent: true);
  }
}
