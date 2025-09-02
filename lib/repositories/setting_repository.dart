import 'package:dio/dio.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/setting.dart';

import 'package:dio/src/form_data.dart' as formData;

class SettingRepository {
  Dio _dio;

  SettingRepository( 
    this._dio,
  );

  Future<Setting> getSettings(page) {
    return _dio
        .get(BASEURL + '/static-pages/$page')
        .then((res) => Setting.fromMap(res.data['data']['page']));
  }

  Future<Response> saveSettings(body) async {
    formData.FormData f = formData.FormData.fromMap(body);
    final response = await _dio.post(BASEURL + "/v1/settings", data: f);
    return response;
  }

  Future<Response> deleteSlider(body) async {
    final response = await _dio.post(BASEURL + "/v1/sliders/delete", data: body);
    return response;
  }

  Future<Response> uploadSlide(body) async {
    // prepare to upload form
    _dio.options.contentType = "multipart/form-data";

    // set image append to formData
    final multiPartFile = await MultipartFile.fromFile(
      body,
      filename: body.split('/').last,
    );

    formData.FormData f = formData.FormData.fromMap({
      "image": multiPartFile,
    });

    final response = await _dio.post(BASEURL + "/v1/settings", data: f);
    return response;
  }
}
