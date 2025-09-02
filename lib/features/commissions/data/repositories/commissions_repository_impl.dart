import 'package:dio/src/response.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/commissions/data/models/commission_model.dart';
import 'package:sagr/features/commissions/domain/repositories/commissions_repository.dart';
import '../datasource/commissions_data_source.dart';

class CommissionsRepositoryImpl implements CommissionsRepository {
  final CommissionsDataSource commissionsDataSource;

  CommissionsRepositoryImpl(this.commissionsDataSource);

  @override
  Future<Either<Failure, List<CommissionModel>>> getCommissions(filter) async {
    try {
      final productsData = await commissionsDataSource.getCommissions(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> payAllCommissions(
      String paymentMethod) async {
    try {
      final productsData =
          await commissionsDataSource.payAllCommissions(paymentMethod);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    } on NotFoundException catch (e) {
      
      return Left(NotFoundFailure());
    }
  }
}
