import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification channel details
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'chat_app_channel',
    'Chat App Notifications',
    description: 'This channel is used for chat app notifications',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Request notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    } else {
      print('User declined or has not accepted notification permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Handle FCM messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Update FCM token whenever token refreshes
    _messaging.onTokenRefresh.listen(_updateFcmToken);

    // Get the token and update it on the server
    final token = await _messaging.getAPNSToken();
    if (token != null) {
      await _updateFcmToken(token);
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    // Handle notification tap
    if (notificationResponse.payload != null) {
      try {
        final data = jsonDecode(notificationResponse.payload!);
        // Navigate to conversation if conversation_id is available
        if (data['conversation_id'] != null) {
          // TODO: Navigate to conversation
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      String? payload;
      if (message.data.isNotEmpty) {
        payload = jsonEncode(message.data);
      }

      await _notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    }
  }

  void _handleBackgroundMessageTap(RemoteMessage message) {
    // Handle background message tap
    if (message.data.isNotEmpty) {
      if (message.data['conversation_id'] != null) {
        // TODO: Navigate to conversation
      }
    }
  }

  Future<void> _updateFcmToken(String token) async {

    print(token);
    // if (await _authService.isLoggedIn()) {
    //   await _authService.updateFcmToken(token);
    // }
  }
}

// This function needs to be top-level (not inside a class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to initialize Firebase if it's not already
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}