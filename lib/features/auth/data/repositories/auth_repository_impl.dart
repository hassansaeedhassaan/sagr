import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/auth/domain/repositories/auth_repository.dart';

import 'package:sagr/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../models/customer_model.dart';
import '../datasource/auth_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  
  final AuthDataSource authDataSource;
  
  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<Either<Failure, CustomerModel>> createAccount(Map<String, dynamic> body) async {
    try {
      final productsData = await authDataSource.createAccount(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure, CustomerModel>> completeAccount(Map<String, dynamic> body) async {
    try {
      final productsData = await authDataSource.completeAccount(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
 
}
 