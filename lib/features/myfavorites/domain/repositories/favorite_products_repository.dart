import 'package:dartz/dartz.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/models/pagination_filter.dart';


import '../../../../core/error/failures.dart';

abstract class FavoriteProductsRepository{
  Future<Either<Failure, List<Product>>> getFavoriteProducts(PaginationFilter filter);

}


