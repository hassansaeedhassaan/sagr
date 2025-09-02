import 'package:get/get.dart';
import '../../data/datasource/notifications_data_source.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/usecases/get_commissions.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => NotificationsController(Get.find()));
    Get.lazyPut(() => NotificationDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => NotificationsRepositoryImpl(Get.find<NotificationDataSourceImpl>()));
    Get.put(NotificationsUsecase(Get.find<NotificationsRepositoryImpl>()),
        permanent: true);
  }
}
