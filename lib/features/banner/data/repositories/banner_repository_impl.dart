import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/banner/data/models/banner_model.dart';
import 'package:sagr/features/banner/domain/repositories/banner_repository.dart';
import '../datasource/banner_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerDataSource bannerDataSource;

  BannerRepositoryImpl(this.bannerDataSource);

  @override
  Future<Either<Failure, BannerModel>> getBanner() async {
    try {
      final bannerData = await bannerDataSource.getBanner();
      return Right(bannerData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  

  
  // @override
  // Future<Either<Failure, Response>> chargeWallet(body) async{
  //   try {
  //     final productsData =
  //         await walletDataSource.chargeWallet(body);
  //     return Right(productsData);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   } on NotFoundException catch (e) {
      
  //     return Left(NotFoundFailure(data: e.data));
  //   }
  // }


  

}
