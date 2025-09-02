import 'package:get/get.dart';
import '../../data/datasource/events_data_source.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/usecases/get_events.dart';
import '../controllers/event_controller.dart';

class EventsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventController(Get.find()));
    Get.lazyPut(() => EventsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => EventsRepositoryImpl(Get.find<EventsDataSourceImpl>()));
    Get.put(EventsUsecase(Get.find<EventsRepositoryImpl>()),
        permanent: true);
  }
}
