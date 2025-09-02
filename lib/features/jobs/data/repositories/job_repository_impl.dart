import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasource/jobs_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  
  final JobDataSource jobDataSource;
  
  JobRepositoryImpl(this.jobDataSource);

  @override
  Future<Either<Failure, List<JobModel>>> getJobs() async {
    try {
      final jobsData = await jobDataSource.getJobs();
      return Right(jobsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
 