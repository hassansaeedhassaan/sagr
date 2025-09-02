// import 'package:dio/dio.dart';
// import 'package:get/get.dart';

// class ApplicationBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(
//       () => Dio(BaseOptions(baseUrl: 'https://5f7cba02834b5c0016b058aa.mockapi.io/api')),
//     );
//   }
// }

// import 'package:dio/dio.dart';
// import 'package:get/get.dart';

// class ApplicationBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(
//       () => Dio(BaseOptions(
//           baseUrl: 'https://5f7cba02834b5c0016b058aa.mockapi.io/api')),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:sagr/app/view_model/settings/setting_controller.dart';
import 'package:sagr/data/constants.dart';
import 'package:sagr/features/auth/presentation/controllers/login_controller.dart';
import 'package:sagr/features/chat/domain/repositories/conversations_repository.dart';
import 'package:sagr/features/education/data/datasource/education_data_source.dart';
import 'package:sagr/features/education/data/repositories/education_repository_impl.dart';
import 'package:sagr/features/education/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/events/data/datasource/events_data_source.dart';
import 'package:sagr/features/events/data/repositories/event_repository_impl.dart';
import 'package:sagr/features/events/domain/usecases/get_events.dart';
import 'package:sagr/features/events/presentation/controllers/events_controller.dart';
import 'package:sagr/features/products/data/datasources/product_data_source.dart';
import 'package:sagr/features/products/data/repositories/products_repository_impl.dart';
import 'package:sagr/features/products/domain/usecases/get_products.dart';
import 'package:sagr/repositories/auth_repository.dart';
import 'package:sagr/repositories/setting_repository.dart';
import 'package:sagr/utilities/local_storage/locale_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../features/banner/data/datasource/banner_data_source.dart';
import '../features/banner/data/repositories/banner_repository_impl.dart';
import '../features/banner/domain/usecases/get_wallet.dart';
import '../features/categories/data/datasource/featured_ads_data_source.dart';
import '../features/categories/data/repositories/categories_repository_impl.dart';
import '../features/categories/domain/usecases/get_categories.dart';
import '../features/chat/data/datasource/conversations_data_source.dart';
import '../features/chat/data/repositories/conversations_repository_impl.dart';
import '../features/chat/domain/usecases/get_conversation.dart';
import '../features/chat/presentation/controllers/conversations_controller.dart';
import '../features/chat/presentation/controllers/messages_controller.dart';
import '../features/countries/data/datasource/country_data_source.dart';
import '../features/countries/data/repositories/categories_repository_impl.dart';
import '../features/countries/domain/usecases/get_countries.dart';
import '../features/education/domain/usecases/get_education.dart';
import '../features/evocations/data/datasource/events_data_source.dart';
import '../features/evocations/data/repositories/evocations_repository_impl.dart';
import '../features/evocations/domain/usecases/get_events.dart';
import '../features/evocations/presentation/controllers/evocations_controller.dart';
import '../features/featured/data/datasource/featured_ads_data_source.dart';
import '../features/featured/data/repositories/customers_repository_impl.dart';
import '../features/featured/domain/usecases/get_featured_ads.dart';
import '../features/latest/data/datasource/latest_ads_data_source.dart';
import '../features/latest/data/repositories/latest_ads_repository_impl.dart';
import '../features/latest/domain/usecases/get_latest_ads.dart';
import '../features/notifications/data/datasource/notifications_data_source.dart';
import '../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../features/notifications/domain/usecases/get_commissions.dart';
import '../features/notifications/presentation/controllers/notifications_controller.dart';
import '../sagr_chat/controllers/auth_controller.dart';
import '../sagr_chat/controllers/chat_controller.dart';
import '../sagr_chat/services/api_service.dart';
import '../sagr_chat/services/firebase_messaging_service.dart';
import '../widgets/sagr_bottom_navigation/bottom_navigation_controller.dart';

class ApplicationBinding implements Bindings {
  Dio _dio() {
    final options = BaseOptions(
      connectTimeout: Duration(milliseconds: AppLimit.REQUEST_TIME_OUT),
      receiveTimeout: Duration(milliseconds: AppLimit.REQUEST_TIME_OUT),
      sendTimeout: Duration(milliseconds: AppLimit.REQUEST_TIME_OUT),
      headers: headers(),
      // headers: {'Authorization': "Bearer " + AppLimit?.AUTH_TOKEN}
    );

    var dio = Dio(options);

 // Add interceptor to dynamically add token to requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to every request if it exists
          final token = GetStorage().read("access_token");
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = "Bearer $token";
          }
          

          print("Hello, Hassan From interceptors 😍");
          // Add language header
          final language = GetStorage().read("lang");
          if (language != null) {
            options.headers['Accept-Language'] = language;
          }
          
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 errors (token expired/invalid)
          if (error.response?.statusCode == 401) {
            // Clear stored token and redirect to login
            GetStorage().remove("access_token");
            GetStorage().remove("userData");
            // You might want to redirect to login page here
            // Get.offAllNamed('/login');
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  @override
  void dependencies() {
    Get.lazyPut(
      _dio,
    );

    Get.lazyPut(() => LoginController(Get.find()));
    // Get.lazyPut(() => MainController(Get.find()));
    // Get.lazyPut(() => HomeController(Get.find()));

    // Get.lazyPut(() => SettingRepository(Get.find()));
    // Get.lazyPut(() => SettingController(Get.find()));
    // Get.put(SettingRepository(Get.find()), permanent: true);
    // Get.put(SettingController(Get.find()), permanent: true);

    // Get.lazyPut(()=>ProductDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(()=>ProductsRepositoryImpl(Get.find<ProductDataSourceImpl>()));

    // Get.lazyPut(() => ProductUsecase(Get.find<ProductsRepositoryImpl>()));
    // Get.lazyPut(() => SettingController());
    // Get.lazyPut(() => MainController());

    // Get.put(ProductRepository(Get.find()), permanent: true);
    // Get.put(CategoryRepository(Get.find()), permanent: true);

    // Get.put(CategoryProductRepository(Get.find()), permanent: true);

    // Get.put(OrderRepository(Get.find()), permanent: true);
    // Get.put(SessionStartService(Get.find()), permanent: true);
    // Get.lazyPut(() => AuthRepository(Get.find()));
    // Get.lazyPut(() => AccountController(Get.find()));
    // Get.put(AccountController(Get.find()), permanent: true);
    // Get.put(InitController(Get.find()), permanent: true);
    Get.put(AuthRepository(Get.find()), permanent: true);

    // Products Bindings
    // Get.lazyPut(() => ProductDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => ProductsRepositoryImpl(Get.find<ProductDataSourceImpl>()));
    // Get.put(ProductUsecase(Get.find<ProductsRepositoryImpl>()),
    //     permanent: true);

    // FeaturedAds Bindings
    // Get.lazyPut(() => FeaturedAdsDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => FeaturedAdsRepositoryImpl(Get.find<FeaturedAdsDataSourceImpl>()));
    // Get.put(FeaturedAdUsecase(Get.find<FeaturedAdsRepositoryImpl>()),
    //     permanent: true);

    // LatestAds Bindings
    // Get.lazyPut(() => LatestAdsDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => LatestAdsRepositoryImpl(Get.find<LatestAdsDataSourceImpl>()));
    // Get.put(LatestAdUsecase(Get.find<LatestAdsRepositoryImpl>()),
    //     permanent: true);

    // Categories Bindings
    Get.lazyPut(() => CategoriesDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CategoriesRepositoryImpl(Get.find<CategoriesDataSourceImpl>()));
    Get.put(CategoriesUsecase(Get.find<CategoriesRepositoryImpl>()),
        permanent: true);

    // Countries Bindings
    // Get.lazyPut(() => CountriesDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => CountriesRepositoryImpl(Get.find<CountriesDataSourceImpl>()));
    // Get.put(CountriesUsecase(Get.find<CountriesRepositoryImpl>()),
    //     permanent: true);

    // Notifications Bindings
    Get.lazyPut(() => NotificationsController(Get.find()));
    Get.lazyPut(() => NotificationDataSourceImpl(dio: Get.find()));
    Get.lazyPut(() =>
        NotificationsRepositoryImpl(Get.find<NotificationDataSourceImpl>()));
    Get.put(NotificationsUsecase(Get.find<NotificationsRepositoryImpl>()),
        permanent: true);






    Get.lazyPut(() => EventsController(Get.find()));
    Get.lazyPut(() => EventsDataSourceImpl(dio: Get.find()));
    Get.lazyPut(() =>
        EventsRepositoryImpl(Get.find<EventsDataSourceImpl>()));
    Get.put(EventsUsecase(Get.find<EventsRepositoryImpl>()),
        permanent: true);


    Get.lazyPut(() => EvocationsController(Get.find()));
    
    Get.lazyPut(() => EvocationsDataSourceImpl(dio: Get.find()));
    
    Get.lazyPut(
        () => EvocationsRepositoryImpl(Get.find<EvocationsDataSourceImpl>()));
    
    Get.put(EvocationsUsecase(Get.find<EvocationsRepositoryImpl>()),
        permanent: true);



    Get.lazyPut(() => EducationsController(Get.find()));
    
    Get.lazyPut(() => EducationDataSourceImpl(dio: Get.find()));
    
    Get.lazyPut(
        () => EducationRepositoryImpl(Get.find<EducationDataSourceImpl>()));
    
    Get.put(EducationUsecase(Get.find<EducationRepositoryImpl>()),
        permanent: true);



        
        




Get.lazyPut(() => SagrAuthController());
// Get.lazyPut(() => ChatController());
Get.lazyPut(() => ApiService());
Get.lazyPut(() => FirebaseMessagingService());
Get.lazyPut(() => BottomNavController());



    // Banner Binndigs
    // Get.lazyPut(() => BannerDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => BannerRepositoryImpl(Get.find<BannerDataSourceImpl>()));
    // Get.put(BannerUsecase(Get.find<BannerRepositoryImpl>()),
    //     permanent: true);   



    // Get.lazyPut(() => ConversationsController(Get.find()));
    // Get.lazyPut(() => MessagesController(Get.find()));
    // Get.lazyPut(() => ConversationDataSourceImpl(dio: Get.find()));
    // Get.lazyPut(
    //     () => ConversationsRepositoryImpl(Get.find<ConversationDataSourceImpl>()));
    // Get.put(ConversationUsecase(Get.find<ConversationsRepositoryImpl>() as ConversationsRepository),
    //     permanent: true);
  }

  headers() {
    LocaleStorage localeStorage = LocaleStorage();

    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Accepted-Language':
          localeStorage.selectedLanguage.then((value) => value),
    };
    // if user looged in append api token to header.
    // if (GetStorage().read('accessToken') != null) {
    //   headers['Authorization'] = "Bearer " + GetStorage().read('accessToken');
    // }
    if (GetStorage().read('access_token') != null) {
     

      headers['Authorization'] = "Bearer " + GetStorage().read('access_token');
      // headers['app_type'] = ;

      print(localeStorage.appType.then((value) => value));
      // headers['Authorization'] =  "Bearer 5e9833a090ee5df4aeeff5ead93f3bb38cc8aa19";
    }

    return headers;
  }

  getLang() async {
    return;
  }
}
