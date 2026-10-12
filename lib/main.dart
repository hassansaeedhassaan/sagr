import 'package:sagr/core/utils/app_log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:sagr/firebase_options.dart';
import 'package:sagr/smart_task_manager_service.dart';
import 'bindings/application_binding.dart';
import 'core/services/unified-notification-service.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_helper.dart';
import 'utilities/localizations/translation.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent, brightness-aware status bar that matches the app surfaces.
  // SystemChrome.setSystemUIOverlayStyle(AppTheme.statusBarLight);

  // Boot the WebRTC layer once, up front. Without this the first walkie-talkie
  // connect pays the native init cost mid-join, which on iOS shows up as a
  // multi-second stall before audio flows.
  await LiveKitClient.initialize();

  // StatusBarHelper.setDarkStatusBar();


 await GetStorage.init();

  // Live-location heartbeat: only resumes for a logged-in, checked-in user.
  SmartTaskManager().initialize();

  
  // Android's FirebaseInitProvider auto-inits the [DEFAULT] app natively from
  // google-services.json before main() runs, so initializeApp may throw
  // 'duplicate-app'. That existing app is the same project — treat as benign.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      appLog('Firebase initialization error: $e');
    }
  }
 

// GetStorage().remove('access_token');
//           GetStorage().remove('userData');

  // await NotificationService.instance.initialize();
  // Initialize Firebase Service
  // final firebaseService = FirebaseService();
  // await firebaseService.initialize();
  Get.put(UnifiedNotificationService()).init();


  initializeDateFormatting().then((_) => runApp(MyApp()));

  ThemeHelper().changeTheme('primary');
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ApplicationBinding(),

      defaultTransition: Transition.noTransition,
      // transitionDuration: Duration(milliseconds: 500),
      translations: Translation(),
      title: 'Sagr'.tr,

      // navigatorKey: Get.nestedKey(1),
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      locale: Locale(GetStorage().read('lang') ?? "ar"),
      fallbackLocale: const Locale('en'),
      initialRoute:
          GetStorage().read('access_token') == null ? '/login' : '/init_view',

      // initialRoute:  '/init_view',
      getPages: routes,
      // A typo'd or removed route lands on home instead of a blank screen.
      unknownRoute: routes.firstWhere((page) => page.name == '/home'),
    );
  }
}
