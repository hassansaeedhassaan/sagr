import 'package:sagr/core/utils/app_log.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../helper/base_url.dart';
import '../../../../models/pagination_filter.dart';
import '../models/event_model.dart';

abstract class EventsDataSource {

  Future<List<EventModel>> getEvents(PaginationFilter filter);

  Future< Map<DateTime, List<EventCalenderModel>>> getCalenderEvents(PaginationFilter filter);

  Future<EventModel> getEventDetails(int id);

  Future<Response> apply(Map<String, dynamic> body);

  Future<Response> attendanceAndDeparture(Map<String, dynamic> body);
  Future<Response> applicationStatus(Map<String, dynamic> body);
}

class EventsDataSourceImpl extends EventsDataSource {
  final Dio dio;

  EventsDataSourceImpl({required this.dio});

  @override
  Future<List<EventModel>> getEvents(filter) async {

    var response = await dio.get('$BASEURL/events', queryParameters: {
      'page': filter.page,
      'limit': filter.limit,
      'eventType': filter.eventType ?? 'all',
      'job': filter.job,
      'ed': filter.eventDuration // event duration is event finished or not.
    });

    if (response.statusCode == 200) {
      final List<EventModel> events = response.data['data']
          .map<EventModel>((data) => EventModel.fromJson(data))
          .toList();

      return events;
    } else {
      throw ServerException();
    }
  }

 @override
  Future< Map<DateTime, List<EventCalenderModel>>> getCalenderEvents(filter) async {
    var response = await dio.get('$BASEURL/events/calender', queryParameters: {
      // event duration is event finished or not.
    });

    if (response.statusCode == 200) {

     final parsedEvents = parseCalendarEvents(response.data['data']);
        return parsedEvents;
    } else {
      throw ServerException();
    }
  }

  Map<DateTime, List<EventCalenderModel>> parseCalendarEvents(dynamic responseData) {
  Map<DateTime, List<EventCalenderModel>> events = {};
  
  try {
    appLog("🔍 Raw response data type: ${responseData.runtimeType}");
    appLog("🔍 Raw response data: $responseData");
    
    // Handle different response formats
    dynamic dataToProcess;
    
    if (responseData is String) {
      dataToProcess = json.decode(responseData);
    } else {
      dataToProcess = responseData;
    }
    
    // Case 1: Laravel success response format: {"success": true, "data": {...}}
    if (dataToProcess is Map<String, dynamic> && dataToProcess.containsKey('data')) {
      appLog("📦 Detected Laravel success response format");
      dataToProcess = dataToProcess['data'];
    }
    
    // Case 2: Direct array of events [event1, event2, ...]
    if (dataToProcess is List) {
      appLog("📋 Detected flat list format with ${dataToProcess.length} events");
      
      for (var eventJson in dataToProcess) {
        try {
          final event = EventCalenderModel.fromJson(eventJson);
          
          // Create normalized DateTime for the day
          final day = DateTime(
            event.startTime.year,
            event.startTime.month,
            event.startTime.day,
          );
          
          // Add event to the map
          if (events[day] != null) {
            events[day]!.add(event);
          } else {
            events[day] = [event];
          }
          
          appLog("✅ Successfully parsed event: ${event.id} ${event.name} ${event.startTime} ${event.endTime}");
          
        } catch (e) {
          appLog('❌ Error parsing event: $e');
          appLog('Event JSON: $eventJson');
        }
      }
    }
    // Case 3: Grouped format {"2025-07-27": [events], "2025-07-30": [events]}
    else if (dataToProcess is Map<String, dynamic>) {
      appLog("📅 Detected grouped format with ${dataToProcess.keys.length} date groups");
      
      dataToProcess.forEach((dateKey, eventsList) {
        appLog("\n📅 Processing date: $dateKey");
        appLog("Events list type: ${eventsList.runtimeType}");
        
        if (eventsList is List) {
          appLog("Found ${eventsList.length} events for $dateKey");
          
          for (int i = 0; i < eventsList.length; i++) {
            var eventJson = eventsList[i];
            
            try {
              final event = EventCalenderModel.fromJson(eventJson);
              
              // Create normalized DateTime for the day
              final day = DateTime.utc(
                event.startTime.year,
                event.startTime.month,
                event.startTime.day,
              );
              
              // Add event to the map
              if (events[day] != null) {
                events[day]!.add(event);
              } else {
                events[day] = [event];
              }
              
              appLog("✅ Successfully parsed event: ${event.name}");
              
            } catch (e) {
              appLog('❌ Error parsing event $i: $e');
              appLog('Event JSON: $eventJson');
            }
          }
        } else {
          appLog("❌ Expected List but got ${eventsList.runtimeType} for date $dateKey");
        }
      });
    }
    else {
      throw Exception('Unsupported data format: ${dataToProcess.runtimeType}');
    }
    
    appLog("\n✅ Successfully parsed ${events.length} days with events");
    appLog("Events map keys: ${events.keys.map((e) => e.toString()).toList()}");
    
    return events;
    
  } catch (e, stackTrace) {
    appLog('❌ Error parsing calendar events: $e');
    appLog('❌ Stack trace: $stackTrace');
    return {};
  }
}

// Map<DateTime, List<EventCalenderModel>> parseCalendarEvents(dynamic responseData) {
//   Map<DateTime, List<EventCalenderModel>> events = {};
  
//   try {
//     appLog("🔍 Raw response data type: ${responseData.runtimeType}");
//     appLog("🔍 Raw response data: $responseData");
    
//     // Handle different response formats
//     dynamic dataToProcess;
    
//     if (responseData is String) {
//       dataToProcess = json.decode(responseData);
//     } else {
//       dataToProcess = responseData;
//     }
    
//     // Case 1: Laravel success response format: {"success": true, "data": {...}}
//     if (dataToProcess is Map<String, dynamic> && dataToProcess.containsKey('data')) {
//       appLog("📦 Detected Laravel success response format");
//       dataToProcess = dataToProcess['data'];
//     }
    
//     // Case 2: Direct array of events [event1, event2, ...]
//     if (dataToProcess is List) {
//       appLog("📋 Detected flat list format with ${dataToProcess.length} events");
      
//       for (var eventJson in dataToProcess) {
//         try {
//           final event = EventCalenderModel.fromJson(eventJson);
          
//           // Create normalized DateTime for the day
//           final day = DateTime.utc(
//             event.startTime.year,
//             event.startTime.month,
//             event.startTime.day,
//           );
          
//           // Add event to the map
//           if (events[day] != null) {
//             events[day]!.add(event);
//           } else {
//             events[day] = [event];
//           }
          
//           appLog("✅ Successfully parsed event: ${event.name}");
          
//         } catch (e) {
//           appLog('❌ Error parsing event: $e');
//           appLog('Event JSON: $eventJson');
//         }
//       }
//     }
//     // Case 3: Grouped format {"2025-07-27": [events], "2025-07-30": [events]}
//     else if (dataToProcess is Map<String, dynamic>) {
//       appLog("📅 Detected grouped format with ${dataToProcess.keys.length} date groups");
      
//       dataToProcess.forEach((dateKey, eventsList) {
//         appLog("\n📅 Processing date: $dateKey");
//         appLog("Events list type: ${eventsList.runtimeType}");
        
//         if (eventsList is List) {
//           appLog("Found ${eventsList.length} events for $dateKey");
          
//           for (int i = 0; i < eventsList.length; i++) {
//             var eventJson = eventsList[i];
            
//             try {
//               final event = EventCalenderModel.fromJson(eventJson);
              
//               // Create normalized DateTime for the day
//               final day = DateTime.utc(
//                 event.startTime.year,
//                 event.startTime.month,
//                 event.startTime.day,
//               );
              
//               // Add event to the map
//               if (events[day] != null) {
//                 events[day]!.add(event);
//               } else {
//                 events[day] = [event];
//               }
              
//               appLog("✅ Successfully parsed event: ${event.name}");
              
//             } catch (e) {
//               appLog('❌ Error parsing event $i: $e');
//               appLog('Event JSON: $eventJson');
//             }
//           }
//         } else {
//           appLog("❌ Expected List but got ${eventsList.runtimeType} for date $dateKey");
//         }
//       });
//     }
//     else {
//       throw Exception('Unsupported data format: ${dataToProcess.runtimeType}');
//     }
    
//     appLog("\n✅ Successfully parsed ${events.length} days with events");
//     appLog("Events map keys: ${events.keys.map((e) => e.toString()).toList()}");
    
//     return events;
    
//   } catch (e, stackTrace) {
//     appLog('❌ Error parsing calendar events: $e');
//     appLog('❌ Stack trace: $stackTrace');
//     return {};
//   }
// }

// Alternative approach if response.data['data'] is directly the events list
Map<DateTime, List<EventCalenderModel>> parseCalendarEventsSimple(List<dynamic> eventsData) {
  Map<DateTime, List<EventCalenderModel>> events = {};
  
  try {
    for (var eventJson in eventsData) {
      try {
        final event = EventCalenderModel.fromJson(eventJson);
        
        final day = DateTime.utc(
          event.startTime.year,
          event.startTime.month,
          event.startTime.day,
        );
        
        if (events[day] != null) {
          events[day]!.add(event);
        } else {
          events[day] = [event];
        }
      } catch (e) {
        appLog('Error parsing individual event: $e');
      }
    }
    
    return events;
    
  } catch (e) {
    appLog('Error parsing events: $e');
    return {};
  }
  
}

  @override
  Future<EventModel> getEventDetails(int id) async {
    var response =
        await dio.get("$BASEURL/events/${id}/show");

    if (response.statusCode == 200) {
      final EventModel event = EventModel.fromJson(response.data['data']);

      return event;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> apply(Map<String, dynamic> body) async {
    // try {
    //   final response = await dio
    //       .post("https://crowds.sa/api/v1/event/apply", data: body);

    //   appLog('Response: ${response.data}');
    // } on DioException catch (e) {
    //   // كل أخطاء Dio بتيجي هنا
    //   if (e.type == DioExceptionType.connectionTimeout) {
    //     appLog('Connection Timeout');
    //   } else if (e.type == DioExceptionType.sendTimeout) {
    //     appLog('Send Timeout');
    //   } else if (e.type == DioExceptionType.receiveTimeout) {
    //     appLog('Receive Timeout');
    //   } else if (e.type == DioExceptionType.badResponse) {
    //     // في حالة السيرفر رجّع استجابة بخطأ (مثلاً 400 أو 500)
    //     final statusCode = e.response?.statusCode;
    //     final data = e.response?.data;
    //     appLog('Server error: $statusCode - $data');
    //   } else if (e.type == DioExceptionType.cancel) {
    //     appLog('Request was cancelled');
    //   } else if (e.type == DioExceptionType.unknown) {
    //     appLog('Unknown error: ${e.message}');
    //   } else {
    //     appLog('Other Dio error: ${e.message}');
    //   }
    // } catch (e) {
    //   // أي خطأ ثاني غير Dio
    //   appLog('Unexpected error: $e');
    // }



    // Pinned explicitly: a Map body must not go out as multipart, or PHP
    // discards it and the server answers 422 with every field "required".
    // Errors propagate as DioException; the repository turns them into a
    // Failure that keeps the server's reason ("already applied", ...).
    return dio.post(
      "$BASEURL/event/apply",
      data: body,
      options: Options(contentType: Headers.jsonContentType),
    );
  }


  @override
  Future<Response> attendanceAndDeparture(Map<String, dynamic> body) async {
    try {
      return await dio.post("$BASEURL/attendance/records", data: body);
    } on DioException catch (e) {
      // This used to only print the error and then fall through to a second,
      // identical POST — so a failed check-in was silently retried and could
      // file two attendance records. Surface the server's own message instead.
      final status = e.response?.statusCode;
      final data = e.response?.data;

      String message = 'Unable to process your attendance request. Please try again.';
      if (data is Map && data['message'] is String) {
        message = data['message'] as String;
      }

      if (status == 400 || status == 422) {
        throw ValidationException(data, message: message, statusCode: status);
      }
      throw ServerException();
    }
  }

  @override
  Future<Response> applicationStatus(Map<String, dynamic> body) {
    // Errors propagate as DioException; see apply().
    return dio.post("$BASEURL/application/status/event", data: body);
  }
}
