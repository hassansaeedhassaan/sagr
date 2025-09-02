import 'package:get/get.dart';
import '../../data/datasource/banner_data_source.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../domain/usecases/get_wallet.dart';
import '../controllers/banner_controller.dart';

class WalletBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => BannerController(Get.find()));
    Get.lazyPut(() => BannerDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => BannerRepositoryImpl(Get.find<BannerDataSourceImpl>()));
    Get.put(BannerUsecase(Get.find<BannerRepositoryImpl>()),
        permanent: true);


  }
}
