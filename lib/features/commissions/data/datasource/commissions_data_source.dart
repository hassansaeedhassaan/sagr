import 'package:dio/dio.dart';
import 'package:sagr/features/commissions/data/models/commission_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class CommissionsDataSource {
  Future<List<CommissionModel>> getCommissions(PaginationFilter filter);
  Future<Response> payAllCommissions(String paymentMethod);
}

class CommissionDataSourceImpl extends CommissionsDataSource {
  final Dio dio;

  CommissionDataSourceImpl({required this.dio});

  @override
  Future<List<CommissionModel>> getCommissions(filter) async {
    var response = await dio.get(BASEURL + '/users/commissions',
        queryParameters: {
          'page': filter.page,
          'limit': filter.limit,
          'name': filter.name
        });

    if (response.statusCode == 200) {
      final List<CommissionModel> customers = response.data['data']['wallet']
          .map<CommissionModel>(
              (jsonPostModel) => CommissionModel.fromJson(jsonPostModel))
          .toList();
      return customers;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> payAllCommissions(String paymentMethod) async {
    try {
      var response = await dio
          .get(BASEURL + "/users/commissions/all/pay-${paymentMethod}");

      return response;
    } on DioException catch (e) {
      throw NotFoundException(e.response?.data);
    } catch (e){
    throw ServerException();
    }


// if(response.statusCode == 400){
//   print("lkjaskd");
// }
// print(response.statusCode == 400);
//     return  response.data;
    // if (response.statusCode == 200) {
    //   final List<CommissionModel> customers = response.data['data']['wallet']
    //       .map<CommissionModel>(
    //           (jsonPostModel) => CommissionModel.fromJson(jsonPostModel))
    //       .toList();
    //   return customers;
    // } else {
    //   throw ServerException();
    // }
  }
}
