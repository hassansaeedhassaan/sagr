import 'package:get/get.dart';

import '../../data/datasource/auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/auth.dart';


class CreateAccountBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => AuthRepositoryImpl(Get.find<AuthDataSourceImpl>()));
    Get.put(AuthUsecase(Get.find<AuthRepositoryImpl>()),
        permanent: true);
  }
}
