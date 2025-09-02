import 'package:sagr/features/featured/data/datasource/featured_ads_data_source.dart';
import 'package:sagr/features/featured/domain/usecases/get_featured_ads.dart';
import 'package:get/get.dart';

import '../../data/repositories/customers_repository_impl.dart';

class FeaturedAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeaturedAdsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => FeaturedAdsRepositoryImpl(Get.find<FeaturedAdsDataSourceImpl>()));
    Get.put(FeaturedAdUsecase(Get.find<FeaturedAdsRepositoryImpl>()),
        permanent: true);
  }
}
