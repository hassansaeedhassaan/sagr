import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/region_model.dart';

abstract class RegionRepository {
  Future<Either<Failure, List<RegionModel>>> getRegions(String? code);
}
