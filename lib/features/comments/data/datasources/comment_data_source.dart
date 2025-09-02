import 'package:dio/dio.dart';
import 'package:sagr/features/comments/data/models/comment_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class CommentDataSource {
  Future<List<CommentModel>> getComments(PaginationFilter filter);
  Future<Response> createComment(Map<String, dynamic> body);
  Future<Response> updateComment(Map<String, dynamic> body);
  Future<Response> delete(int adId, int commentId);
}

class CommentDataSourceImpl extends CommentDataSource {
  final Dio dio;

  CommentDataSourceImpl({required this.dio});

  @override
  Future<List<CommentModel>> getComments(filter) async {
    // var response = await dio.get(BASE_URL +'/posts?_start=${filter.page}&_limit=${filter.limit}');

    var response =
        await dio.get(BASEURL + '/advertisement/1/comments', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
    });

    if (response.statusCode == 200) {
      final List<CommentModel> products = response.data['data']
          .map<CommentModel>(
              (jsonPostModel) => CommentModel.fromJson(jsonPostModel))
          .toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> createComment(Map<String, dynamic> body) async {
    try {
      var response = await dio.post(BASEURL + '/users/advertisement/1/comments',
          data: body);
      if (response.statusCode == 200) {
        return response;
      }
    } on DioException catch (e) {
      print(e.response?.statusCode);

      throw ServerException();
    }

    throw ServerException();
  }

  @override
  Future<Response> updateComment(Map<String, dynamic> body) async {

    print("👇👇👇👇👇👇👇👇👇👇");
    print(body);
    print("👆👆👆👆👆👆👆👆👆👆");
    try {
      var response = await dio.put(BASEURL + '/users/advertisement/${body['adId']}/comments/${body['commentId']}',
          data: body);
      if (response.statusCode == 200) {
        return response;
      }
    } on DioException catch (e) {

      print(e);
      print(e.response?.statusCode);

      throw ServerException();
    }

    throw ServerException();
  }

  @override
  Future<Response> delete(int adId, int commentId) async {
    try {
      var response = await dio.delete(BASEURL +
          '/users/advertisement/' +
          adId.toString() +
          '/comments/' +
          commentId.toString());
      if (response.statusCode == 200) {
        return response;
      }
    } on DioException catch (e) {
      print(e.response?.data['error']);
      print(e.response?.statusCode);

      throw ServerException();
    }

    throw ServerException();
  }
}
