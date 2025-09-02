import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/products/data/models/product_model.dart';

import 'package:sagr/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/my_ads_repository.dart';
import '../datasources/my_ads_data_source.dart';

class MyAdsRepositoryImpl implements MyAdsRepository {
  
  final MyAdsDataSource myAdsDataSource;

  MyAdsRepositoryImpl(this.myAdsDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getMyAds(filter) async {
    try {
      final productsData = await myAdsDataSource.getMyAds(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}
 