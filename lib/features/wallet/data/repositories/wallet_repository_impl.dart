import 'package:dio/src/response.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/wallet/data/models/wallet_model.dart';
import 'package:sagr/features/wallet/domain/repositories/wallet_repository.dart';
import '../datasource/wallet_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource walletDataSource;

  WalletRepositoryImpl(this.walletDataSource);

  @override
  Future<Either<Failure, WalletModel>> getWallet() async {
    try {
      final productsData = await walletDataSource.getWallet();
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> chargeWallet(body) async{
    try {
      final productsData =
          await walletDataSource.chargeWallet(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    } on NotFoundException catch (e) {
      
      return Left(NotFoundFailure(data: e.data));
    }
  }

  // @override
  // Future<Either<Failure, Response>> payAllCommissions(
  //     String paymentMethod) async {
  //   try {
  //     final productsData =
  //         await walletDataSource.payAllCommissions(paymentMethod);
  //     return Right(productsData);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   } on NotFoundException catch (e) {
      
  //     return Left(NotFoundFailure(data: e.data));
  //   }
  // }
  

}
