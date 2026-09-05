import 'package:dio/dio.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import 'package:sagr/helper/base_url.dart';
import '../../../../core/error/exceptions.dart';

abstract class NationalitiesDataSource {
  Future<List<NationalityModel>> getNationalities();
}

class NationalitiesDataSourceImpl extends NationalitiesDataSource {
  
  final Dio dio;

  NationalitiesDataSourceImpl({required this.dio});

  @override
  Future<List<NationalityModel>> getNationalities() async {
    
    // Request For Jobs Api
    var response = await dio.get('$BASEURL/nationalities');

    if (response.statusCode == 200) {
      final List<NationalityModel> nationalities = response.data['data']
          .map<NationalityModel>((data) => NationalityModel.fromJson(data))
          .toList();
      return nationalities;
    } else {
      throw ServerException();
    }
  }
}