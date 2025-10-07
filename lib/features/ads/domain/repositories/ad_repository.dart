import 'package:dartz/dartz.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/ad_model.dart';

abstract class AdRepository {
  Future<Either<Failure, List<AdModel>>> getAds(PaginationFilter filter);
}
