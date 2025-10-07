import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../helper/base_url.dart';
import '../../../../models/pagination_filter.dart';
import '../models/ad_model.dart';

abstract class AdsDataSource {
  Future<List<AdModel>> getAds(PaginationFilter filter);
}

class AdsDataSourceImpl extends AdsDataSource {
  final Dio dio;

  AdsDataSourceImpl({required this.dio});

  @override
  Future<List<AdModel>> getAds(filter) async {

    var response = await dio.get('$BASEURL/ads');

    if (response.statusCode == 200) {
      final List<AdModel> events = response.data['data']
          .map<AdModel>((data) => AdModel.fromJson(data))
          .toList();

      return events;
    } else {
      throw ServerException();
    }
  }

}
