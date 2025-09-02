import 'package:get/get.dart';
import 'package:sagr/features/chat/presentation/controllers/conversations_controller.dart';
import 'package:sagr/features/chat/presentation/controllers/messages_controller.dart';
import '../../data/datasource/conversations_data_source.dart';
import '../../data/repositories/conversations_repository_impl.dart';
import '../../domain/usecases/get_conversation.dart';

class ConversationsBindings implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => ConversationsController(Get.find()));
    Get.lazyPut(() => MessagesController(Get.find()));
    Get.lazyPut(() => ConversationDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => ConversationsRepositoryImpl(Get.find<ConversationDataSourceImpl>()));
    Get.put(ConversationUsecase(Get.find<ConversationsRepositoryImpl>()),
        permanent: true);
  }
}
