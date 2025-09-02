import 'package:get/get.dart';

import '../../data/datasources/my_ads_data_source.dart';
import '../../data/repositories/my_ads_repository_impl.dart';
import '../../domain/usecases/get_my_ads.dart';

class MyAdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAdsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => MyAdsRepositoryImpl(Get.find<MyAdsDataSourceImpl>()));
    Get.put(MyAdsUsecase(Get.find<MyAdsRepositoryImpl>()),
        permanent: true);
  }
}
