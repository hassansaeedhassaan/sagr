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
  print('🔔 Background message: ${message.messageId}');
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
      print('✅ Notification service initialized successfully');
    } catch (e) {
      print('❌ Error initializing notification service: $e');
    }

    return this;
  }

  // ✅ New method to set active conversation
  void setActiveConversation(int? conversationId) {
    activeConversationId.value = conversationId;
    print('📱 Active conversation set to: $conversationId');
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
      print('✅ User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional notification permission');
    } else {
      print('❌ User declined notification permission');
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
          print('✅ APNs Token received: ${apnsToken.substring(0, 20)}...');
          return;
        }
      } catch (e) {
        print('⏳ Waiting for APNs token... attempt ${attempts + 1}');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }

    print('⚠️ APNs token not received after $maxAttempts attempts');
  }

  Future<void> _initializeFCMToken() async {
    try {
      // Get current token
      var token = await _messaging.getToken();
      if (Platform.isIOS) {
        token = await _messaging.getAPNSToken();
      }

      if (token != null) {
        print('🔑 FCM Token: ${token.substring(0, 50)}...');
        await _sendTokenToServer(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_sendTokenToServer);
    } catch (e) {
      print('❌ Error initializing FCM token: $e');
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final accessToken = GetStorage().read('access_token');

      if (accessToken == null) {
        print('⚠️ No access token, skipping FCM token update');
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
        print('✅ FCM token sent successfully');
      } else {
        print('❌ Failed to send FCM token: ${response.statusMessage}');
      }
    } catch (e) {
      print('❌ Error sending FCM token: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('🔔 Foreground message received: ${message.messageId}');
    print('📦 Data: ${message.data}');

    final messageType = message.data['type'];
    final conversationId =
        int.tryParse(message.data['conversation_id']?.toString() ?? '');

    // ✅ Check if message is for active conversation
    final isActiveConversation =
        conversationId != null && conversationId == activeConversationId.value;

    print('💬 Message for conversation: $conversationId');
    print('📱 Active conversation: ${activeConversationId.value}');
    print('🎯 Is active: $isActiveConversation');

    if (messageType == 'chat') {
      // ✅ Always notify app for real-time updates
      if (onMessageReceived != null) {
        print('📲 Calling onMessageReceived callback');
        onMessageReceived!(message.data);
      }

      // ✅ Only show notification if NOT active conversation
      if (!isActiveConversation) {
        print('🔔 Showing notification (not active conversation)');
        await _showNotification(message);
      } else {
        print('🔕 Suppressing notification (active conversation)');
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

    print('🔔 Showing local notification: $title - $body');

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
    print('👆 Notification tapped: ${message.data}');

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
        print('❌ Error parsing notification payload: $e');
      }
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> refreshToken() async {
    final token = await getToken();
    if (token != null) {
      await _sendTokenToServer(token);
    }
  }
}