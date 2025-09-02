import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/event_model.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventModel>>> getEvents(PaginationFilter filter);
  
  Future<Either<Failure,  Map<DateTime, List<EventCalenderModel>>>> getCalenderEvents(PaginationFilter filter);
  
  Future<Either<Failure, EventModel>> getEventDetails(int id);

  Future<Either<Failure, Response>> apply(Map<String, dynamic> body);
  
  Future<Either<Failure, Response>> attendanceAndDeparture(Map<String, dynamic> body);
}
