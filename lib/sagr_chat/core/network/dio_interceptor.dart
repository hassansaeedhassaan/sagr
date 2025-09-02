import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = getx.Get.find<AuthService>();
    final token = authService.token.value;
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired, logout user
      final authService = getx.Get.find<AuthService>();
      authService.logout();
      getx.Get.offAllNamed('/login');
    }
    super.onError(err, handler);
  }
}