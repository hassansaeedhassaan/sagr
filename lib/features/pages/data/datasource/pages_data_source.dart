import 'package:dio/dio.dart';
import 'package:sagr/features/pages/data/models/page_model.dart';
import 'package:sagr/helper/base_url.dart';

import '../../../../core/error/exceptions.dart';

abstract class PagesDataSource {
  Future<PageModel> getPage(String slug);

}

class PagesDataSourceImpl extends PagesDataSource {
  final Dio dio;

  PagesDataSourceImpl({required this.dio});

  @override
  Future<PageModel> getPage(String slug) async{
     var response = await dio.get(BASEURL + '/static-pages/$slug');

    if (response.statusCode == 200) {
      return PageModel.fromJson(response.data['data']['page']);
    } else {
      throw ServerException();
    }
  }


  
}
