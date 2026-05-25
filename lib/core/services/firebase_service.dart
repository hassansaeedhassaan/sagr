import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sagr/helper/base_url.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
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

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Message data: ${message.data}');
  
//   // Access custom data
//   String? type = message.data['type'];
//   String? messageId = message.data['message_id'];
//   String? conversationId = message.data['conversation_id'];
//   String? content = message.data['content'];
  
//   if (type == 'chat_message') {

    
//     // Navigate to chat or update UI
//     // navigateToChatScreen(conversationId);
//   }
// });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  if (Platform.isIOS) {
      // انتظر حتى يتم تعيين APNs token
      await _waitForAPNSToken();
    }
    
    // Update FCM token whenever token refreshes
    _messaging.onTokenRefresh.listen(_updateFcmToken);

    // Get the token and update it on the server
    final token = await _messaging.getToken();


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

   Future<void> _waitForAPNSToken() async {
    int attempts = 0;
    const maxAttempts = 10;
    
    while (attempts < maxAttempts) {
      try {
        String? apnsToken = await _messaging.getToken();
        if (apnsToken != null) {
          print('APNs Token received: $apnsToken');
          return;
        }
      } catch (e) {
        print('Waiting for APNs token... attempt ${attempts + 1}');
      }
      
      await Future.delayed(Duration(milliseconds: 500));
      attempts++;
    }
    
    print('Warning: APNs token not received after $maxAttempts attempts');
  }
  
  

  Future<void> _handleForegroundMessage(RemoteMessage message) async {



// print("🤔🤔🤔🤔🤔🤔🤔🤔");
// if ( message.data['type'] != 'chat_message'){
//         return;
//       }
      
//       if (message.data['type'] == 'chat_message' ) {
//         Get.dialog(
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(20),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Material(
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 10),
//                           const Text(
//                             "Title Text",
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 15),
//                           const Text(
//                             "Message Text",
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 20),
//                           //Buttons
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   child: const Text(
//                                     'NO',
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     minimumSize: const Size(0, 45),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: ElevatedButton(
//                                   child: const Text(
//                                     'YES',
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     minimumSize: const Size(0, 45),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else {
//         // showNotification(message);
//       }
print("🤔🤔🤔🤔🤔🤔🤔🤔");


    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;

    // if (notification != null && android != null) {
    //   String? payload;
    //   if (message.data.isNotEmpty) {
    //     payload = jsonEncode(message.data);
    //   }

    //   await _notificationsPlugin.show(
    //     notification.hashCode,
    //     notification.title,
    //     notification.body,
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         _channel.id,
    //         _channel.name,
    //         channelDescription: _channel.description,
    //         icon: android.smallIcon,
    //         importance: Importance.max,
    //         priority: Priority.high,
    //       ),
    //       iOS: const DarwinNotificationDetails(
    //         presentAlert: true,
    //         presentBadge: true,
    //         presentSound: true,
    //       ),
    //     ),
    //     payload: payload,
    //   );
    // }
  }

  void _handleBackgroundMessageTap(RemoteMessage message) {
    // Handle background message tap
    if (message.data.isNotEmpty) {
      if (message.data['conversation_id'] != null) {
        // TODO: Navigate to conversation
      }
    }
  }

  // Future<void> _updateFcmToken(String token) async {


  //  try {
  //     final response = await http.post(
  //       Uri.parse("$BASEURL/fcm-token"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         // Add authentication headers if needed
  //         // 'Authorization': 'Bearer your_token_here',
  //       },
  //       body: {
  //         'token': token
  //       },
  //     );
  //     // ).timeout(const Duration(seconds: 30));


  //     if (response.statusCode == 200) {
  //       print('Location sent successfully');
  //     } else {
  //       print('Failed to send location _sendToServer: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error sending location to server: $e');
  //   }
  
  //   // if (await _authService.isLoggedIn()) {
  //   //   await _authService.updateFcmToken(token);
  //   // }


  // }
Future<void> _updateFcmToken(String token) async {
  try {

      // final AuthController authController = Get.put(AuthController());


// print(authController.authenticatedUser.toString());


    
    final response = await http.post(
      Uri.parse("$BASEURL/fcm-token"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add authentication headers if needed
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'  ,
      },
      body: jsonEncode({  // Convert Map to JSON string
        'fcm_token': token
      }),
    );
    // ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      print('FCM token sent successfully');
    } else {
      print('Failed to send FCM token: ${response.body}');
    }
  } catch (e) {
    print('Error sending FCM token to server: $e');
  }
}

  
}

// This function needs to be top-level (not inside a class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to initialize Firebase if it's not already
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}