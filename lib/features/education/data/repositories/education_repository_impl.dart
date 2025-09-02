import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/education_repository.dart';
import '../datasource/education_data_source.dart';
import '../models/education_model.dart';

class EducationRepositoryImpl implements EducationRepository {
  
  final EducationDataSource educationDataSource;
  
  EducationRepositoryImpl(this.educationDataSource);

  @override
  Future<Either<Failure, List<EducationModel>>> getEducations() async {
    try {
      final productsData = await educationDataSource.getEducations();
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 