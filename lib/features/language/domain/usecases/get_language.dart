import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/language_model.dart';
import '../repositories/language_repository.dart';

class LanguageUsecase {
  
  LanguageRepository languageRepository;
  
  LanguageUsecase(this.languageRepository);

  Future<Either<Failure, List<LanguageModel>>> call() async {
    return await languageRepository.getLanguages();
  }
  
}
