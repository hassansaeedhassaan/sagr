import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../models/pagination_filter.dart';
import '../../data/models/evocation_model.dart';
import '../repositories/event_repository.dart';

class EvocationsUsecase {
  
  EvocationRepository evocationRepository;
  
  EvocationsUsecase(this.evocationRepository);

  Future<Either<Failure, List<EvocationModel>>> call(PaginationFilter filter) async {
    return await evocationRepository.getEvocations(filter);
  }

  
 Future<Either<Failure, Response>> apply(
      Map<String, dynamic> body) async {
    return await evocationRepository.apply(body);
  }

}
