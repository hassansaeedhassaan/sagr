import 'package:get/get.dart';

import '../../data/datasource/marital_data_source.dart';
import '../../data/repositories/marital_status_repository_impl.dart';
import '../../domain/usecases/get_marital_status.dart';

class MaritalStatusBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaritalStatusDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => MaritalStatusRepositoryImpl(Get.find<MaritalStatusDataSourceImpl>()));
    Get.put(MaritalStatusUsecase(Get.find<MaritalStatusRepositoryImpl>()),
        permanent: true);
  }
}
