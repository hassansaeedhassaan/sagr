import 'package:dartz/dartz.dart';
import 'package:sagr/features/myads/domain/repositories/my_ads_repository.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

class MyAdsUsecase{

  MyAdsRepository repository;
  MyAdsUsecase(this.repository);


  Future<Either<Failure, List<ProductModel>>> call(PaginationFilter filter) async {
    return await repository.getMyAds(filter);
  }

}