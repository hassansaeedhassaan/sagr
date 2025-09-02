import 'package:dartz/dartz.dart';
import 'package:sagr/features/featured/domain/repositories/featured_ads_repository.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

class FeaturedAdUsecase {
  
  FeaturedAdsRepository featuredAdsRepository;
  
  FeaturedAdUsecase(this.featuredAdsRepository);

  Future<Either<Failure, List<ProductModel>>> call(
      PaginationFilter filter) async {
    return await featuredAdsRepository.getFeaturedAds(filter);
  }

}
