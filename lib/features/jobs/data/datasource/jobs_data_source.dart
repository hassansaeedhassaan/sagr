import 'package:dio/dio.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/helper/base_url.dart';
import '../../../../core/error/exceptions.dart';

abstract class JobDataSource {
  Future<List<JobModel>> getJobs();
}

class JobDataSourceImpl extends JobDataSource {
  final Dio dio;

  JobDataSourceImpl({required this.dio});

  @override
  Future<List<JobModel>> getJobs() async {
    
    // Request For Jobs Api
    var response = await dio.get('$BASEURL/jobs');


    if (response.statusCode == 200) {
      final List<JobModel> jobs = response.data['data']
          .map<JobModel>((data) => JobModel.fromJson(data))
          .toList();
      return jobs;
    } else {
      throw ServerException();
    }
  }
}