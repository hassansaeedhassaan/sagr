import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/education_model.dart';

abstract class EducationRepository {
  Future<Either<Failure, List<EducationModel>>> getEducations();
}
