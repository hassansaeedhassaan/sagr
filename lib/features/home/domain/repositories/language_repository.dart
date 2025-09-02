import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/language_model.dart';

abstract class LanguageRepository {
  Future<Either<Failure, List<LanguageModel>>> getLanguages();
}
