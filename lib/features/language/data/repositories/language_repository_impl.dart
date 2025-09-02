import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasource/language_data_source.dart';
import '../models/language_model.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  
  final LanguagesDataSource languagesDataSource;
  
  LanguageRepositoryImpl(this.languagesDataSource);

  @override
  Future<Either<Failure, List<LanguageModel>>> getLanguages() async {
    try {
      final productsData = await languagesDataSource.getLanguages();
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 