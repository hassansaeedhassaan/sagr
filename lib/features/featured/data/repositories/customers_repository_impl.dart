import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/featured/domain/repositories/featured_ads_repository.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import '../datasource/featured_ads_data_source.dart';

class FeaturedAdsRepositoryImpl implements FeaturedAdsRepository {
  
  final FeaturedAdsDataSource featuredAdsDataSource;
  
  FeaturedAdsRepositoryImpl(this.featuredAdsDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getFeaturedAds(filter) async {
    try {
      final productsData = await featuredAdsDataSource.getFeaturedAds(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}
 