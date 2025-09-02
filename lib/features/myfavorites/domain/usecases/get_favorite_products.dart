import 'package:dartz/dartz.dart';
import 'package:sagr/features/myfavorites/domain/repositories/favorite_products_repository.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

class FavoriteProductUsecase{

  FavoriteProductsRepository repository;
  FavoriteProductUsecase(this.repository);


  Future<Either<Failure, List<Product>>> call(PaginationFilter filter) async {
    return await repository.getFavoriteProducts(filter);
  }

}