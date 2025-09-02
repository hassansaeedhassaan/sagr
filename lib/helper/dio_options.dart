import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
// import '../data/constants.dart';
// import '../utilities/local_storage/locale_storage.dart';

class DioOptions {
  static initDioOptions() async {
    BaseOptions options = BaseOptions(
        connectTimeout: Duration(minutes: 2),
        receiveTimeout: Duration(minutes: 2),
        sendTimeout: Duration(minutes: 2),
        method: "POST",
        headers: await headers());
    return options;
  }

  static headers() async {
    // LocaleStorage localeStorage = LocaleStorage();
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Accepted-Language': GetStorage().read("lang")
    };
    // if user logged in append api token to header.
    headers['Authorization'] = "Bearer ${GetStorage().read("access_token")}";
    // headers['Authorization'] = "Bearer ${await localeStorage.getAccessToken}";
  
    return headers;
  }
}
