import 'package:get/get.dart';

import '../../data/datasource/events_data_source.dart';
import '../../data/repositories/evocations_repository_impl.dart';
import '../../domain/usecases/get_events.dart';
import '../controllers/evocations_controller.dart';

class EvocationsBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => EvocationsController(Get.find()));
    
    Get.lazyPut(() => EvocationsDataSourceImpl(dio: Get.find()));
    
    Get.lazyPut(
        () => EvocationsRepositoryImpl(Get.find<EvocationsDataSourceImpl>()));
    
    Get.put(EvocationsUsecase(Get.find<EvocationsRepositoryImpl>()),
        permanent: true);

  }
}
