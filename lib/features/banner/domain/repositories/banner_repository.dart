import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/banner_model.dart';

abstract class BannerRepository {
  Future<Either<Failure, BannerModel>> getBanner();
}
