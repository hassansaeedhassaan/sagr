import 'package:dio/dio.dart';

import '../exceptions/rest_exception.dart';
import '../helper/base_url.dart';

class ForgotPasswordRepository {
  final Dio _dio;
  ForgotPasswordRepository(this._dio);

  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    Map<String, dynamic> body = {'phone': phone, 'type': "customer"};
    try {
      final response =
          await _dio.post(BASEURL + "/v1/forgot/password", data: body);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      String message = e.response?.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }

  Future<Map<String, dynamic>> verifyCode(String code) async {
    try {
      final response = await _dio
          .post(BASEURL + "/v1/verification", data: {'verify_code': code});
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      String message = e.response?.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }
}
