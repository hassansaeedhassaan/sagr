import 'package:dartz/dartz.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import '../../../../core/error/failures.dart';

abstract class NationalityRepository {
  Future<Either<Failure, List<NationalityModel>>> getNationalities();
}
