import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/wallet/data/models/wallet_model.dart';

import '../../../../core/error/failures.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletModel>> getWallet();
  Future<Either<Failure, Response>> chargeWallet(body);
}
