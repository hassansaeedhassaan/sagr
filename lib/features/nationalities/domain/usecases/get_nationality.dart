import 'package:dartz/dartz.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/nationality_repository.dart';

class NationalityUsecase {
  
  NationalityRepository nationalityRepository;
  
  NationalityUsecase(this.nationalityRepository);

  Future<Either<Failure, List<NationalityModel>>> call() async {
    return await nationalityRepository.getNationalities();
  }
  
}
