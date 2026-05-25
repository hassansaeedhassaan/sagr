import 'package:dartz/dartz.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/education/data/models/education_model.dart';


abstract class EducationRepository {
  Future<Either<Failure, List<EducationModel>>> getEducations();
}
