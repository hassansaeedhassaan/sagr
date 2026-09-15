import 'package:dio/dio.dart';
import 'package:sagr/features/evocations/data/models/evocation_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../helper/base_url.dart';
import '../../../../models/pagination_filter.dart';

abstract class EvocationsDataSource {

  Future<List<EvocationModel>> getEvocations(PaginationFilter filter);
  Future<Response> apply(Map<String, dynamic> body);
}

class EvocationsDataSourceImpl extends EvocationsDataSource {
  final Dio dio;

  EvocationsDataSourceImpl({required this.dio});

  @override
  Future<List<EvocationModel>> getEvocations(filter) async {
    var response = await dio.get('$BASEURL/evocations', queryParameters: {});

    if (response.statusCode == 200) {
      final List<EvocationModel> evocations = response.data['data']
          .map<EvocationModel>((data) => EvocationModel.fromJson(data))
          .toList();

      return evocations;
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Response> apply(Map<String, dynamic> body) async {
    try {
      return await dio.post("$BASEURL/evocations", data: body);
    } on DioException catch (e) {
      // This used to only print the error, so a rejected request (Laravel's
      // 422 with the reason in `message`) failed with nothing shown to the
      // employee. Surface the server's own message instead.
      final status = e.response?.statusCode;
      final data = e.response?.data;

      String message =
          'Could not send your permission request. Please try again.';
      if (data is Map && data['message'] is String) {
        message = data['message'] as String;
      }

      if (status == 400 || status == 422) {
        throw ValidationException(data, message: message, statusCode: status);
      }
      throw ServerException();
    }
  }
}
