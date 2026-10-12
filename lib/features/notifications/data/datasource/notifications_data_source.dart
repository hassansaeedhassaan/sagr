import 'package:dio/dio.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class NotificationsDataSource {
  Future<List<NotificationModel>> getNotificationsList(PaginationFilter filter);
  // Future<Response> payAllCommissions(String paymentMethod);
}

class NotificationDataSourceImpl extends NotificationsDataSource {
  final Dio dio;

  NotificationDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotificationsList(filter) async {
    var response = await dio.get(BASEURL + '/notifications',
        queryParameters: {
          'page': filter.page,
          'limit': filter.limit,
          'name': filter.name
        });

    final data = response.data is Map ? response.data['data'] : null;
    if (response.statusCode == 200 && data is List) {
      return data
          .whereType<Map>()
          .map((json) => NotificationModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw ServerException();
    }
  }

//   @override
//   Future<Response> payAllCommissions(String paymentMethod) async {
//     try {
//       var response = await dio
//           .get(BASEURL + "/users/commissions/all/pay-${paymentMethod}");

//       return response;
//     } on DioException catch (e) {
//       throw NotFoundException(e.response?.data);
//     } catch (e){
//     throw ServerException();
//     }


// // if(response.statusCode == 400){
// //   appLog("lkjaskd");
// // }
// // appLog(response.statusCode == 400);
// //     return  response.data;
//     // if (response.statusCode == 200) {
//     //   final List<CommissionModel> customers = response.data['data']['wallet']
//     //       .map<CommissionModel>(
//     //           (jsonPostModel) => CommissionModel.fromJson(jsonPostModel))
//     //       .toList();
//     //   return customers;
//     // } else {
//     //   throw ServerException();
//     // }
//   }
}
