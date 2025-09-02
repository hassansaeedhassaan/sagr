import 'package:get/get.dart';
import 'package:sagr/features/commissions/presentation/controllers/commissions_controller.dart';
import '../../data/datasource/commissions_data_source.dart';
import '../../data/repositories/commissions_repository_impl.dart';
import '../../domain/usecases/get_commissions.dart';

class CommissionsBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => CommissionsController(Get.find()));
    Get.lazyPut(() => CommissionDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CommissionsRepositoryImpl(Get.find<CommissionDataSourceImpl>()));
    Get.put(CommissionsUsecase(Get.find<CommissionsRepositoryImpl>()),
        permanent: true);
  }
}
