import 'package:get/get.dart';
import 'package:sagr/features/education/data/datasource/education_data_source.dart';
import 'package:sagr/features/education/data/repositories/education_repository_impl.dart';
import 'package:sagr/features/education/domain/usecases/get_education.dart';



class EducationsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EducationDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => EducationRepositoryImpl(Get.find<EducationDataSourceImpl>()));
    Get.put(EducationUsecase(Get.find<EducationRepositoryImpl>()),
        permanent: true);
  }
}
