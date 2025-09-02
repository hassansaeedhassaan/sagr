import 'package:dio/dio.dart';


import '../exceptions/rest_exception.dart';
import '../features/products/data/models/product_model.dart';
import '../helper/base_url.dart';
import '../models/pagination_filter.dart';


class ProductRepository {
  final Dio _dio;

  ProductRepository(
    this._dio,
  );

  // Future<List<UserModel>> findAll(PaginationFilter filter) {
  //   return _dio.get('/users', queryParameters: {
  //     'page': filter.page,
  //     'limit': filter.limit,
  //   }).then(
  //     (res) => res?.data
  //         ?.map<UserModel>(
  //           (u) => UserModel.fromMap(u),
  //         )
  //         ?.toList(),
  //   );
  // }

  Future<List<ProductModel>> findAll(PaginationFilter filter) {
    return _dio.get(BASEURL + '/v1/products',
        queryParameters: {'page': filter.page, 'limit': filter.limit}).then(
      (res) => res.data['data']
          ?.map<ProductModel>(
            (u) => ProductModel.fromJson(u),
          )
          ?.toList(),
    );
  }

  Future<List<ProductModel>> findProducts(PaginationFilter filter, int id) {
    return _dio.get(BASEURL+ "/v1/products", queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    }).then(
      (res) {
       return  res.data['data']
          ?.map<ProductModel>(
            (u) => ProductModel.fromJson(u),
          )
          ?.toList();
      } ,
    );
  }

  Future<List<ProductModel>> findLatest(PaginationFilter filter) {
    return _dio.get(BASEURL + '/v1/products', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    }).then(
      (res) => res.data['data']
          ?.map<ProductModel>(
            (u) => ProductModel.fromJson(u),
          )
          ?.toList(),
    );
  }

  Future<List<ProductModel>> offerProducts(PaginationFilter filter) {
    return _dio.get(BASEURL + '/v1/products', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    }).then(
      (res) => res.data['data']
          ?.map<ProductModel>(
            (u) => ProductModel.fromJson(u),
          )
          ?.toList(),
    );
  }

  Future<List<ProductModel>> findRelatedProducts({required productId}) {
    return _dio.get("/v1/product/related/$productId/products").then(
          (res) => res.data['data']
              ?.map<ProductModel>(
                (u) => ProductModel.fromJson(u),
              )
              ?.toList(),
        );
  }


   Future<Map<String, dynamic>> generateToken() async {
    try {
      Map<String, dynamic> data = {
        'client_id': 'shopping_oauth_client',
        'client_secret': 'shopping_oauth_secret'
      };
      final response = await _dio.post(BASEURL + "/rest/oauth2/token/client_credentials", data: data);

      print("Start Here");

      print(response);
      print("End Here");
      
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
