import 'package:dio/dio.dart';

import '../exceptions/rest_exception.dart';
import '../helper/base_url.dart';


class ResetPasswordRepository {
  final Dio _dio;
  ResetPasswordRepository(this._dio);

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.post(BASEURL + "/v1/reset/password", data: body);
      return  Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print(e);
      String message = e.response?.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }
}
