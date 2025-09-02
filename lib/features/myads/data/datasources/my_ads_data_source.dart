import 'package:dio/dio.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class MyAdsDataSource {
  Future<List<ProductModel>> getMyAds(PaginationFilter filter);
  getProductInfo(int productId) {}
}


class MyAdsDataSourceImpl extends MyAdsDataSource {
  
  final Dio dio;

  MyAdsDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getMyAds(filter) async {
    
    var response = await dio.get(BASEURL + '/users/advertisement', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    });

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
    // var response = await dio.get(BASE_URL +'/posts?_start=${filter.page}&_limit=${filter.limit}');

    var response = await dio.get(BASEURL + '/users/advertisement/$productId/show');

    if (response.statusCode == 200) {
      final ProductModel product =
          ProductModel.fromJson(response.data['data']['advertisement']);
      return product;
    } else {
      throw ServerException();
    }
  }

}
