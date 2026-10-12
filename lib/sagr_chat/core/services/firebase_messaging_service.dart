import 'package:sagr/core/utils/app_log.dart';


import 'dart:convert';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message.dart' as app_models;
import 'notification_service.dart';
import 'package:get/get.dart' as getx;

class FirebaseMessagingService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final RxString fcmToken = ''.obs;
  final Rx<RemoteMessage?> lastMessage = Rx<RemoteMessage?>(null);


  // Stream for new messages
  final _messageStreamController = StreamController<app_models.Message>.broadcast();
  Stream<app_models.Message> get onMessageReceived => _messageStreamController.stream;

  Future<FirebaseMessagingService> init() async {
    appLog('🔥 Initializing Firebase Messaging...');
    
    // 1️⃣ طلب الإذن من المستخدم
    await _requestPermission();
    
    // 2️⃣ الحصول على FCM Token
    await _getToken();
    
    // 3️⃣ معالجة الرسائل في المقدمة (التطبيق مفتوح)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // 4️⃣ معالجة الرسائل في الخلفية (التطبيق مُصغر)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // 5️⃣ معالجة النقر على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // 6️⃣ معالجة الرسائل عند فتح التطبيق من إشعار
    _handleInitialMessage();
    
    return this;
  }

  /// 📋 1. طلب إذن الإشعارات
  Future<void> _requestPermission() async {
    appLog('📱 Requesting notification permissions...');
    
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,     // إشعارات عادية
      announcement: false,
      badge: true,     // Badge على الأيقونة
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,     // صوت الإشعار
    );

    appLog('✅ Permission status: ${settings.authorizationStatus}');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      appLog('🎉 User granted permissions');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      appLog('⚠️ User granted provisional permissions');
    } else {
      appLog('❌ User declined or has not accepted permissions');
    }
  }

  /// 🔑 2. الحصول على FCM Token
  Future<void> _getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      fcmToken.value = token ?? '';
      appLog('🔑 FCM Token: $token');
      
      // إرسال التوكن للسيرفر
      if (token != null) {
        await _sendTokenToServer(token);
      }
      
      // الاستماع لتحديث التوكن
      _firebaseMessaging.onTokenRefresh.listen((String newToken) {
        appLog('🔄 Token refreshed: $newToken');
        fcmToken.value = newToken;
        _sendTokenToServer(newToken);
      });
    } catch (e) {
      appLog('❌ Error getting FCM token: $e');
    }
  }

  /// 📤 إرسال التوكن للسيرفر
  Future<void> _sendTokenToServer(String token) async {
    try {
      // هنا تقوم بإرسال التوكن لـ Laravel backend
      appLog('📤 Sending token to server: $token');
      
       appLog('✅✅✅✅✅✅✅✅✅✅✅✅✅ HETEE');
      // Example API call:
      // await _dio.post('/auth/fcm-token',data:  {'fcm_token': token});
       try {
      // final response = await _dio.post(
      //   ApiConstants.updateFcmToken,
      //   data: {'fcm_token': token},
 
      // );


      // if (response.statusCode == 200) {
      //   appLog('✅ FCM token sent successfully');
      // } else {
      //   appLog('❌ Failed to send FCM token: ${response.statusMessage}');
      // }
    } catch (e) {
      appLog('❌ Error sending FCM token: $e');
    }
      
    } catch (e) {
      appLog('❌ Error sending token to server: $e');
    }
  }

  /// 🎯 3. معالجة الرسائل في المقدمة (Foreground)
  void _handleForegroundMessage(RemoteMessage message) {
    appLog('📱 FOREGROUND MESSAGE RECEIVED:');
    appLog('📨 Message ID: ${message.messageId}');
    appLog('📋 Title: ${message.notification?.title}');
    appLog('📝 Body: ${message.notification?.body}');
    appLog('📊 Data: ${message.data}');
    
    // 🔔 عرض إشعار محلي (لأن التطبيق مفتوح)
    try {
      final notificationService = Get.find<NotificationService>();
      notificationService.showNotification(
        title: message.notification?.title ?? 'New Message',
        body: message.notification?.body ?? 'You have a new message',
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      appLog('❌ Error showing notification: $e');
    }

    // 📱 تحديث واجهة المستخدم
    _processMessageData(message);
  }

  /// 🔄 4. معالجة النقر على الإشعار (Message Opened App)
  void _handleMessageOpenedApp(RemoteMessage message) {
    appLog('👆 USER TAPPED NOTIFICATION:');
    appLog('📨 Message ID: ${message.messageId}');
    appLog('📊 Data: ${message.data}');
    
    lastMessage.value = message;
    
    // 🚀 الانتقال للشاشة المناسبة
    _navigateToChat(message);
  }

  /// 🎬 5. معالجة الرسالة الأولى عند فتح التطبيق
  Future<void> _handleInitialMessage() async {
    try {
      // التحقق من وجود رسالة أدت لفتح التطبيق
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      
      if (initialMessage != null) {
        appLog('🎬 App opened from notification:');
        appLog('📨 Message ID: ${initialMessage.messageId}');
        
        // تأخير صغير للتأكد من تحميل التطبيق
        await Future.delayed(const Duration(seconds: 2));
        _navigateToChat(initialMessage);
      }
    } catch (e) {
      appLog('❌ Error handling initial message: $e');
    }
  }

  /// 📊 معالجة بيانات الرسالة
  void _processMessageData(RemoteMessage remoteMessage) {
    try {
      final data = remoteMessage.data;
      
      if (data.isNotEmpty) {
        // تحويل بيانات Firebase إلى Message model
        final appMessage = _convertRemoteMessageToAppMessage(remoteMessage);
        
        if (appMessage != null) {
          appLog('✅ Message converted successfully');
          _messageStreamController.add(appMessage);
        }
      }
    } catch (e) {
      appLog('❌ Error processing message data: $e');
    }
  }

  /// 🔄 تحويل RemoteMessage إلى app Message model
  app_models.Message? _convertRemoteMessageToAppMessage(RemoteMessage remoteMessage) {
    try {
      final data = remoteMessage.data;
      


  
      // إذا كانت البيانات تحتوي على message_data كاملة
      if (data.containsKey('message_data')) {
        final messageJson = jsonDecode(data['message_data']);
        return app_models.Message.fromJson(messageJson);
      }
      
      // إنشاء Message من البيانات المُرسلة مباشرة
      if (data.containsKey('chat_id') && data.containsKey('sender_id')) {
        return app_models.Message(
          id: data['message_id'] ?? '',
          chatId: data['chat_id'] ?? '',
          senderId: data['sender_id'] ?? '',
          receiverId: data['receiver_id'],
          content: data['content'] ?? remoteMessage.notification?.body ?? '',
          type: _parseMessageType(data['message_type']),
          status: app_models.MessageStatus.delivered,
          timestamp: DateTime.now(),
          mediaUrl: data['media_url'],
          audioDuration: data['audio_duration'] != null 
              ? int.tryParse(data['audio_duration'].toString()) 
              : null,
          isGroupMessage: data['is_group_message'] == 'true',
          replyToId: data['reply_to_id'],
        );
      }
    } catch (e) {
      appLog('❌ Error converting RemoteMessage: $e');
    }
    return null;
  }

  /// 🧭 الانتقال للشاشة المناسبة
  void _navigateToChat(RemoteMessage message) {
    try {
      final data = message.data;
      
      if (data.containsKey('chat_id')) {
        final chatId = data['chat_id'];
        appLog('🧭 Navigating to chat: $chatId');
        
        // الانتقال لشاشة المحادثة
        Get.toNamed('/chat', arguments: {
          'chatId': chatId,
        });
      } else if (data.containsKey('type')) {
        // أنواع أخرى من الإشعارات
        switch (data['type']) {
          case 'new_message':
            _handleNewMessageNotification(data);
            break;
          case 'group_invitation':
            _handleGroupInvitationNotification(data);
            break;
          default:
            appLog('🤷‍♂️ Unknown notification type: ${data['type']}');
        }
      }
    } catch (e) {
      appLog('❌ Error navigating from notification: $e');
    }
  }

  /// 💬 معالجة إشعار رسالة جديدة
  void _handleNewMessageNotification(Map<String, dynamic> data) {
    final chatId = data['chat_id'];
    if (chatId != null) {
      Get.toNamed('/chat', arguments: {'chatId': chatId});
    }
  }

  /// 👥 معالجة إشعار دعوة مجموعة
  void _handleGroupInvitationNotification(Map<String, dynamic> data) {
    final groupId = data['group_id'];
    if (groupId != null) {
      // يمكن إظهار dialog للموافقة على الدعوة
      Get.dialog(
        AlertDialog(
          title: const Text('Group Invitation'),
          content: Text('You have been invited to join ${data['group_name'] ?? 'a group'}'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Decline'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/chat', arguments: {'chatId': groupId});
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      );
    }
  }

  /// 🔍 تحليل نوع الرسالة
  app_models.MessageType _parseMessageType(String? typeString) {
    switch (typeString?.toLowerCase()) {
      case 'text': return app_models.MessageType.text;
      case 'image': return app_models.MessageType.image;
      case 'video': return app_models.MessageType.video;
      case 'audio': return app_models.MessageType.audio;
      case 'document': return app_models.MessageType.document;
      default: return app_models.MessageType.text;
    }
  }

  /// 📢 الاشتراك في موضوع معين
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      appLog('✅ Subscribed to topic: $topic');
    } catch (e) {
      appLog('❌ Error subscribing to topic: $e');
    }
  }

  /// 🚫 إلغاء الاشتراك في موضوع
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      appLog('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      appLog('❌ Error unsubscribing from topic: $e');
    }
  }

  /// 💬 الاشتراك في تحديثات محادثة معينة
  Future<void> subscribeToChatUpdates(String chatId) async {
    await subscribeToTopic('chat_$chatId');
  }

  /// 🚫 إلغاء الاشتراك في تحديثات محادثة
  Future<void> unsubscribeFromChatUpdates(String chatId) async {
    await unsubscribeFromTopic('chat_$chatId');
  }

  /// 👤 الاشتراك في تحديثات المستخدم
  Future<void> subscribeToUserUpdates(String userId) async {
    await subscribeToTopic('user_$userId');
  }

  @override
  void onClose() {
    _messageStreamController.close();
    super.onClose();
  }
}

/// 🌙 معالج الرسائل في الخلفية (Background Handler)
/// ⚠️ يجب أن يكون top-level function (خارج أي class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  appLog('🌙 BACKGROUND MESSAGE RECEIVED:');
  appLog('📨 Message ID: ${message.messageId}');
  appLog('📋 Title: ${message.notification?.title}');
  appLog('📝 Body: ${message.notification?.body}');
  appLog('📊 Data: ${message.data}');
  
  // يمكنك هنا:
  // - حفظ الرسالة في قاعدة بيانات محلية
  // - تحديث badge count
  // - إرسال tracking event
  
  // ⚠️ لا تستخدم GetX أو UI operations هنا
  // لأن التطبيق في الخلفية
}