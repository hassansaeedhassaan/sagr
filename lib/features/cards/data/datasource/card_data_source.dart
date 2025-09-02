import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class CardDataSource {
  Future<List<CardModel>> getCards(PaginationFilter filter);
  Future<Response> addCard(String paymentMethodId);
}

class CardDataSourceImpl extends CardDataSource {
  final Dio dio;

  CardDataSourceImpl({required this.dio});

  @override
  Future<List<CardModel>> getCards(filter) async {
    var response = await dio.get(BASEURL + '/users/cards');

    if (response.statusCode == 200) {
      // print(response.data['data'][0]['cards']);

      // throw RestException("kj");
      GetStorage().write("stirp_intent", response.data['data'][0]['intent']);
      final List<CardModel> cards = response.data['data'][0]['cards']
          .map<CardModel>((jsonPostModel) => CardModel.fromJson(jsonPostModel))
          .toList();
      return cards;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> addCard(String paymentMethodId) async {
    try {

Map<String, dynamic> body = {'payment_method': paymentMethodId};

      var response = await dio.post(BASEURL + "/users/cards", data: body);
      
      return response;
    } on DioException catch (e) {

print(e.response?.data);
        if(e.response?.statusCode == 422){
          throw ValidationException(e.response?.data);
        }

      throw NotFoundException(e.response?.data);
    } catch (e) {
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
