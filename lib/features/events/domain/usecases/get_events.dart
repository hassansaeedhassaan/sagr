import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import 'package:sagr/models/pagination_filter.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/event_model.dart';
import '../repositories/event_repository.dart';

class EventsUsecase {
  
  EventRepository eventRepository;
  
  EventsUsecase(this.eventRepository);

  Future<Either<Failure, List<EventModel>>> call(PaginationFilter filter) async {
    return await eventRepository.getEvents(filter);
  }



   Future<Either<Failure,  Map<DateTime, List<EventCalenderModel>>>> getCalenderEvents(PaginationFilter filter) async {
    return await eventRepository.getCalenderEvents(filter);
  }

 Future<Either<Failure, EventModel>> getEventDetails(int id) async {
    return await eventRepository.getEventDetails(id);
  }

  
 Future<Either<Failure, Response>> apply(
      Map<String, dynamic> body) async {
    return await eventRepository.apply(body);
  }

 Future<Either<Failure, Response>> attendanceAndDeparture(
      Map<String, dynamic> body) async {
    return await eventRepository.attendanceAndDeparture(body);
  }


  

  
}
