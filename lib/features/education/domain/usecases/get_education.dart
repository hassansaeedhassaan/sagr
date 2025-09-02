import 'package:dartz/dartz.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/education_repository.dart';

class EducationUsecase {
  
  EducationRepository educationRepository;
  
  EducationUsecase(this.educationRepository);

  Future<Either<Failure, List<EducationModel>>> call() async {
    return await educationRepository.getEducations();
  }
  
}
