import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioHttp;
import 'package:dio/src/form_data.dart' as formData;
import 'package:flutter/foundation.dart';

import 'package:sagr/helper/base_url.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../models/customer_model.dart';
import 'dart:developer' as developer;

abstract class AuthDataSource {
  Future<CustomerModel> createAccount(Map<String, dynamic> body);
  Future<CustomerModel> completeAccount(Map<String, dynamic> body);
  Future<CustomerModel> updateProfile(Map<String, dynamic> body);
}

class AuthDataSourceImpl extends AuthDataSource {
  final Dio dio;

  AuthDataSourceImpl({required this.dio});

  // @override
  // Future<CustomerModel> createAccount(Map<String, dynamic> body) async {
  //   var response = await dio.post(BASEURL + '/users/auth/signup', data: body);
  //   if (response.statusCode == 200) {
  //     return CustomerModel.fromJson(response.data['data']);
  //   } else {
  //     throw ServerException();
  //   }
  // }

  @override
  Future<CustomerModel> createAccount(Map<String, dynamic> body) async {
    try {
      // prepare to upload form
      // dio.options.contentType = "multipart/form-data";

      // // set image append to formData
      // final MultipartFile? multiPartFile;

      // final MultipartFile? cvMultiPartFile;

      // final MultipartFile? ibanMultiPartFile;

      // multiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['image'],
      //   filename: body['image'].split('/').last,
      // );

      // body['image'] = multiPartFile;

      // cvMultiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['emp_cv'],
      //   filename: body['emp_cv'].split('/').last,
      // );

      // body['emp_cv'] = cvMultiPartFile;

      // ibanMultiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['iban_file'],
      //   filename: body['iban_file'].split('/').last,
      // );

      // body['iban_file'] = ibanMultiPartFile;

      formData.FormData preparedFormData = formData.FormData.fromMap(body);

      var response =
          await dio.post('$BASEURL/auth/signup', data: preparedFormData);

      // if (response.data['status'] == 200) {

      return CustomerModel.fromJson(response.data['data']);
      // }
    } on DioException catch (e) {
      // print(e.response?.statusCode);
      // print(e.response?.data);

      throw ValidationException(e.response?.data);
    }

    throw ServerException();

    // if (response.statusCode == 200) {
    //   return response;
    //   // return CustomerModel.fromJson(response.data['data']);
    // } else {

    // }
  }

  @override
  Future<CustomerModel> completeAccount(Map<String, dynamic> body) async {
    try {
      // prepare to upload form
      dio.options.contentType = "multipart/form-data";

      // set image append to formData
      final MultipartFile? multiPartFile;

      final MultipartFile? cvMultiPartFile;

      final MultipartFile? ibanMultiPartFile;

      multiPartFile = await dioHttp.MultipartFile.fromFile(
        body['image'],
        filename: body['image'].split('/').last,
      );

      body['image'] = multiPartFile;

      cvMultiPartFile = await dioHttp.MultipartFile.fromFile(
        body['emp_cv'],
        filename: body['emp_cv'].split('/').last,
      );

      body['emp_cv'] = cvMultiPartFile;

      ibanMultiPartFile = await dioHttp.MultipartFile.fromFile(
        body['iban_file'],
        filename: body['iban_file'].split('/').last,
      );

      body['iban_file'] = ibanMultiPartFile;

      formData.FormData preparedFormData = formData.FormData.fromMap(body);

      var response = await dio.post('$BASEURL/auth/complete-account',
          data: preparedFormData);

      print("Here Data Source Auth Complete Account 🔥🔥🔥🔥🔥");
      // if (response.data['status'] == 200) {

      return CustomerModel.fromJson(response.data['data']);
      // }
    } on DioException catch (e) {
      // print(e.response?.statusCode);
      // print(e.response?.data);

      // throw ValidationException(e.response?.data);

      final validationException = ValidationException(
        e.response?.data,
        message: 'API validation failed',
        statusCode: e.response?.statusCode,
      );

      validationException.logToDebug(tag: 'ApiError');
      throw validationException;
    }

    // if (response.statusCode == 200) {
    //   return response;
    //   // return CustomerModel.fromJson(response.data['data']);
    // } else {

    // }
  }

  @override
  Future<CustomerModel> updateProfile(Map<String, dynamic> body) async {
    try {
      // prepare to upload form
      dio.options.contentType = "multipart/form-data";

      // set image append to formData
      final MultipartFile? multiPartFile;

      final MultipartFile? cvMultiPartFile;

      final MultipartFile? ibanMultiPartFile;

      // multiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['image'],
      //   filename: body['image'].split('/').last,
      // );

      // body['image'] = multiPartFile;


      if (body.containsKey('image') && body['image'] != null) {
        final String filePath = body['image'] as String;

        if (filePath.isNotEmpty) {
          multiPartFile = await dioHttp.MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
          body['image'] = multiPartFile;
        } else {
          body.remove('image');
        }
      } else {
        body.remove('image');
      }

      // cvMultiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['emp_cv'],
      //   filename: body['emp_cv'].split('/').last,
      // );

      // body['emp_cv'] = cvMultiPartFile;




if (body.containsKey('emp_cv') && body['emp_cv'] != null) {
        final String filePath = body['emp_cv'] as String;

        if (filePath.isNotEmpty) {
          cvMultiPartFile = await dioHttp.MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
          body['emp_cv'] = cvMultiPartFile;
        } else {
          body.remove('emp_cv');
        }
      } else {
        body.remove('emp_cv');
      }

      // ibanMultiPartFile = await dioHttp.MultipartFile.fromFile(
      //   body['iban_file'],
      //   filename: body['iban_file'].split('/').last,
      // );

      // body['iban_file'] = ibanMultiPartFile;

      if (body.containsKey('iban_file') && body['iban_file'] != null) {
        final String filePath = body['iban_file'] as String;

        if (filePath.isNotEmpty) {
          ibanMultiPartFile = await dioHttp.MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
          body['iban_file'] = ibanMultiPartFile;
        } else {
          body.remove('iban_file');
        }
      } else {
        body.remove('iban_file');
      }

      formData.FormData preparedFormData = formData.FormData.fromMap(body);

      var response = await dio.post('$BASEURL/auth/update-account',
          data: preparedFormData);

      print("Here Data Source Auth Complete Account 🔥🔥🔥🔥🔥");
      // if (response.data['status'] == 200) {

      return CustomerModel.fromJson(response.data['data']);
      // }
    } on DioException catch (e) {
      // print(e.response?.statusCode);
      // print(e.response?.data);

      // throw ValidationException(e.response?.data);

      final validationException = ValidationException(
        e.response?.data,
        message: 'API validation failed',
        statusCode: e.response?.statusCode,
      );

      validationException.logToDebug(tag: 'ApiError');
      throw validationException;
    }

    // if (response.statusCode == 200) {
    //   return response;
    //   // return CustomerModel.fromJson(response.data['data']);
    // } else {

    // }
  }
}

extension ValidationExceptionLogging on ValidationException {
  void logToDebug({String? tag}) {
    final logTag = tag ?? 'ValidationException';

    // Using dart:developer
    developer.log(
      getFormattedDebugInfo(),
      name: logTag,
      level: 1000,
      error: this,
    );

    // Also print to debug console in debug mode
    if (kDebugMode) {
      debugPrint('\n${getFormattedDebugInfo()}');
    }
  }
}
