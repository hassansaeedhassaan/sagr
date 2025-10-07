import 'package:dartz/dartz.dart';
import 'package:sagr/models/customer_model.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {


  Future<Either<Failure, CustomerModel>> createAccount(
      Map<String, dynamic> body);

  Future<Either<Failure, CustomerModel>> completeAccount(
      Map<String, dynamic> body);


  Future<Either<Failure, CustomerModel>> updateProfile(
      Map<String, dynamic> body);

  
}
