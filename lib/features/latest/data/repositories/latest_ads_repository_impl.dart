import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import '../../domain/repositories/featured_ads_repository.dart';
import '../datasource/latest_ads_data_source.dart';

class LatestAdsRepositoryImpl implements LatestAdsRepository {
  
  final LatestAdsDataSource latestAdsDataSource;
  
  LatestAdsRepositoryImpl(this.latestAdsDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getLatestdAds(filter) async {
    try {
      final productsData = await latestAdsDataSource.getLatestAds(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


}
 