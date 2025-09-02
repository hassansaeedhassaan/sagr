import 'package:get/get.dart';

import '../../data/datasource/region_data_source.dart';
import '../../data/repositories/region_repository_impl.dart';
import '../../domain/usecases/get_region.dart';

class RegionBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegionsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => RegionRepositoryImpl(Get.find<RegionsDataSourceImpl>()));
    Get.put(RegionUsecase(Get.find<RegionRepositoryImpl>()),
        permanent: true);
  }
}
