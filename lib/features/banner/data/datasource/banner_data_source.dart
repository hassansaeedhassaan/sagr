import 'package:dio/dio.dart';
import 'package:sagr/features/banner/data/models/banner_model.dart';
import 'package:sagr/helper/base_url.dart';

import '../../../../core/error/exceptions.dart';

abstract class BannerDataSource {
 Future<BannerModel> getBanner();

}

class BannerDataSourceImpl extends BannerDataSource {
  final Dio dio;

  BannerDataSourceImpl({required this.dio});

  @override
  Future<BannerModel> getBanner() async {
    var response = await dio.get(BASEURL + '/banner');

    if (response.statusCode == 200) {
      return BannerModel.fromJson(response.data['data']['banner']);
  
    } else {
      throw ServerException();
    }
    
  }
}
