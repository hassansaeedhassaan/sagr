import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../models/customer_model.dart';
import '../repositories/auth_repository.dart';

class AuthUsecase {
  AuthRepository repository;
  AuthUsecase(this.repository);

  // Future<Either<Failure, List<CustomerModel>>> call(
  //     PaginationFilter filter) async {
  //   return await repository.getCustomers(filter);
  // }

  // Future<Either<Failure, CustomerModel>> getCustomer(customerID) async {
  //   return await repository.getCustomer(customerID);
  // }

  Future<Either<Failure, CustomerModel>> createAccount(
      Map<String, dynamic> body) async {
    return await repository.createAccount(body);
  }


  Future<Either<Failure, CustomerModel>> completeAccount(
      Map<String, dynamic> body) async {
    return await repository.completeAccount(body);
  }


  // Future<Either<Failure, Response>> makeCustomerGift(
  //     Map<String, dynamic> body) async {
  //   return await repository.makeCustomerGift(body);
  // }

  //   Future<Either<Failure, Response>> restoreCustomerGift(
  //     Map<String, dynamic> body) async {
  //   return await repository.restoreCustomerGift(body);
  // }
}
