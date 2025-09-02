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
      final response = await dio
          .post("$BASEURL/evocations", data: body);

      return response;
    } on DioException catch (e) {
      // كل أخطاء Dio بتيجي هنا
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Connection Timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        print('Send Timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('Receive Timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        // في حالة السيرفر رجّع استجابة بخطأ (مثلاً 400 أو 500)
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        print('Server error: $statusCode - $data');
      } else if (e.type == DioExceptionType.cancel) {
        print('Request was cancelled');
      } else if (e.type == DioExceptionType.unknown) {
        print('Unknown error: ${e.message}');
      } else {
        print('Other Dio error: ${e.message}');
      }
    } catch (e) {
      // أي خطأ ثاني غير Dio
      print('Unexpected error: $e');
    }

    throw ServerException();

  
  }
}


