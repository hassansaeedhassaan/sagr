import 'package:dio/dio.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/helper/base_url.dart';

import '../../../../core/error/exceptions.dart';

abstract class MaritalStatusDataSource {
  Future<List<MaritalStatusModel>> getMaritalStatus();


}

class MaritalStatusDataSourceImpl extends MaritalStatusDataSource {
  
  final Dio dio;

  MaritalStatusDataSourceImpl({required this.dio});

  @override
  Future<List<MaritalStatusModel>> getMaritalStatus() async{
     var response = await dio.get('$BASEURL/maritalstatus');

    if (response.statusCode == 200) {

       final List<MaritalStatusModel> maritalStatus = response.data
          .map<MaritalStatusModel>(
              (data) => MaritalStatusModel.fromJson(data))
          .toList();
      return maritalStatus;

    } else {
      throw ServerException();
    }
  }


  
}
