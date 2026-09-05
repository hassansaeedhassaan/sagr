import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/education/data/datasource/education_data_source.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/education/domain/repositories/education_repository.dart';


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
 