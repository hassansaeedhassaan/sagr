import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import '../../domain/repositories/marital_status_repository.dart';
import '../datasource/marital_data_source.dart';

class MaritalStatusRepositoryImpl implements MaritalStatusRepository {
  
  final MaritalStatusDataSource maritalStatusDataSource;
  
  MaritalStatusRepositoryImpl(this.maritalStatusDataSource);

  @override
  Future<Either<Failure, List<MaritalStatusModel>>> getMaritalStatus() async {
    try {
      final productsData = await maritalStatusDataSource.getMaritalStatus();
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 