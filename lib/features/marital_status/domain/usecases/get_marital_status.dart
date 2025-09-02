import 'package:dartz/dartz.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/marital_status_repository.dart';

class MaritalStatusUsecase {
  
  MaritalStatusRepository maritalStatusRepository;
  
  MaritalStatusUsecase(this.maritalStatusRepository);

  Future<Either<Failure, List<MaritalStatusModel>>> call() async {
    return await maritalStatusRepository.getMaritalStatus();
  }
  
}
