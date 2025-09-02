import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  Function(Map<String, dynamic>)? onMessageReceived;

  @override
  void onInit() {
    super.onInit();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      // Handle app launch from notification
      RemoteMessage? initialMessage = 
          await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = 
        InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification when app is in foreground
    _showLocalNotification(message);
    
    // Notify listeners
    if (onMessageReceived != null) {
      onMessageReceived!(message.data);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate to chat screen
    if (message.data['type'] == 'message') {
      final conversationId = int.tryParse(message.data['conversation_id']);
      if (conversationId != null) {
        Get.toNamed('/chat', arguments: conversationId);
      }
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle local notification tap
    final payload = response.payload;
    if (payload != null) {
      final data = Map<String, dynamic>.from(
        Uri.splitQueryString(payload)
      );
      _handleMessageTap(RemoteMessage(data: data));
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
          'chat_messages',
          'Chat Messages',
          channelDescription: 'Notifications for chat messages',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = 
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
      notificationDetails,
      payload: Uri(queryParameters: message.data).query,
    );
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}