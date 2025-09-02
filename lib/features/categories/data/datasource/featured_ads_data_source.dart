import 'package:dio/dio.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class CategoriesDataSource {

  Future<List<CategoryModel>> getParentCategories(PaginationFilter filter);
  Future<List<CategoryModel>> getSubChilds(PaginationFilter filter, categoryId);

}

class CategoriesDataSourceImpl extends CategoriesDataSource {
  final Dio dio;

  CategoriesDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getParentCategories(filter) async {
    var response = await dio.get(BASEURL + '/categories', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
      'name': filter.name
    });



    if (response.statusCode == 200) {
      final List<CategoryModel> customers = response.data['data']['categories']
          .map<CategoryModel>(
              (jsonPostModel) => CategoryModel.fromJson(jsonPostModel))
          .toList();
      return customers;
    } else {
      throw ServerException();
    }
  }
  
  @override
  Future<List<CategoryModel>> getSubChilds(PaginationFilter filter, categoryId) async{
   var response = await dio.get(BASEURL + '/categories/$categoryId', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
      'name': filter.name
    });



    if (response.statusCode == 200) {
      final List<CategoryModel> customers = response.data['data']['categories']
          .map<CategoryModel>(
              (jsonPostModel) => CategoryModel.fromJson(jsonPostModel))
          .toList();
      return customers;
    } else {
      throw ServerException();
    }
  }


  
}
