import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/language_model.dart';

abstract class LanguagesDataSource {

  Future<List<LanguageModel>> getLanguages();
}

class LanguagesDataSourceImpl extends LanguagesDataSource {
  
  final Dio dio;

  LanguagesDataSourceImpl({required this.dio});

  @override
  Future<List<LanguageModel>> getLanguages() async{
    
    var response = await dio.get('https://crowds.sa/api/v1/languages');

    if (response.statusCode == 200) {

       final List<LanguageModel> languages = response.data
          .map<LanguageModel>(
              (data) => LanguageModel.fromJson(data))
          .toList();

      return languages;

    } else {

      throw ServerException();
    
    }
  }


  
}
