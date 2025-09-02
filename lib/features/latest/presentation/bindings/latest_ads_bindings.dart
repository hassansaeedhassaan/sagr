import 'package:get/get.dart';

import '../../data/datasource/latest_ads_data_source.dart';
import '../../data/repositories/latest_ads_repository_impl.dart';
import '../../domain/usecases/get_latest_ads.dart';

class LatestAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LatestAdsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => LatestAdsRepositoryImpl(Get.find<LatestAdsDataSourceImpl>()));
    Get.put(LatestAdUsecase(Get.find<LatestAdsRepositoryImpl>()),
        permanent: true);
  }
}
