import 'package:get/get.dart';

import '../../data/datasource/jobs_data_source.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/usecases/get_job.dart';

class JobBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => JobRepositoryImpl(Get.find<JobDataSourceImpl>()));
    Get.put(JobUsecase(Get.find<JobRepositoryImpl>()),
        permanent: true);
  }
}
