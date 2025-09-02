import 'package:dartz/dartz.dart';
import 'package:sagr/features/banner/data/models/banner_model.dart';
import 'package:sagr/features/banner/data/repositories/banner_repository_impl.dart';

import '../../../../core/error/failures.dart';

class BannerUsecase {
  
  BannerRepositoryImpl walletRepository;
  
  BannerUsecase(this.walletRepository);

  Future<Either<Failure, BannerModel>> call() async {
    return await walletRepository.getBanner();
  }


}
