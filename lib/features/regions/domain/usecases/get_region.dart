import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/region_model.dart';
import '../repositories/region_repository.dart';

class RegionUsecase {
  
  RegionRepository regionRepository;
  
  RegionUsecase(this.regionRepository);

  Future<Either<Failure, List<RegionModel>>> call(code) async {
    return await regionRepository.getRegions(code);
  }
  
}
