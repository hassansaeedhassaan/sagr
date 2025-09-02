import 'package:dio/dio.dart';
import 'package:sagr/features/wallet/data/models/wallet_model.dart';
import 'package:sagr/helper/base_url.dart';

import '../../../../core/error/exceptions.dart';

abstract class WalletDataSource {
  Future<WalletModel> getWallet();
 Future<Response> chargeWallet(Map<String, dynamic> body);

}

class WalletDataSourceImpl extends WalletDataSource {
  final Dio dio;

  WalletDataSourceImpl({required this.dio});

  @override
  Future<WalletModel> getWallet() async {
    var response = await dio.get(BASEURL + '/users/wallet/show');

    if (response.statusCode == 200) {
      return WalletModel.fromJson(response.data['data']['wallet']);
  
    } else {
      throw ServerException();
    }
    
  }

  @override
  Future<Response> chargeWallet(Map<String, dynamic> body) async {
    try {
      var response = await dio
          .post(BASEURL + "/users/wallet/recharge", data: body);
      return response;
    } on DioException catch (e) {
      throw NotFoundException(e.response?.data);
    } catch (e){
    throw ServerException();
    }
  }
}
