import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/core/services/unified-notification-service.dart';
import 'package:sagr/core/utils/app_log.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/sagr_chat/controllers/auth_controller.dart';
import 'package:sagr/sagr_chat/controllers/chat_controller.dart';
import 'package:sagr/sagr_chat/services/reverb_service.dart';
import 'package:sagr/smart_task_manager_service.dart';

/// The one way to end a session. Every logout path (menu, expired token,
/// password change, account deletion) goes through here so the server token
/// is revoked, the device stops receiving the previous user's pushes, and no
/// realtime socket or cached chat survives into the next login.
class SessionService {
  SessionService._();

  static bool _endingSession = false;

  /// Storage keys that belong to the signed-in user. Language and other
  /// device preferences are kept.
  static const List<String> _userKeys = [
    'access_token',
    'accessTypeData',
    'userData',
    'loggedInUserName',
    'loggedInUserPhone',
    'fcm_token',
    SmartTaskManager.checkInKey,
  ];

  /// [revokeOnServer] is false when the server already rejected the token
  /// (401) or deleted the account: there is nothing left to revoke.
  static Future<void> logout({bool revokeOnServer = true}) async {
    if (_endingSession) return;
    _endingSession = true;
    try {
      final storage = GetStorage();
      final token = storage.read('access_token');

      if (revokeOnServer && token != null) {
        try {
          await Dio().post(
            '$BASEURL/logout',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
              sendTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );
        } catch (e) {
          // Best effort: the local session ends either way.
          appLog('Server logout failed: $e');
        }
      }

      SmartTaskManager().stop();

      if (Get.isRegistered<UnifiedNotificationService>()) {
        await UnifiedNotificationService.instance.deleteToken();
      }
      if (Get.isRegistered<ReverbService>()) {
        await Get.delete<ReverbService>(force: true);
      }
      if (Get.isRegistered<ChatController>()) {
        await Get.delete<ChatController>(force: true);
      }
      if (Get.isRegistered<SagrAuthController>()) {
        await Get.delete<SagrAuthController>(force: true);
      }

      for (final key in _userKeys) {
        await storage.remove(key);
      }

      if (Get.currentRoute != '/login') {
        Get.offAllNamed('/login');
      }
    } finally {
      _endingSession = false;
    }
  }
}
