import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/core/utils/app_log.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/sagr_chat/services/reverb_service.dart';

/// The signed-in user's unread notification count, live.
///
/// Listens on private-user.{id} (Reverb): `notification.created` brings the
/// new notification and the count, `notifications.count` the count after
/// something was read (here or on another device). The count is fetched
/// once on start and again when the app comes back to the foreground, in
/// case the socket missed something while the app was suspended.
class LiveNotifications extends GetxService with WidgetsBindingObserver {
  static LiveNotifications get to => Get.isRegistered<LiveNotifications>()
      ? Get.find<LiveNotifications>()
      : Get.put(LiveNotifications(), permanent: true);

  final RxInt unread = 0.obs;

  /// The latest notification that arrived live; the list screen inserts it.
  final Rxn<NotificationModel> latest = Rxn<NotificationModel>();

  int? _userId;
  ReverbService? _reverb;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _detach();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _userId != null) refreshCount();
  }

  /// After login, and at app start when a session exists.
  Future<void> start() async {
    final storage = GetStorage();
    final user = storage.read('userData');
    final id = user is Map ? int.tryParse('${user['id']}') : null;
    if (storage.read('access_token') == null || id == null) return;
    if (_userId == id && _reverb != null) return;

    _detach();
    _userId = id;
    refreshCount();

    try {
      final reverb = Get.isRegistered<ReverbService>()
          ? Get.find<ReverbService>()
          : Get.put(ReverbService());
      reverb.on('notification.created', _onCreated);
      reverb.on('notifications.count', _onCount);
      _reverb = reverb;
      await reverb.subscribe('private-user.$id');
    } catch (e) {
      appLog('Live notifications unavailable: $e');
    }
  }

  /// On logout.
  void stop() {
    _detach();
    _userId = null;
    unread.value = 0;
    latest.value = null;
  }

  Future<void> refreshCount() async {
    final token = GetStorage().read('access_token');
    if (token == null) return;
    try {
      final response = await Dio().get(
        '$BASEURL/notifications',
        queryParameters: {'limit': 1},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      final data = response.data;
      if (data is Map && data['unread_count'] is num) {
        unread.value = (data['unread_count'] as num).toInt();
      }
    } catch (_) {}
  }

  /// The list screen marked something read locally.
  void setUnread(int count) => unread.value = count < 0 ? 0 : count;

  void _onCreated(Map<String, dynamic> data) {
    final count = data['unread_count'];
    if (count is num) unread.value = count.toInt();
    final n = data['notification'];
    if (n is Map) {
      latest.value = NotificationModel.fromJson(Map<String, dynamic>.from(n));
    }
  }

  void _onCount(Map<String, dynamic> data) {
    final count = data['unread_count'];
    if (count is num) unread.value = count.toInt();
  }

  void _detach() {
    _reverb?.off('notification.created', _onCreated);
    _reverb?.off('notifications.count', _onCount);
    _reverb = null;
  }
}
