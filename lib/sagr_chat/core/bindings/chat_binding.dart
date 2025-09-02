import 'package:get/get.dart';
import 'package:sagr/sagr_chat/controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );

    Get.lazyPut(() => SagrAuthController());
    
    // يتم إنشاء MessageController عند الحاجة فقط
    // لأنه يحتاج arguments من Get.arguments
  }
}