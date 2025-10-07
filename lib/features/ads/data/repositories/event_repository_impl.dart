import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/ad_repository.dart';
import '../datasource/ads_data_source.dart';
import '../models/ad_model.dart';

class AdsRepositoryImpl implements AdRepository {
  
  final AdsDataSource adsDataSource;
  
  AdsRepositoryImpl(this.adsDataSource);

  @override
  Future<Either<Failure, List<AdModel>>> getAds(filter) async {
    try {
      final adsData = await adsDataSource.getAds(filter);
      return Right(adsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


}
