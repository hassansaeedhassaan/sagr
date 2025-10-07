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
    print("🔍 Raw response data type: ${responseData.runtimeType}");
    print("🔍 Raw response data: $responseData");
    
    // Handle different response formats
    dynamic dataToProcess;
    
    if (responseData is String) {
      dataToProcess = json.decode(responseData);
    } else {
      dataToProcess = responseData;
    }
    
    // Case 1: Laravel success response format: {"success": true, "data": {...}}
    if (dataToProcess is Map<String, dynamic> && dataToProcess.containsKey('data')) {
      print("📦 Detected Laravel success response format");
      dataToProcess = dataToProcess['data'];
    }
    
    // Case 2: Direct array of events [event1, event2, ...]
    if (dataToProcess is List) {
      print("📋 Detected flat list format with ${dataToProcess.length} events");
      
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
          
          print("✅ Successfully parsed event: ${event.id} ${event.name} ${event.startTime} ${event.endTime}");
          
        } catch (e) {
          print('❌ Error parsing event: $e');
          print('Event JSON: $eventJson');
        }
      }
    }
    // Case 3: Grouped format {"2025-07-27": [events], "2025-07-30": [events]}
    else if (dataToProcess is Map<String, dynamic>) {
      print("📅 Detected grouped format with ${dataToProcess.keys.length} date groups");
      
      dataToProcess.forEach((dateKey, eventsList) {
        print("\n📅 Processing date: $dateKey");
        print("Events list type: ${eventsList.runtimeType}");
        
        if (eventsList is List) {
          print("Found ${eventsList.length} events for $dateKey");
          
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
              
              print("✅ Successfully parsed event: ${event.name}");
              
            } catch (e) {
              print('❌ Error parsing event $i: $e');
              print('Event JSON: $eventJson');
            }
          }
        } else {
          print("❌ Expected List but got ${eventsList.runtimeType} for date $dateKey");
        }
      });
    }
    else {
      throw Exception('Unsupported data format: ${dataToProcess.runtimeType}');
    }
    
    print("\n✅ Successfully parsed ${events.length} days with events");
    print("Events map keys: ${events.keys.map((e) => e.toString()).toList()}");
    
    return events;
    
  } catch (e, stackTrace) {
    print('❌ Error parsing calendar events: $e');
    print('❌ Stack trace: $stackTrace');
    return {};
  }
}

// Map<DateTime, List<EventCalenderModel>> parseCalendarEvents(dynamic responseData) {
//   Map<DateTime, List<EventCalenderModel>> events = {};
  
//   try {
//     print("🔍 Raw response data type: ${responseData.runtimeType}");
//     print("🔍 Raw response data: $responseData");
    
//     // Handle different response formats
//     dynamic dataToProcess;
    
//     if (responseData is String) {
//       dataToProcess = json.decode(responseData);
//     } else {
//       dataToProcess = responseData;
//     }
    
//     // Case 1: Laravel success response format: {"success": true, "data": {...}}
//     if (dataToProcess is Map<String, dynamic> && dataToProcess.containsKey('data')) {
//       print("📦 Detected Laravel success response format");
//       dataToProcess = dataToProcess['data'];
//     }
    
//     // Case 2: Direct array of events [event1, event2, ...]
//     if (dataToProcess is List) {
//       print("📋 Detected flat list format with ${dataToProcess.length} events");
      
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
          
//           print("✅ Successfully parsed event: ${event.name}");
          
//         } catch (e) {
//           print('❌ Error parsing event: $e');
//           print('Event JSON: $eventJson');
//         }
//       }
//     }
//     // Case 3: Grouped format {"2025-07-27": [events], "2025-07-30": [events]}
//     else if (dataToProcess is Map<String, dynamic>) {
//       print("📅 Detected grouped format with ${dataToProcess.keys.length} date groups");
      
//       dataToProcess.forEach((dateKey, eventsList) {
//         print("\n📅 Processing date: $dateKey");
//         print("Events list type: ${eventsList.runtimeType}");
        
//         if (eventsList is List) {
//           print("Found ${eventsList.length} events for $dateKey");
          
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
              
//               print("✅ Successfully parsed event: ${event.name}");
              
//             } catch (e) {
//               print('❌ Error parsing event $i: $e');
//               print('Event JSON: $eventJson');
//             }
//           }
//         } else {
//           print("❌ Expected List but got ${eventsList.runtimeType} for date $dateKey");
//         }
//       });
//     }
//     else {
//       throw Exception('Unsupported data format: ${dataToProcess.runtimeType}');
//     }
    
//     print("\n✅ Successfully parsed ${events.length} days with events");
//     print("Events map keys: ${events.keys.map((e) => e.toString()).toList()}");
    
//     return events;
    
//   } catch (e, stackTrace) {
//     print('❌ Error parsing calendar events: $e');
//     print('❌ Stack trace: $stackTrace');
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
        print('Error parsing individual event: $e');
      }
    }
    
    return events;
    
  } catch (e) {
    print('Error parsing events: $e');
    return {};
  }
  
}

  @override
  Future<EventModel> getEventDetails(int id) async {
    var response =
        await dio.get("https://crowds.sa/api/v1/events/${id}/show");

    if (response.statusCode == 200) {
      final EventModel event = EventModel.fromJson(response.data['data']);

      return event;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Response> apply(Map<String, dynamic> body) async {
    try {
      final response = await dio
          .post("https://crowds.sa/api/v1/event/apply", data: body);

      print('Response: ${response.data}');
    } on DioException catch (e) {
      // كل أخطاء Dio بتيجي هنا
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Connection Timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        print('Send Timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('Receive Timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        // في حالة السيرفر رجّع استجابة بخطأ (مثلاً 400 أو 500)
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        print('Server error: $statusCode - $data');
      } else if (e.type == DioExceptionType.cancel) {
        print('Request was cancelled');
      } else if (e.type == DioExceptionType.unknown) {
        print('Unknown error: ${e.message}');
      } else {
        print('Other Dio error: ${e.message}');
      }
    } catch (e) {
      // أي خطأ ثاني غير Dio
      print('Unexpected error: $e');
    }

    var response = await dio.post("$BASEURL/event/apply", data: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException();
    }
  }


  @override
  Future<Response> attendanceAndDeparture(Map<String, dynamic> body) async {
    try {
      final response = await dio
          .post("$BASEURL/attendance/records", data: body);

      return response;
    } on DioException catch (e) {
      // كل أخطاء Dio بتيجي هنا
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Connection Timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        print('Send Timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('Receive Timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        // في حالة السيرفر رجّع استجابة بخطأ (مثلاً 400 أو 500)
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        print('Server error: $statusCode - $data');
      } else if (e.type == DioExceptionType.cancel) {
        print('Request was cancelled');
      } else if (e.type == DioExceptionType.unknown) {
        print('Unknown error: ${e.message}');
      } else {
        print('Other Dio error: ${e.message}');
      }
    } catch (e) {
      // أي خطأ ثاني غير Dio
      print('Unexpected error: $e');
    }

    var response = await dio.post("$BASEURL/attendance/records", data: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException();
    }
  }
}
