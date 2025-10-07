import 'package:dartz/dartz.dart';
import 'package:sagr/models/pagination_filter.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/ad_model.dart';
import '../repositories/ad_repository.dart';

class AdsUsecase {
 AdRepository adRepository;

  AdsUsecase(this.adRepository);

  Future<Either<Failure, List<AdModel>>> call(PaginationFilter filter) async {
    return await adRepository.getAds(filter);
  }
}
