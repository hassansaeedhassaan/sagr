import 'package:dio/dio.dart' as dioHttp;
import 'package:flutter/material.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';
import 'package:get/get.dart';

import 'package:dio/src/form_data.dart' as formData;
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../core/error/exceptions.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts(PaginationFilter filter);
  getProductInfo(int productId) {}
  Future<List<ProductModel>> getRelatedAds(productId);
  Future<ProductModel> createAd(
      Map<String, dynamic> body, BuildContext context);
  Future<ProductModel> updateAd(Map<String, dynamic> body);
  Future<dioHttp.Response> deleteAd(int adId, int mediaId);
}

class ProductDataSourceImpl extends ProductDataSource {
  final dioHttp.Dio dio;

  ProductDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts(filter) async {
    printInfo(info: "_findItems $filter");

    // var response = await dio.get(BASE_URL +'/posts?_start=${filter.page}&_limit=${filter.limit}');

    var response =
        await dio.get(BASEURL + '/users/advertisement', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    });

    print(response);
    if (response.statusCode == 200) {
      final List<ProductModel> products = response.data['data']
          .map<ProductModel>(
              (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
          .toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  Future<ProductModel> getProductInfo(productId) async {
    var response = await dio.get(BASEURL + '/advertisement/$productId/show');

    if (response.statusCode == 200) {
      final ProductModel product =
          ProductModel.fromJson(response.data['data']['advertisement']);
      return product;
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<List<ProductModel>> getProducts() async {
  //   final response = await dio.get(BASE_URL + "/posts");

  //   if (response.statusCode == 200) {
  //     final List decodedJson = json.decode(response.data) as List;
  //     final List<ProductModel> productModels = decodedJson
  //         .map<ProductModel>(
  //             (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
  //         .toList();

  //     return productModels;
  //   } else {
  //     throw ServerException();
  //   }

  // }

  @override
  Future<List<ProductModel>> getRelatedAds(filter) async {
    var response = await dio.get(BASEURL + '/advertisement/1/related');

    print(response);
    if (response.statusCode == 200) {
      final List<ProductModel> products = response.data['data']
          .map<ProductModel>(
              (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
          .toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createAd(
      Map<String, dynamic> body, BuildContext context) async {
    try {
      // prepare to upload form
      dio.options.contentType = "multipart/form-data";

      // set image append to formData
      final multiPartFile = await dioHttp.MultipartFile.fromFile(
        body['image'],
        filename: body['image'].split('/').last,
      );

      List multiPartFiles = [];

      for (var file in body['images']) {
        multiPartFiles.add(await dioHttp.MultipartFile.fromFile(
          file,
          filename: file.split('/').last,
        ));
      }

      List multiPartVideos = [];

      for (var video in body['videos']) {
        multiPartVideos.add(await dioHttp.MultipartFile.fromFile(
          video,
          filename: video.split('/').last,
        ));
      }

//        for (int i = 0; i <= body['images'].length; i++) {
// multiPartFiles[i] =  await dioHttp.MultipartFile.fromFile(
//           body['images'][i],
//           filename: body['images'][i].split('/').last,
//         );
//        }

// print(body['images'].map((item)  =>  dioHttp.MultipartFile.fromFile(item,
//           filename: item.split('/').last))
//       .toList());

      formData.FormData preparedFormData = formData.FormData.fromMap({
        'name': body['name'],
        'description': body['description'],
        'status': body['status'],
        'phone_number': body['phone_number'],
        'whatsapp_number': body['whatsapp_number'],
        'category_id': body['category_id'],
        'type': body['type'],
        'price_type': body['price_type'] == "Fixed Price" ? 'fixed' : 'fixed',
        'price': body['price'],
        'currency': "EGP",
        'nationality_id': body['nationality_id'],
        'state_id': body['state_id'],
        'city_id': body['city_id'],
        'latitude': body['latitude'],
        'longitude': body['longitude'],
        "image": multiPartFile,
        "images[]": multiPartFiles.toList(),
        'videos[]': multiPartVideos.toList(),
        'is_negotiable': 0
      });

      // print(preparedFormData.files);

      // final response = await _dio.post(BASEURL + "/v1/settings", data: f);
      // return response;
      // }

      ProgressDialog pd = ProgressDialog(context: context);
      ProgressDialog pd2 = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'File Uploading...');
      // throw ServerException();
      var response = await dio.post(
        BASEURL + '/users/advertisement',
        data: preparedFormData,

        //     onReceiveProgress: (int sentBytes, int totalBytes) {

        //       print(int.tryParse((sentBytes / totalBytes).toString()));
        //   double progressPercent = sentBytes / totalBytes * 100;
        //   print(progressPercent);
        //   // pd.update(value: int.tryParse(progressPercent.toString()));
        //   print("Progress: $progressPercent %");
        // pd.update(value: int.tryParse(progressPercent.toString()));

        //   // SharedData().showMessage(context, message: progressPercent.toString());

        //   if (progressPercent == 100) {

        //   }
        // },
        onSendProgress: (int sentBytes, int totalBytes) {
          int progressPercent = (sentBytes / totalBytes * 100).toInt();

          // SharedData().showMessage(context, message: progressPercent.toString());
          pd.update(value: progressPercent);
          print("Progress: $progressPercent %");
          print(progressPercent);
          if (progressPercent == 100) {
            pd.close();

            pd2.show(max: 100, msg: 'Preparing Saving data...');
          }
        },

        //    onSendProgress: (int sent, int total) {
        //   print('$sent $total');
        // },
      );

      pd2.close();

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['data']['advertisement']);
      }
    } on dioHttp.DioException catch (e) {
      print(e.response?.statusCode);
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
  Future<ProductModel> updateAd(Map<String, dynamic> body) async {
    try {
// print(body);
// throw ServerException();

      // prepare to upload form
      dio.options.contentType = "multipart/form-data";

      // set image append to formData

      final multiPartFile = await dioHttp.MultipartFile.fromFile(
        body['image'],
        filename: body['image'].split('/').last,
      );

      List multiPartFiles = [];

      if (body['images'].length > 0)
        for (var file in body['images']) {
          multiPartFiles.add(await dioHttp.MultipartFile.fromFile(
            file['path'],
            filename: file['path'].split('/').last,
          ));
        }

      // List multiPartVideos = [];
      // if(body['videos'].length > 0)
      // for (var video in body['videos']) {
      //   multiPartVideos.add(await dioHttp.MultipartFile.fromFile(
      //     video,
      //     filename: video.split('/').last,
      //   ));
      // }

      Map<String, dynamic> formBody = {
        'name': body['name'],
        'description': body['description'],
        'status': body['status'],
        'phone_number': body['phone'],
        'whatsapp_number': body['whatsapp'],
        'category_id': body['category_id'],
        'type': body['type'],
        'price_type': body['price_type'] == "Fixed Price" ? 'fixed' : 'fixed',
        'price': body['price'],
        'min_price': body['minPrice'],
        'max_price': body['maxPrice'],
        'currency': "EGP",
        'nationality_id': body['country_id'],
        'state_id': body['state_id'],
        'city_id': body['city_id'],
        'latitude': body['latitude'],
        'longitude': body['longitude'],
        'is_sold': body['isSold'] == true ? 1 : 0,
        "image": multiPartFile,
        "images[]": multiPartFiles.toList(),
        // 'videos[]': multiPartVideos.toList(),
        'is_negotiable': 0
      };

      formData.FormData preparedFormData = formData.FormData.fromMap(formBody);

      var response = await dio.post(
          BASEURL + '/users/advertisement/${body['id']}/update',
          data: preparedFormData);

      return ProductModel.fromJson(response.data['data']['advertisement']);
    } on dioHttp.DioException catch (e) {
      print(e.response?.statusCode);
      // print(e.response?.data);

      throw ValidationException(e.response?.data);
    }

    // if (response.statusCode == 200) {
    //   return response;
    //   // return CustomerModel.fromJson(response.data['data']);
    // } else {

    // }
  }

  @override
  Future<dioHttp.Response> deleteAd(int adId, int mediaId) async {
    return await dio
        .delete(BASEURL + '/users/advertisement/$adId/delete/$mediaId/media');
  }
}
