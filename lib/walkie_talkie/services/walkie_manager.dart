import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

import 'package:sagr/core/utils/app_log.dart';
import 'package:sagr/walkie_talkie/services/livekit_token_service.dart';
import 'package:sagr/walkie_talkie/services/walkie_session.dart';

/// The one walkie-talkie connection of the app.
///
/// A joined channel outlives the screen it was joined from: leaving the walkie
/// screen, locking the phone or putting the app in the background keeps the
/// team audible (in a pocket, on the speaker). On Android a foreground service
/// with an ongoing notification keeps the process and its audio alive; iOS
/// keeps it through the `audio` background mode.
///
/// It is left only when the user leaves (walkie screen or the notification's
/// Leave button), logs out, the server stops signing the channel (event over,
/// access withdrawn), or for the time a chat conversation is open
/// ([suspendForChat] / [resumeAfterChat]) — after which it rejoins.
class WalkieManager extends GetxService {
  static WalkieManager get to => Get.isRegistered<WalkieManager>()
      ? Get.find<WalkieManager>()
      : Get.put(WalkieManager(), permanent: true);

  /// How often a live channel re-checks with the server that it may still be
  /// used, so an ended event releases the phone.
  static const Duration accessCheckEvery = Duration(minutes: 10);

  WalkieSession? _session;
  String _label = '';
  String _route = '/event_walkie_talkie';
  Object? _routeArgs;

  int _chatDepth = 0;
  bool _resumeAfterChat = false;
  bool _serviceRunning = false;
  Timer? _accessTimer;

  /// Joined (or rejoining) a channel — what the in-app "live" pill shows.
  final RxBool live = false.obs;

  /// LiveKit lost the link and is retrying on its own.
  final RxBool reconnecting = false.obs;

  /// Left for an open chat conversation; rejoins when it closes.
  final RxBool pausedForChat = false.obs;

  /// Name of the live channel, for the pill and the notification.
  final RxString channelLabel = ''.obs;

  /// The route on screen (GetMaterialApp.routingCallback), so the pill can
  /// stay out of the walkie screens themselves.
  final RxString currentRoute = ''.obs;

  static const walkieRoutes = {
    '/event_walkie_talkie',
    '/event_supervisor_walkie_talkie',
  };

  WalkieSession? get session => _session;

  /// The session for [channelName] on [eventId]. The one already joined is
  /// handed back as-is, so returning to the walkie screen (or the attendance
  /// button) shows it still connected; asking for another channel leaves the
  /// current one first. [route]/[routeArgs] reopen the screen from the pill or
  /// the notification.
  WalkieSession sessionFor({
    required String channelName,
    int? eventId,
    String? label,
    String route = '/event_walkie_talkie',
    Object? routeArgs,
  }) {
    final current = _session;
    if (current != null &&
        current.channelName == channelName &&
        current.eventId == eventId) {
      if (label != null && label.isNotEmpty) _setLabel(label);
      return current;
    }

    if (current != null) unawaited(_drop(current));

    final session = WalkieSession(channelName: channelName, eventId: eventId)
      ..addListener(_onSessionChanged);
    _session = session;
    _route = route;
    _routeArgs = routeArgs ?? eventId;
    _setLabel(label != null && label.isNotEmpty ? label : channelName);
    _resumeAfterChat = false;
    pausedForChat.value = false;
    return session;
  }

  /// Leaves the channel (Leave button, notification, logout, event over).
  /// The session object stays the current one, idle, so a walkie screen that
  /// is still open keeps a working Join button.
  Future<void> leave() async {
    _resumeAfterChat = false;
    pausedForChat.value = false;
    await _session?.disconnect();
    _afterStateChange();
  }

  /// A chat conversation opened: step out of the channel so its audio and the
  /// chat's voice notes don't fight over the microphone and speaker.
  Future<void> suspendForChat() async {
    _chatDepth++;
    final session = _session;
    if (_chatDepth != 1 || session == null) return;
    final joined = session.state == WalkieState.connected ||
        session.state == WalkieState.reconnecting ||
        session.state == WalkieState.connecting;
    if (!joined) return;
    _resumeAfterChat = true;
    pausedForChat.value = true;
    await session.disconnect();
  }

  /// The last open chat conversation closed: rejoin if it made us leave.
  Future<void> resumeAfterChat() async {
    if (_chatDepth > 0) _chatDepth--;
    if (_chatDepth != 0 || !_resumeAfterChat) return;
    _resumeAfterChat = false;
    pausedForChat.value = false;
    await _session?.connect();
  }

  /// Opens the live channel's screen (the pill, the notification).
  void openWalkie() {
    if (_session == null) return;
    if (Get.currentRoute == _route) return;
    Get.toNamed(_route, arguments: _routeArgs);
  }

  void _setLabel(String label) {
    _label = label;
    channelLabel.value = label;
    if (_serviceRunning) unawaited(_updateService());
  }

  void _onSessionChanged() => _afterStateChange();

  void _afterStateChange() {
    final state = _session?.state;
    final joined =
        state == WalkieState.connected || state == WalkieState.reconnecting;
    live.value = joined || pausedForChat.value;
    reconnecting.value = state == WalkieState.reconnecting;

    if (joined) {
      unawaited(_startService());
      _accessTimer ??= Timer.periodic(accessCheckEvery, (_) => _checkAccess());
    } else {
      // Left, failed, or paused for a chat: the notification would be wrong.
      unawaited(_stopService());
      _accessTimer?.cancel();
      _accessTimer = null;
    }
  }

  /// The server signs a channel token only while the user may use the walkie
  /// (EventAccess on the backend). Refused now — event over, access
  /// withdrawn — means leave.
  Future<void> _checkAccess() async {
    final session = _session;
    if (session == null || session.state != WalkieState.connected) return;
    try {
      await LiveKitTokenService()
          .fetchToken(session.channelName, eventId: session.eventId);
    } on WalkieTokenUnavailable catch (e) {
      appLog('Walkie access ended: $e');
      await leave();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) await leave();
    } catch (_) {
      // Offline or a server hiccup: not a reason to drop the team.
    }
  }

  /// Leaves a channel being replaced by another. Not disposed: a screen
  /// further down the stack may still hold it, and an idle session owns
  /// nothing once disconnected.
  Future<void> _drop(WalkieSession session) async {
    session.removeListener(_onSessionChanged);
    await session.disconnect();
  }

  // ---- Android foreground service ----------------------------------------

  static bool get _android => !kIsWeb && Platform.isAndroid;

  static void _init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'walkie_talkie',
        channelName: 'Walkie-talkie'.tr,
        channelDescription:
            'Shown while the walkie-talkie is on in the background.'.tr,
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _startService() async {
    if (!_android || _serviceRunning) return;
    _serviceRunning = true;
    try {
      _init();
      final permission =
          await FlutterForegroundTask.checkNotificationPermission();
      if (permission != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
      if (await FlutterForegroundTask.isRunningService) {
        await _updateService();
        return;
      }
      final result = await FlutterForegroundTask.startService(
        serviceId: 4711,
        notificationTitle: 'Walkie-talkie is on'.tr,
        notificationText: _label,
        notificationButtons: [
          NotificationButton(id: 'leave', text: 'Leave'.tr)
        ],
        callback: walkieServiceCallback,
      );
      if (result is ServiceRequestFailure) {
        _serviceRunning = false;
        appLog('Walkie foreground service failed: ${result.error}');
      }
    } catch (e) {
      _serviceRunning = false;
      appLog('Walkie foreground service failed: $e');
    }
  }

  Future<void> _updateService() async {
    if (!_android) return;
    try {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Walkie-talkie is on'.tr,
        notificationText: _label,
      );
    } catch (_) {}
  }

  Future<void> _stopService() async {
    if (!_android || !_serviceRunning) return;
    _serviceRunning = false;
    try {
      await FlutterForegroundTask.stopService();
    } catch (_) {}
  }

  /// Taps on the notification, relayed from the service isolate.
  void _onTaskData(Object data) {
    if (data == 'leave') {
      unawaited(leave());
    } else if (data == 'open') {
      openWalkie();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (_android) {
      FlutterForegroundTask.initCommunicationPort();
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
    }
  }

  @override
  void onClose() {
    if (_android) FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    _accessTimer?.cancel();
    super.onClose();
  }
}

/// Runs the walkie's foreground service on Android; only relays the
/// notification's taps — the audio itself stays in the app's main isolate.
@pragma('vm:entry-point')
void walkieServiceCallback() {
  FlutterForegroundTask.setTaskHandler(_WalkieTaskHandler());
}

class _WalkieTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'leave') FlutterForegroundTask.sendDataToMain('leave');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
    FlutterForegroundTask.sendDataToMain('open');
  }
}
