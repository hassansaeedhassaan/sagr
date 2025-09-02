import 'package:get/get.dart';
import 'package:sagr/features/cards/domain/usecases/get_cards.dart';
import '../../../cards/data/datasource/card_data_source.dart';
import '../../../cards/data/repositories/card_repository_impl.dart';
import '../../data/datasource/wallet_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/usecases/get_wallet.dart';
import '../controllers/wallet_controller.dart';

class WalletBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => WalletController(Get.find()));
    Get.lazyPut(() => WalletDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => WalletRepositoryImpl(Get.find<WalletDataSourceImpl>()));
    Get.put(WalletUsecase(Get.find<WalletRepositoryImpl>()),
        permanent: true);


    Get.lazyPut(() => CardDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CardRepositoryImpl(Get.find<CardDataSourceImpl>()));
         Get.put(CardUsecase(Get.find<CardRepositoryImpl>()),
        permanent: true);
  }
}
