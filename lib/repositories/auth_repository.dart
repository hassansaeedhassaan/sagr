import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as formData;

import 'package:get_storage/get_storage.dart';
import 'package:sagr/models/country_model.dart';

import '../exceptions/rest_exception.dart';
import '../helper/base_url.dart';
import '../models/customer_model.dart';

final verification = BASEURL + "/users/auth/login";

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Response> login(Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.post("$BASEURL/auth/login", data: body);

      // if (response.data['data']['access_token'] != "") {
      //   _dio.options.headers["Authorization"] =
      //       "Bearer ${response.data['data']['access_token']['token']}";
      // }



      return response;
    } on DioException catch (e) {
      print(e);
      String message = 'phone_or_password_incorrect';

      if (e.response?.statusCode == 403) {
        message = e.response?.data;
      }

      throw RestException(message);
    }
  }

  // Future<void> login2() {
  //   return _dio.post('/users').then((res) => res.data?.map<UserModel>(
  //         (u) => UserModel.fromMap(u),
  //       ));
  // }

  Future<Map<String, dynamic>> registerphone(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(BASEURL + "/auth/register", data: body);
      return Map<String, dynamic>.from(response.data);
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }

  Future<Map<String, dynamic>> RegisterComplete(
      Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.post(BASEURL + "/v1/register/complete", data: body);

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }

  Future<Map<String, dynamic>> verificationCode(
      Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.post(BASEURL + "/v1/verification", data: body);

      return Map<String, dynamic>.from(response.data);
    } on DioError catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }



  Future<CustomerModel> fetchUser() async {
    try {

      _dio.options.headers["Authorization"] =
          "Bearer ${GetStorage().read('access_token')}";

    

      final response = await _dio.get("$BASEURL/auth/profile");



    


      if (GetStorage().read('access_token') != null) {
        return CustomerModel.fromMap(response.data);
      }

      return CustomerModel.fromMap({});
    } on DioException catch (e) {
      String message = 'Erro ao autenticar usuário';
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      } else if (e.response?.statusCode == 400) {
        message = "ERROR 400.";
      }
      return throw RestException(message);
    }
  }

  Future<List<CountryModel>> countries() {
    try {
      return _dio.get(BASEURL + '/nationalities').then(
            (res) => res.data['data']['nationalities']
                ?.map<CountryModel>(
                  (u) => CountryModel.fromMap(u),
                )
                ?.toList(),
          );
    } on DioException catch (e) {
      String message = 'Erro ao autenticar usuário';
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      } else if (e.response?.statusCode == 400) {
        message = "ERROR 400.";
      } else if (e.response?.statusCode == 404) {
        message = "Error 404.";
      }

      return throw RestException(message);
    }
  }

  Future<Response> changePassword(body) async {
    try {
      final response =
          await _dio.post(BASEURL + "/users/password/change", data: body);

      return response;
    } on DioException catch (e) {
      String message = 'phone_or_password_incorrect';
      if (e.response?.statusCode == 403) {
        message = e.response?.data;
      }

      throw RestException(message);
    }
  }

  Future<Response> updateData(body) async {
    try {
      // await _dio.post("https://testing.wrraqoon.com/api/rest/logout").then((value) {});

      // formData.FormData f = formData.FormData.fromMap(body);

      // prepare to upload form

      // prepare to upload form
      _dio.options.contentType = "multipart/form-data";

      // set image append to formData

      Map<String, dynamic> formBody = {
        'name': body['name'],
        'email': body['email'],
        'phone': body['phone'],
        'nationality': body['nationality'],
      };

      if (body['image'] != "") {
        final multiPartFile = await MultipartFile.fromFile(
          body['image'],
          filename: body['image'].split('/').last,
        );

        formBody = {...formBody, 'image': multiPartFile};
      }

      formData.FormData preparedFormData = formData.FormData.fromMap(formBody);

      final response =
          await _dio.post(BASEURL + "/users/profile", data: preparedFormData);

      return response;
    } on DioException catch (e) {
      String message = 'phone_or_password_incorrect';
      if (e.response?.statusCode == 403) {
        message = e.response?.data;
      }

      throw RestException(message);
    }
  }

  Future<Response> deleteAccount() async {
    try {
      final response = await _dio.delete(BASEURL + "/users/profile");

      return response;
    } on DioException catch (e) {
      String message = 'Something went wrong!';
      if (e.response?.statusCode == 403) {
        message = e.response?.data;
      }

      throw RestException(message);
    }
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    final isValid = status != null && status >= 200 && status < 300;
    if (!isValid) {
      throw DioException.badResponse(
        statusCode: status!,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    super.onResponse(response, handler);
  }
}