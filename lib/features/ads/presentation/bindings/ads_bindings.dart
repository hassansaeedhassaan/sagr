import 'package:get/get.dart';
import '../../data/datasource/ads_data_source.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/usecases/get_ads.dart';
import '../controllers/ads_controller.dart';

class AdsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdsController(Get.find()));
    Get.lazyPut(() => AdsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => AdsRepositoryImpl(Get.find<AdsDataSourceImpl>()));
    Get.put(AdsUsecase(Get.find<AdsRepositoryImpl>()),
        permanent: true);
  }
}
