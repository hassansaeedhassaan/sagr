import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/marital_status_model.dart';

abstract class MaritalStatusRepository {
  Future<Either<Failure, List<MaritalStatusModel>>> getMaritalStatus();
}
