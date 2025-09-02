import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/region_repository.dart';
import '../datasource/region_data_source.dart';
import '../models/region_model.dart';

class RegionRepositoryImpl implements RegionRepository {
  
  final RegionsDataSource regionsDataSource;
  
  RegionRepositoryImpl(this.regionsDataSource);

  @override
  Future<Either<Failure, List<RegionModel>>> getRegions(code) async {
    try {
      final productsData = await regionsDataSource.getRegions(code);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 