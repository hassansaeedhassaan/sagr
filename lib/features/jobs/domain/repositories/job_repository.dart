import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/job_model.dart';

abstract class JobRepository {
  Future<Either<Failure, List<JobModel>>> getJobs();
}
