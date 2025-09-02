import 'package:dio/dio.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/evocations/data/models/evocation_model.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasource/events_data_source.dart';

class EvocationsRepositoryImpl implements EvocationRepository {
  
  final EvocationsDataSource evocationsDataSource;
  
  EvocationsRepositoryImpl(this.evocationsDataSource);

  @override
  Future<Either<Failure, List<EvocationModel>>> getEvocations(filter) async {
    try {
      final productsData = await evocationsDataSource.getEvocations(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }



  @override
  Future<Either<Failure, Response>> apply(Map<String, dynamic> body) async {
     try {
      final eventData = await evocationsDataSource.apply(body);
      return Right(eventData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  

}
