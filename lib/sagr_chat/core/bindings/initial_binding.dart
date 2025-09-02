import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../repositories/chat_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart'; // إضافة
import '../services/auth_service.dart';
import '../services/audio_service.dart';
import '../services/media_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<NetworkInfo>(NetworkInfoImpl(), permanent: true);
    
    // API Client
    final apiClient = ApiClient();
    apiClient.init();
    Get.put<ApiClient>(apiClient, permanent: true);
    
    // Services
    Get.putAsync<AuthService>(() async => AuthService(), permanent: true);
    Get.putAsync<AudioService>(() async => AudioService(), permanent: true);
    Get.put<MediaService>(MediaService(), permanent: true);
    
    // Repositories
    Get.put<AuthRepository>(AuthRepositoryImpl(Get.find<ApiClient>()),permanent: true);
    Get.put<ChatRepository>(ChatRepositoryImpl(Get.find<ApiClient>()),permanent: true);
    Get.put<UserRepository>(UserRepositoryImpl(Get.find<ApiClient>()), permanent: true);
  }
}