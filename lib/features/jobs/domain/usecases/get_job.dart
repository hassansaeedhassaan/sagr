import 'package:dartz/dartz.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/job_repository.dart';

class JobUsecase {
  
  JobRepository jobRepository;
  
  JobUsecase(this.jobRepository);

  Future<Either<Failure, List<JobModel>>> call() async {
    return await jobRepository.getJobs();
  }
  
}
