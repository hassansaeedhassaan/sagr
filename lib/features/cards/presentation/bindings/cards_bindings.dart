import 'package:get/get.dart';
import '../../data/datasource/card_data_source.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../../domain/usecases/get_cards.dart';
import '../controllers/cards_controller.dart';

class CardsBindings implements Bindings {
  @override
  void dependencies() {


    Get.lazyPut(() => CardsController(Get.find()));
    Get.lazyPut(() => CardDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CardRepositoryImpl(Get.find<CardDataSourceImpl>()));
    Get.put(CardUsecase(Get.find<CardRepositoryImpl>()),
        permanent: true);
  }
}
