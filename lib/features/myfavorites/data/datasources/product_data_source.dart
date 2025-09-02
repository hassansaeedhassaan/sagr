import 'package:dio/dio.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class FavoriteDataSource {
  Future<List<ProductModel>> getFavoriteProducts(PaginationFilter filter);
}


class FavoriteDataSourceImpl extends FavoriteDataSource {
  
  final Dio dio;

  FavoriteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getFavoriteProducts(filter) async {
    
    var response = await dio.get(BASEURL + '/users/advertisement/favourites', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    });


    print(response.data['data']['favourites']);
    if (response.statusCode == 200) {
      final List<ProductModel> products = response.data['data']['favourites']
          .map<ProductModel>(
              (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
          .toList();
      return products;
    } else {
      throw ServerException();
    }

  } 
}
