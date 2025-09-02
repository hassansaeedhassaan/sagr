
import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;

import '../exceptions/rest_exception.dart';
import '../helper/base_url.dart';
import '../models/user_model.dart';



final verification = BASEURL + "/register";

class ChangePasswordRepository {
  final Dio _dio;

  ChangePasswordRepository(this._dio);


  Future<Response> changePassword(Map<String, dynamic> body) async {
    try {
      // await _dio.post("https://testing.wrraqoon.com/api/rest/logout").then((value) {});

      // formData.FormData f =
      //     formData.FormData.fromMap({"phone": phone, "password": password});
          
      // _dio.options.headers["authorization"] =
      //     "Bearer ${GetStorage().read('access_token')}";
      final response = await _dio.post(BASEURL + "/auth/profile/changePassword", data: body);


      
      return response;
    } on DioException catch (e) {
   
      String message = 'phone_or_password_incorrect'.tr;
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
      final response = await _dio.post(BASEURL+"/v1/register", data: body);
      return  Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }


   Future<Map<String, dynamic>> RegisterComplete(Map<String, dynamic> body) async {

    try {
      final response = await _dio.post(BASEURL+"/v1/register/complete", data: body);


      return  Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }





   Future<Map<String, dynamic>> verificationCode(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(BASEURL+"/v1/verification", data: body);

      return  Map<String, dynamic>.from(response.data);

    } on DioException catch (e) {
      String message = e.response!.data['message'];
      if (e.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }
      throw RestException(message);
    }
  }




  Future<void> logout() {
    return _dio
        .post('https://testing.wrraqoon.com/api/rest/logout')
        .then((res) {
      print("Logged out");
    });
  }

  fetchUser() async {
    try {
      final response = await _dio.get(BASEURL + "/auth/profile");
      return UserModel.fromMap(response.data);
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
}


// = تعريف المزاد 
// - شرح المزاد
// - المحافظة + المدينة
// - الحالة ( قادم - جاري - منتهي)
// - نوع المزاد  (زمني - حضوري - افتراضي)
// - موقع المزاد (اذا كان حضوري)
// - التاريخ (هجري- ميلادي)
// - الساعة (عداد تناقص)
// - عدد العقارات (من قائمة العقارات)
// - العربون (رقم - صفر = التفاصيل بالداخل) ابتدا من 
// - الصور
// - البروشور
// - الشروط
// - شركة المزاد (بيانات شركة المزاد)


// = الادمن

// = شركات المزاد
// - العقارات (لكل شركة لها عقاراتها)
// - بيانات شركة المزاد (شعار - تواصل - ...)

// = المستخدم العادي (المزايد)

// = العقار
// - حالة العقار (غير مباع - مباع)
// - وصف العقار
// - نوع العقار
// - المساحة
// - الاستخدام (سكني - تجاري - ...)
// - العربون
// - الصور
// - شمالا
// - جنوبا
// - شرقا
// - غربا
// - رقم الصك
// - تاريخ الصك
// - جوجل ماب
// - المدينة
// - الحي
// -رقم المخطط
// - رقم القطعة
