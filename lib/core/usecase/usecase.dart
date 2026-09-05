import 'package:dartz/dartz.dart';
import 'package:sagr/core/error/failures.dart';

/// Base interface for all use cases in the application
/// Follows the Single Responsibility Principle from SOLID
/// 
/// Type parameters:
/// - [Type]: The return type of the use case
/// - [Params]: The parameters type required by the use case
abstract class UseCase<Type, Params> {
  /// Executes the use case with given parameters
  /// 
  /// Returns:
  /// - [Right(Type)]: On success with the result
  /// - [Left(Failure)]: On failure with the error
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require any parameters
class NoParams {
  const NoParams();
}