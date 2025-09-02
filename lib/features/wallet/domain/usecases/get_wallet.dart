import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/wallet/data/models/wallet_model.dart';

import '../../../../core/error/failures.dart';
import '../repositories/wallet_repository.dart';

class WalletUsecase {
  
  WalletRepository walletRepository;
  
  WalletUsecase(this.walletRepository);

  Future<Either<Failure, WalletModel>> call() async {
    return await walletRepository.getWallet();
  }

  Future<Either<Failure, Response>> chargeWallet(
      Map<String, dynamic> body) async {
    return await walletRepository.chargeWallet(body);
  }

}
