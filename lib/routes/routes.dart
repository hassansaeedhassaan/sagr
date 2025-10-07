
import 'package:get/get.dart';
import 'package:sagr/features/ads/presentation/bindings/ads_bindings.dart';
import 'package:sagr/features/ads_olllld/presentation/screens/ads_screen.dart';
import 'package:sagr/features/auth/presentation/screens/login_screen.dart';
import 'package:sagr/features/auth/presentation/screens/update_profile_screen.dart';
import 'package:sagr/features/education/presentation/bindings/education_bindings.dart';
import 'package:sagr/features/events/presentation/bindings/events_bindings.dart';
import 'package:sagr/features/events/presentation/screens/event_accept_screen.dart';
import 'package:sagr/features/events/presentation/screens/event_apply_screen.dart';
import 'package:sagr/features/events/presentation/screens/event_calender.dart';
import 'package:sagr/features/events/presentation/screens/event_calender_screen.dart';
import 'package:sagr/features/events/presentation/screens/event_precessing_screen.dart';
import 'package:sagr/features/events/presentation/screens/event_screen.dart';
import 'package:sagr/features/events/presentation/screens/events_screen.dart';
import 'package:sagr/features/events/presentation/screens/permissions.dart';
import 'package:sagr/features/events/presentation/screens/prev_events_screen.dart';
import 'package:sagr/features/evocations/presentation/bindings/evocations_bindings.dart';
import 'package:sagr/features/home/presentation/screens/home_screen.dart';
import 'package:sagr/features/jobs/presentation/bindings/job_bindings.dart';
import 'package:sagr/features/language/presentation/bindings/language_bindings.dart';
import 'package:sagr/features/marital_status/presentation/bindings/marital_status_bindings.dart';
import 'package:sagr/features/regions/presentation/bindings/region_bindings.dart';
import 'package:sagr/sagr_chat/screens/home/home_screen.dart';
import 'package:sagr/walkie_talkie/screens/walkie_talkie_screen_2.dart';
import 'package:sagr/walkie_talkie/screens/walkie_talkie_supervisor_screen.dart';
import '../bindings/application_binding.dart';
import '../bindings/auth_bindings.dart';
import '../bindings/change_password_bindings.dart';
import '../bindings/forgot_password_bindings.dart';
import '../bindings/product_bindings.dart';
import '../bindings/profile_bindings.dart';
import '../bindings/register_bindings.dart';
import '../bindings/reset_password_bindings.dart';
import '../features/ads/presentation/screens/ads_screen.dart';
import '../features/auth/presentation/bindings/create_account_bindings.dart';
import '../features/auth/presentation/screens/complete_account_screen.dart';
import '../features/auth/presentation/screens/create_account_screen.dart';
import '../features/chat/presentation/screens/conversations_list_screen.dart';
import '../features/chat/presentation/screens/messages_screen.dart';
import '../features/commissions/presentation/bindings/commissions_bindings.dart';
import '../features/commissions/presentation/screens/commission_screen.dart';
// import '../features/conversations/presentation/bindings/conversations_bindings.dart';
// import '../features/conversations/presentation/screens/chat_screen.dart';
import '../features/events/presentation/screens/attendance_departure_screen.dart';
import '../features/myads/presentation/bindings/my_ads_bindings.dart';
import '../features/myads/presentation/screens/my_ads_screen.dart';
import '../features/myfavorites/presentation/bindings/categories_bindings.dart';
import '../features/myfavorites/presentation/screens/my_favorite_screen.dart';
import '../features/notifications/presentation/bindings/notifications_bindings.dart';
import '../features/notifications/presentation/screens/notification_screen.dart';
import '../features/products/presentation/bindings/create_ad_bindings.dart';
import '../features/products/presentation/screens/product_info_screen.dart';
import '../sagr_chat/core/bindings/auth_binding.dart';
import '../sagr_chat/core/bindings/chat_binding.dart';
import '../sagr_chat/routes/app_routes.dart';
import '../sagr_chat/screens/chat/chat_screen.dart';
import '../sagr_chat/screens/contacts/contacts_screen.dart';
import '../sagr_chat/screens/splash_screen.dart';
import '../view/account/account_edit_screen.dart';
import '../view/account/change_password_screen.dart';
import '../view/ads_details_screen/ads_details_screen.dart';
import '../view/auth/forgot/forgot_password_screen.dart';
import '../view/auth/forgot/reset_password_screen.dart';
import '../view/auth/forgot/verification_code_screen.dart';
import '../view/auth/forgot_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/category_page/category_page.dart';
import '../view/create_ad_screen.dart';
import '../view/init_view.dart';
import '../view/more_one_screen/more_one_screen.dart';
import '../view/products/product_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/settings/language.dart';


final List<GetPage> routes = [

  GetPage(
      name: '/product_screen',
      page: () => const ProductScreen(),
      transition: Transition.fadeIn,
      bindings: [ApplicationBinding()]),
  GetPage(
      name: '/login',
      page: () => LoginScreen(Get.find()),
      transition: Transition.native,
      bindings: [LoginBindings()]),
  GetPage(
      name: '/register',
      page: () => RegisterScreen(Get.find()),
      binding: RegisterBindings()),
  GetPage(
      name: '/forgot/password/screen',
      page: () => ForgotPasswordScreenOLD(Get.find()),
      binding: ForgotPasswordBindings()),
  GetPage(
      name: '/forgot/password',
      page: () => ForgotScreen(Get.find()),
      binding: ForgotPasswordBindings()),
  GetPage(
      name: '/verification/code',
      page: () => VerificationScreen(Get.find()),
      binding: ForgotPasswordBindings()),
  GetPage(
      name: '/reset/password',
      page: () => ResetPasswordScreen(Get.find()),
      binding: ResetPasswordBindings()),
 
  
  GetPage(name: '/profile', page: () => ProfileScreen(Get.find()), bindings: [
    ProfileBindings(),
    ApplicationBinding(),
  ]),
  GetPage(
      name: '/init_view',
      page: () => InitView(),
      bindings: [ApplicationBinding()]),
  GetPage(
      name: '/create_account',
      page: () => CreateAccountScreen(),
      bindings: [ApplicationBinding(), CreateAccountBindings(), MaritalStatusBindings(),JobBindings(), EducationsBindings(), RegionBindings(), LanguagesBindings()]),

  GetPage(
      name: '/update_account',
      page: () => UpdateAccountScreen(),
      bindings: [ApplicationBinding(), CreateAccountBindings(), MaritalStatusBindings(),JobBindings(), EducationsBindings(), RegionBindings(), LanguagesBindings()]),


       GetPage(
      name: '/complete_account',
      page: () => CompleteAccountScreen(),
      bindings: [ApplicationBinding(), CreateAccountBindings(), MaritalStatusBindings(),JobBindings(), EducationsBindings(), RegionBindings(), LanguagesBindings()]),



  GetPage(
      name: '/home',
      page: () => HomeScreen(),
      bindings: [ApplicationBinding(), JobBindings()]),

      
  GetPage(
      name: '/more',
      page: () => MoreOneScreen(),
      bindings: [ApplicationBinding()]),
  GetPage(
      name: '/lang',
      page: () => LanguageScreen(),
      bindings: [ApplicationBinding()]),

  GetPage(
      name: '/events',
      page: () => EventsScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),



  // GetPage(
  //     name: '/conversations',
  //     page: () => ConversationsScreen(),
  //     bindings: [ApplicationBinding(), ConversationsBindings()]),



  GetPage(
      name: '/previous_events',
      page: () => PreviousEventsScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),

  

  GetPage(
      name: '/e_calender',
      page: () => EventCalendarPage(),
      bindings: [ApplicationBinding(), EventsBindings()]),

  


      GetPage(
      name: '/event_screen',
      page: () => EventDetailsScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),




      GetPage(
      name: '/event_walkie_talkie',
      page: () => WalkieTalkieScreen2(),
      bindings: [ApplicationBinding(), EventsBindings()]),

      GetPage(
      name: '/event_supervisor_walkie_talkie',
      page: () => WalkieTalkieSupervisorScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),

  
      GetPage(
      name: '/event_accept_screen',
      page: () => EventAcceptScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),
 
 
  GetPage(
      name: '/event_processing_screen',
      page: () => EventProcessingScreen(),
      bindings: [ApplicationBinding(), EventsBindings()]),
 
   GetPage(
      name: '/event_apply_screen',
      page: () => EventApplyScreen(),
      bindings: [ApplicationBinding(), EventsBindings(), JobBindings(), LanguagesBindings()]),
 
 
   GetPage(
      name: '/attendance_screen',
      page: () => AttendanceAndDepartureScreen(),
      bindings: [ApplicationBinding(), EventsBindings(), JobBindings(), LanguagesBindings()]),
 
    // GetPage(
    //   name: '/chat',
    //   page: () => ChatScreen(),
    //   bindings: [ApplicationBinding(),ConversationsBindings() ]),
 
    GetPage(
      name: '/permissions',
      page: () => PermissionsScreen(),
      bindings: [ApplicationBinding(), EvocationsBindings()]),
 


    GetPage(
      name: '/ads',
      page: () => AdScreen(),
      bindings: [ApplicationBinding(),AdsBindings() ]),
 
 

    GetPage(
      name: '/events_calender',
      page: () => EventsCalenderScreen(),
      bindings: [ApplicationBinding(), ]),
 
 

 

 
 
  GetPage(
      name: '/account_edit',
      page: () => AccountEditScreen(Get.find()),
      bindings: [ApplicationBinding()]),
  GetPage(
      name: '/product_info',
      page: () => ProductInfoScreen(),
      bindings: [ApplicationBinding(), ProductBindings()]),
  GetPage(
      name: '/product_detail_screen',
      page: () => AdsDetailsScreen(),
      bindings: [ApplicationBinding(), ProductBindings()]),
  GetPage(
      name: '/commissions_screen',
      page: () => CommissionScreen(Get.find()),
      bindings: [ApplicationBinding(), CommissionsBindings()]),

  // GetPage(
  //     name: '/conversations_list',
  //     page: () => ConversationListScreen(Get.find()),
  //     bindings: [ApplicationBinding(), ConversationsBindings()]),
  // GetPage(
  //     name: '/messages_list',
  //     page: () => MessagesScreen(Get.find()),
  //     bindings: [ApplicationBinding(), ConversationsBindings()]),
  GetPage(
      name: '/favorite_ads_screen',
      page: () => MyFavoriteScreen(),
      bindings: [ApplicationBinding(), FavoriteAdsBindings()]),
  GetPage(
      name: '/my_ads_screen',
      page: () => MyAdsScreen(),
      bindings: [ApplicationBinding(), MyAdsBindings()]),
  GetPage(
      name: '/notifications',
      page: () => NotificationsScreen(Get.find()),
      bindings: [ApplicationBinding(), NotificationsBindings()]),
  GetPage(
      name: '/create_add_screen',
      page: () => CreateAdScreen(Get.find()),
      bindings: [ApplicationBinding(), CreateAdBindings()]),
  GetPage(
      name: '/category_screen',
      page: () => CategoryPage(),
      bindings: [ApplicationBinding()]),
  GetPage(
      name: '/change/password',
      page: () => ChangePassworsScreen(Get.find()),
      bindings: [ApplicationBinding(), ChangePasswordBindings()]),

       GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
    ),
    // GetPage(
    //   name: AppRoutes.LOGIN,
    //   page: () => LoginScreen(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.REGISTER,
    //   page: () => RegisterScreen(),
    //   binding: AuthBinding(),
    // ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreenChat(),
      bindings:[ApplicationBinding(), ChatBinding()],
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.CONTACTS,
      page: () => ContactsScreen(),
    )
    

];



