import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/firebase_options.dart';
import 'package:sagr/location_service.dart';
import 'package:sagr/smart_task_manager_service.dart';
import 'background_tasks.dart';
import 'bindings/application_binding.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'data/colors.dart';
import 'routes/routes.dart';
import 'theme/theme_helper.dart';
import 'utilities/localizations/translation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();



print("I'm Here ✅✅✅✅✅");
  // Workmanager().initialize(callbackDispatcher);




//  Workmanager().initialize(
//   callbackDispatcher,
//   isInDebugMode: true, // This helps with debugging
// );

SmartTaskManager().initialize();

// Workmanager().registerOneOffTask(
//   "test",
//   "locationUpdateTask",
//   initialDelay: Duration(seconds: 1),
// );


//   print("START EVERY 15 Seconds");
// // Chain multiple one-off tasks if needed
//   Workmanager().registerOneOffTask(
//     "chained-task-${DateTime.now().millisecondsSinceEpoch}",
//     "chainedTask",
//     initialDelay: Duration(seconds: 0), // Your desired interval
//   );
//   print("END EVERY 15 Seconds");


//  final LocationService _locationService = LocationService();


//  await _locationService.startLocationTracking();

  
  print("I'm Here ✅✅✅✅✅ AN Adaaat");
  // await Firebase.initializeApp();
  //  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  // } catch (e) {
  //   print('Firebase initialization error: $e');
  // }
  
  // await NotificationService.instance.initialize();

  await GetStorage.init();
    // Initialize Firebase Service
  // final firebaseService = FirebaseService();
  // await firebaseService.initialize();



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

      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff6f6f6),
        fontFamily: "URW",
        primaryColor: Color(0xfff8f8f8),
        iconTheme: const IconThemeData(color: Colors.black),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ZAHRA_ORANGE.withOpacity(0.3),
          selectionHandleColor: ZAHRA_RED
        ),
      ),
   
      locale: Locale(GetStorage().read('lang') ?? "ar"),
      fallbackLocale: const Locale('en'),
      initialRoute: GetStorage().read('access_token') == null
          ? '/login'
          : '/init_view',

      // initialRoute:  '/init_view',
      getPages: routes,

    );
  }
}
