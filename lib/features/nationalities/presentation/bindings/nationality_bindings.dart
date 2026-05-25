import 'package:get/get.dart';
import 'package:sagr/features/nationalities/data/datasource/nationalities_data_source.dart';
import '../../data/repositories/nationality_repository_impl.dart';
import '../../domain/usecases/get_nationality.dart';

class NationalityBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NationalitiesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => NationalityRepositoryImpl(Get.find<NationalitiesDataSourceImpl>()));
    Get.put(NationalityUsecase(Get.find<NationalityRepositoryImpl>()),
        permanent: true);
  }
}
