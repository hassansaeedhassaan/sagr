import 'package:dio/dio.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';

abstract class FeaturedAdsDataSource {
  Future<List<ProductModel>> getFeaturedAds(PaginationFilter filter);
}

class FeaturedAdsDataSourceImpl extends FeaturedAdsDataSource {
  final Dio dio;

  FeaturedAdsDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getFeaturedAds(filter) async {
    Map<String, dynamic> queryParameters = {
      'page': filter.page,
    };

    if (filter.available_photo != null && filter.available_photo == true) {
      queryParameters['available_photo'] = '1';
    }
    if (filter.category_id != null) {
      queryParameters['category_id'] = filter.category_id;
    }

    if (filter.country_id != null) {
      queryParameters['country_id'] = filter.country_id;
    }



    if (filter.name != "") {
      queryParameters['search'] = filter.name;
    }

    if (filter.created_at != null) {
      queryParameters['created_at'] = filter.created_at;
    }

    // if (filter.country_id != '') {
    //   queryParameters['country_id'] = filter.country_id;
    // }

    if (filter.nearBy != null && filter.nearBy == true) {
      queryParameters['near_by'] = '1';
      queryParameters['latitude']  = filter.lat ?? "";
      queryParameters['longitude'] = filter.long ?? "" ;

      // queryParameters['latitude'] = "23.402765";
      // queryParameters['longitude'] = "33.820317";
    }
    var response = await dio.get(BASEURL + '/advertisement/filter/feature',
        queryParameters: queryParameters);

    if (response.statusCode == 200) {
      // print(response.data['data']);
      final List<ProductModel> customers = response.data['data']
          .map<ProductModel>(
              (jsonPostModel) => ProductModel.fromJson(jsonPostModel))
          .toList();
      return customers;
    } else {
      throw ServerException();
    }
  }
}
