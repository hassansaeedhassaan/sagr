import 'package:dio/dio.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/country_model.dart';

abstract class CountriesDataSource {

  Future<List<CountryModel>> getCountries(PaginationFilter filter);

}

class CountriesDataSourceImpl extends CountriesDataSource {
  final Dio dio;

  CountriesDataSourceImpl({required this.dio});

  @override
  Future<List<CountryModel>> getCountries(filter) async {
    var response = await dio.get(BASEURL + '/nationalities', queryParameters: {
      'page': filter.page,
      'limit': filter.limit
    });


    if (response.statusCode == 200) {
      final List<CountryModel> countries = response.data['data']['nationalities']
          .map<CountryModel>(
              (jsonPostModel) => CountryModel.fromJson(jsonPostModel))
          .toList();
      return countries;
    } else {
      throw ServerException();
    }
  }
  
 
  
}
