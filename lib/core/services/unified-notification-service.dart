import 'package:sagr/core/utils/app_log.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/firebase_options.dart';
import 'dart:io';

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a separate isolate; init only if this isolate has no Firebase app.
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  appLog('🔔 Background message: ${message.messageId}');
}

class UnifiedNotificationService extends GetxService {
  static UnifiedNotificationService get instance => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final Dio _dio = Dio();

  bool _isInitialized = false;

  // ✅ Track active conversation to prevent notifications
  final RxnInt activeConversationId = RxnInt(null);

  // Callback for handling new messages in the app
  Function(Map<String, dynamic>)? onMessageReceived;

  // Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'chat_messages_channel',
    'Chat Messages',
    description: 'Notifications for chat messages',
    importance: Importance.high,
    playSound: true,
  );

  Future<UnifiedNotificationService> init() async {
    if (_isInitialized) return this;

    try {
      // Firebase is already initialized in main(); only init if missing
      // (e.g. service started before main's init).
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Request permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup message handlers
      _setupMessageHandlers();

      // Handle iOS APNs token
      if (Platform.isIOS) {
        await _waitForAPNSToken();
      }

      // Get and send FCM token
      await _initializeFCMToken();

      _isInitialized = true;
      appLog('✅ Notification service initialized successfully');
    } catch (e) {
      appLog('❌ Error initializing notification service: $e');
    }

    return this;
  }

  // ✅ New method to set active conversation
  void setActiveConversation(int? conversationId) {
    activeConversationId.value = conversationId;
    appLog('📱 Active conversation set to: $conversationId');
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      appLog('✅ User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      appLog('⚠️ User granted provisional notification permission');
    } else {
      appLog('❌ User declined notification permission');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    // Android setup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS setup - ✅ Enhanced for better handling
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Handle app launched from terminated state
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageTap(message);
      }
    });
  }

  Future<void> _waitForAPNSToken() async {
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      try {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          appLog('✅ APNs Token received: ${apnsToken.substring(0, 20)}...');
          return;
        }
      } catch (e) {
        appLog('⏳ Waiting for APNs token... attempt ${attempts + 1}');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }

    appLog('⚠️ APNs token not received after $maxAttempts attempts');
  }

  Future<void> _initializeFCMToken() async {
    try {
      // Always register the FCM token: Firebase cannot deliver to a raw APNs
      // token. On iOS getToken() only works once the APNs token exists, which
      // _waitForAPNSToken() has waited for.
      final token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_sendTokenToServer);
    } catch (e) {
      appLog('❌ Error initializing FCM token: $e');
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final accessToken = GetStorage().read('access_token');

      if (accessToken == null) {
        appLog('⚠️ No access token, skipping FCM token update');
        return;
      }

      final response = await _dio.post(
        '$BASEURL/fcm-token',
        data: {'fcm_token': token},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        appLog('✅ FCM token sent successfully');
      } else {
        appLog('❌ Failed to send FCM token: ${response.statusMessage}');
      }
    } catch (e) {
      appLog('❌ Error sending FCM token: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    appLog('🔔 Foreground message received: ${message.messageId}');
    appLog('📦 Data: ${message.data}');

    final messageType = message.data['type'];
    final conversationId =
        int.tryParse(message.data['conversation_id']?.toString() ?? '');

    // ✅ Check if message is for active conversation
    final isActiveConversation =
        conversationId != null && conversationId == activeConversationId.value;

    appLog('💬 Message for conversation: $conversationId');
    appLog('📱 Active conversation: ${activeConversationId.value}');
    appLog('🎯 Is active: $isActiveConversation');

    if (messageType == 'chat') {
      // ✅ Always notify app for real-time updates
      if (onMessageReceived != null) {
        appLog('📲 Calling onMessageReceived callback');
        onMessageReceived!(message.data);
      }

      // ✅ Only show notification if NOT active conversation
      if (!isActiveConversation) {
        appLog('🔔 Showing notification (not active conversation)');
        await _showNotification(message);
      } else {
        appLog('🔕 Suppressing notification (active conversation)');
      }
    } else {
      // Other message types - always show notification
      await _showNotification(message);
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    final title = notification?.title ??
        message.data['title'] ??
        message.data['sender_name'] ??
        'New Message';
    final body = notification?.body ??
        message.data['body'] ??
        message.data['content'] ??
        '';

    appLog('🔔 Showing local notification: $title - $body');

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    appLog('👆 Notification tapped: ${message.data}');

    final conversationId =
        int.tryParse(message.data['conversation_id']?.toString() ?? '');

    if (conversationId != null) {
      // Navigate to chat screen
      Get.toNamed('/chat', arguments: conversationId);
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        final conversationId =
            int.tryParse(data['conversation_id']?.toString() ?? '');

        if (conversationId != null) {
          Get.toNamed('/chat', arguments: conversationId);
        }
      } catch (e) {
        appLog('❌ Error parsing notification payload: $e');
      }
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Registers this device for push with the logged-in user. Call after a
  /// successful login: the token sent at cold start was skipped (no session).
  Future<void> refreshToken() async {
    try {
      if (Platform.isIOS) await _waitForAPNSToken();
      final token = await getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }
    } catch (e) {
      appLog('❌ Error refreshing FCM token: $e');
    }
  }

  /// Drops this device's FCM token so the next user on it doesn't receive the
  /// previous user's pushes; a fresh token is issued on the next getToken().
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
    } catch (e) {
      appLog('❌ Error deleting FCM token: $e');
    }
  }
}