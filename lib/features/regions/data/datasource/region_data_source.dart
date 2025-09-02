import 'package:dio/dio.dart';
import 'package:sagr/helper/base_url.dart';
import '../../../../core/error/exceptions.dart';
import '../models/region_model.dart';

abstract class RegionsDataSource {

  Future<List<RegionModel>> getRegions(String? code);
}

class RegionsDataSourceImpl extends RegionsDataSource {
  
  final Dio dio;

  RegionsDataSourceImpl({required this.dio});

  @override
  Future<List<RegionModel>> getRegions(code) async{
    
    var response = await dio.get("$BASEURL/regions", queryParameters: {
      'code': code,
    });

    if (response.statusCode == 200) {


       final List<RegionModel> regions = response.data
          .map<RegionModel>(
              (data) => RegionModel.fromJson(data))
          .toList();

      return regions;

    } else {
      throw ServerException();
    }
  }


  
}
