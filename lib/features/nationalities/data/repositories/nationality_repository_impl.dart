import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/nationalities/data/datasource/nationalities_data_source.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import '../../domain/repositories/nationality_repository.dart';

class NationalityRepositoryImpl implements NationalityRepository {
  
  final NationalitiesDataSource nationalitiesDataSource;
  
  NationalityRepositoryImpl(this.nationalitiesDataSource);

  @override
  Future<Either<Failure, List<NationalityModel>>> getNationalities() async {
    try {
      final jobsData = await nationalitiesDataSource.getNationalities();
      return Right(jobsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
 
}
 