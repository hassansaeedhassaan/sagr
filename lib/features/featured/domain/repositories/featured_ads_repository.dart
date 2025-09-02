import 'package:dartz/dartz.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class FeaturedAdsRepository {
  Future<Either<Failure, List<ProductModel>>> getFeaturedAds(PaginationFilter filter);
}
