import 'package:dartz/dartz.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/education/domain/repositories/education_repository.dart';


class EducationUsecase {
  
  EducationRepository educationRepository;
  
  EducationUsecase(this.educationRepository);

  Future<Either<Failure, List<EducationModel>>> call() async {
    return await educationRepository.getEducations();
  }
  
}
