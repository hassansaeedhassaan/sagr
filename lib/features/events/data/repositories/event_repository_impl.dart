import 'package:dio/dio.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasource/events_data_source.dart';
import '../models/event_model.dart';

class EventsRepositoryImpl implements EventRepository {
  
  final EventsDataSource eventsDataSource;
  
  EventsRepositoryImpl(this.eventsDataSource);

  @override
  Future<Either<Failure, List<EventModel>>> getEvents(filter) async {
    try {
      final productsData = await eventsDataSource.getEvents(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


    @override
  Future<Either<Failure,  Map<DateTime, List<EventCalenderModel>>>> getCalenderEvents(filter) async {
    try {
      final productsData = await eventsDataSource.getCalenderEvents(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, EventModel>> getEventDetails(int id) async{
    try {
      final productsData = await eventsDataSource.getEventDetails(id);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> apply(Map<String, dynamic> body) async {
     try {
      final eventData = await eventsDataSource.apply(body);
      return Right(eventData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  

  @override
  Future<Either<Failure, Response>> attendanceAndDeparture(Map<String, dynamic> body) async {
     try {
      final eventData = await eventsDataSource.attendanceAndDeparture(body);
      return Right(eventData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


}
