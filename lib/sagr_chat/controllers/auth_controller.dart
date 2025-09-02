import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class SagrAuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final _storage = GetStorage();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final token = _storage.read('access_token');
    final userData = _storage.read('userData');
    
    if (token != null && userData != null) {
      currentUser.value = User.fromJson(userData);
      isLoggedIn.value = true;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      isLoading.value = true;
      
      final fcmToken = await FirebaseMessaging.instance.getToken();
      
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      
      );

      await _handleAuthSuccess(response);
      Get.offAllNamed('/home');
      
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final fcmToken = await FirebaseMessaging.instance.getToken();
      
      final response = await _apiService.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      await _handleAuthSuccess(response);
      Get.offAllNamed('/home');
      
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleAuthSuccess(Map<String, dynamic> response) async {
    final token = response['token'];
    final userData = response['user'];

    await _storage.write('auth_token', token);
    await _storage.write('user', userData);

    currentUser.value = User.fromJson(userData);
    isLoggedIn.value = true;

    // Update user status to online
    await _apiService.updateStatus('online');
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      await _apiService.logout();
      await _storage.remove('auth_token');
      await _storage.remove('user');
      
      currentUser.value = null;
      isLoggedIn.value = false;
      
      Get.offAllNamed('/login');
      
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? avatarPath,
  }) async {
    try {
      isLoading.value = true;
      
      final updatedUser = await _apiService.updateProfile(
        name: name,
        avatarPath: avatarPath,
      );

      currentUser.value = updatedUser;
      await _storage.write('user', updatedUser.toJson());
      
      Get.snackbar('Success', 'Profile updated successfully');
      
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String status) async {
    try {
      await _apiService.updateStatus(status);
      if (currentUser.value != null) {
        currentUser.value = User(
          id: currentUser.value!.id,
          name: currentUser.value!.name,
          email: currentUser.value!.email,
          phone: currentUser.value!.phone,
          avatar: currentUser.value!.avatar,
          status: status,
          lastSeen: DateTime.now(),
          fcmToken: currentUser.value!.fcmToken,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}