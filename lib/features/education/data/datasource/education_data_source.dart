import 'package:dio/dio.dart';
import 'package:sagr/helper/base_url.dart';
import '../../../../core/error/exceptions.dart';
import '../models/education_model.dart';

abstract class EducationDataSource {

  Future<List<EducationModel>> getEducations();
}

class EducationDataSourceImpl extends EducationDataSource {
  
  final Dio dio;

  EducationDataSourceImpl({required this.dio});

  @override
  Future<List<EducationModel>> getEducations() async{
    
    var response = await dio.get('$BASEURL/educations');

    if (response.statusCode == 200) {

      print(response.data);

       final List<EducationModel> educations = response.data['data']
          .map<EducationModel>(
              (data) => EducationModel.fromJson(data))
          .toList();

      return educations;

    } else {

      throw ServerException();
    
    }
  }


  
}
