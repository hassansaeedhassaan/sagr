import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/myfavorites/domain/repositories/favorite_products_repository.dart';
import 'package:sagr/features/products/domain/entities/product.dart';

import 'package:sagr/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../datasources/product_data_source.dart';

class FavoriteProductsRepositoryImpl implements FavoriteProductsRepository {
  
  final FavoriteDataSource favoriteDataSource;

  FavoriteProductsRepositoryImpl(this.favoriteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getFavoriteProducts(filter) async {
    try {
      final productsData = await favoriteDataSource.getFavoriteProducts(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}
 