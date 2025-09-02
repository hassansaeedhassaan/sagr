import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_events.dart';

class EventCalendarController extends GetxController {

  final EventsUsecase eventsUsecase;

  EventCalendarController(this.eventsUsecase);

  // Observable variables
  var events = <DateTime, List<EventCalenderModel>>{}.obs;
    // Rx<Map<DateTime, List<EventCalenderModel>>> events = <DateTime, List<EventCalenderModel>>{}.obs;

  var selectedEvents = <EventCalenderModel>[].obs;
  var calendarFormat = CalendarFormat.month.obs;
  var rangeSelectionMode = RangeSelectionMode.toggledOff.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = Rxn<DateTime>();
  var rangeStart = Rxn<DateTime>();
  var rangeEnd = Rxn<DateTime>();
  var currentTabIndex = 0.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var newEventStartDate = DateTime.now().obs;
  var newEventEndDate = DateTime.now().add(const Duration(hours: 1)).obs;
  var isAllDay = false.obs;
  var selectedColor = Colors.blue.obs;

    /// Rx Filters  Setter
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

final RxBool _isLoading = true.obs;


  /// Rx Filters  Getter
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;
  bool get isLoading => _isLoading.value;

  // Color options for events
  final List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void onInit() {
    super.onInit();
    selectedDay.value = focusedDay.value;
    // loadSampleData();
    // updateSelectedEvents();
    _changePaginationFilter(1, 10);
     loadEventsFromApi();
  }



   void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Load sample data
  void loadSampleData() {
    events.value = {
      DateTime.utc(2025, 7, 31): [
        EventCalenderModel(
          id: 0,
          name: 'Project Deadline',
          description: 'Submit final project documents',
          startTime: DateTime(2025, 4, 20, 10, 0),
          endTime: DateTime(2025, 4, 20, 11, 30),
          // color: Colors.red,
        ),
      ],
      DateTime.utc(2025, 8, 08): [
        EventCalenderModel(
          id:1,
          name: 'Team Meeting',
          description: 'Discuss upcoming sprints',
          startTime: DateTime(2025, 4, 22, 14, 0),
          endTime: DateTime(2025, 4, 22, 15, 0),
          // color: Colors.green,
        ),
      ],
      // DateTime.utc(2025, 8, 03): [
      //   EventCalenderModel(
      //     id: 3,
      //     name: 'Client Call 2 99348',
      //     description: 'Project progress update',
      //     startTime: DateTime(2025, 8, 3, 9, 0),
      //     endTime: DateTime(2025, 8, 3, 10, 0),
      //     // color: Colors.orange,
      //   ),
      //   EventCalenderModel(
      //     id: 4,
      //     name: 'Lunch with Team',
      //     description: 'Team building lunch',
      //     startTime: DateTime(2025, 8, 3, 12, 30),
      //     endTime: DateTime(2025, 8, 3, 13, 30),
      //     // color: Colors.purple,
      //   ),
      // ],
    };
  }

  // Get events for a specific day
  List<EventCalenderModel> getEventsForDay(DateTime day) {
    return events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  // Get events for a date range
  List<EventCalenderModel> getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final day in days) ...getEventsForDay(day),
    ];
  }

  // Get all events sorted by date
  List<EventCalenderModel> getAllEventsSorted() {
    List<EventCalenderModel> allEvents = [];
    for (final dayEvents in events.values) {
      allEvents.addAll(dayEvents);
    }
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    return allEvents;
  }

  // Helper method to get days in range
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  // Day selection handler
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay.value, selectedDay)) {
      this.selectedDay.value = selectedDay;
      this.focusedDay.value = focusedDay;
      rangeStart.value = null;
      rangeEnd.value = null;
      rangeSelectionMode.value = RangeSelectionMode.toggledOff;
      updateSelectedEvents();
    }
  }

  // Range selection handler
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    selectedDay.value = null;
    this.focusedDay.value = focusedDay;
    rangeStart.value = start;
    rangeEnd.value = end;
    rangeSelectionMode.value = RangeSelectionMode.toggledOn;

    if (start != null && end != null) {
      selectedEvents.value = getEventsForRange(start, end);
    } else if (start != null) {
      selectedEvents.value = getEventsForDay(start);
    } else if (end != null) {
      selectedEvents.value = getEventsForDay(end);
    }
  }

  // Update selected events based on current selection
  void updateSelectedEvents() {
    if (selectedDay.value != null) {
      selectedEvents.value = getEventsForDay(selectedDay.value!);
    }
  }

  // Toggle calendar format
  void toggleCalendarFormat() {
    calendarFormat.value = calendarFormat.value == CalendarFormat.month
        ? CalendarFormat.week
        : CalendarFormat.month;
  }

  // Set tab index
  void setTabIndex(int index) {
    currentTabIndex.value = index;
  }

  // Initialize new event form
  void initializeNewEventForm() {
    titleController.clear();
    descriptionController.clear();
    newEventStartDate.value = selectedDay.value ?? DateTime.now();
    newEventEndDate.value = (selectedDay.value ?? DateTime.now()).add(const Duration(hours: 1));
    isAllDay.value = false;
    selectedColor.value = Colors.blue;
  }

  // Set event color
  void setEventColor(Color color) {
    // selectedColor.value = color;
  }

  // Set all day toggle
  void setAllDay(bool value) {
    isAllDay.value = value;
  }

  // Set start date and time
  void setStartDateTime(DateTime dateTime) {
    newEventStartDate.value = dateTime;
    // Ensure end time is after start time
    if (newEventEndDate.value.isBefore(newEventStartDate.value)) {
      newEventEndDate.value = isAllDay.value
          ? newEventStartDate.value
          : newEventStartDate.value.add(const Duration(hours: 1));
    }
  }

  // Set end date and time
  void setEndDateTime(DateTime dateTime) {
    newEventEndDate.value = dateTime;
    // Ensure end time is after start time
    if (newEventEndDate.value.isBefore(newEventStartDate.value)) {
      newEventEndDate.value = newEventStartDate.value.add(const Duration(hours: 1));
    }
  }

  // Add new event
  void addEvent() {
    if (titleController.text.isEmpty) return;

    final newEvent = EventCalenderModel(
      id: 93,
      name: titleController.text,
      description: descriptionController.text,
      startTime: newEventStartDate.value,
      endTime: newEventEndDate.value,
    );

    final day = DateTime.utc(
      newEventStartDate.value.year,
      newEventStartDate.value.month,
      newEventStartDate.value.day,
    );

    // Add event to the events map
    if (events[day] != null) {
      events[day]!.add(newEvent);
    } else {
      events[day] = [newEvent];
    }

    // Update the observable
    events.refresh();

    // Update selected events if the new event is on the selected day
    if (selectedDay.value != null && isSameDay(day, selectedDay.value!)) {
      updateSelectedEvents();
    }

    // Clear form
    titleController.clear();
    descriptionController.clear();

    // Show success message
    Get.snackbar(
      'Success',
      'Event "${newEvent.name}" added successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Delete event
  void deleteEvent(EventCalenderModel event) {
    final day = DateTime.utc(
      event.startTime.year,
      event.startTime.month,
      event.startTime.day,
    );

    events[day]?.remove(event);

    if (events[day]?.isEmpty ?? false) {
      events.remove(day);
    }

    // Update the observable
    events.refresh();

    // Update selected events
    if (selectedDay.value != null) {
      updateSelectedEvents();
    }

    // Show delete message
    Get.snackbar(
      'Deleted',
      'Event "${event.name}" deleted',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Load events from API or database
  Future<void> loadEventsFromApi() async {
    try {
_isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      


       final failureOrProduct = await eventsUsecase.getCalenderEvents(_paginationFilter.value);


    failureOrProduct.fold((failure) {
      // _isLoading.value = false;
    }, (receivedProduct) async {



print(receivedProduct);


      // Map<DateTime, List<EventCalenderModel>> parsedEvents = parseCalendarEvents(receivedProduct);
print("🖨️🖨️🖨️🖨️🖨️🖨️");
print(receivedProduct);
print("🖨️🖨️🖨️🖨️🖨️🖨️");

events.value = receivedProduct;
update();


// events.value = {
//       DateTime.utc(2025, 7, 31): [
//         EventCalenderModel(
//           id: 0,
//           name: 'Project Deadline',
//           description: 'Submit final project documents',
//           startTime: DateTime(2025, 4, 20, 10, 0),
//           endTime: DateTime(2025, 4, 20, 11, 30),
//           // color: Colors.red,
//         ),
//       ],
//       DateTime.utc(2025, 8, 08): [
//         EventCalenderModel(
//           id:1,
//           name: 'Team Meeting',
//           description: 'Discuss upcoming sprints',
//           startTime: DateTime(2025, 4, 22, 14, 0),
//           endTime: DateTime(2025, 4, 22, 15, 0),
//           // color: Colors.green,
//         ),
//       ],

//       DateTime.utc(2025, 8, 16): [
//         EventCalenderModel(
//           id:1,
//           name: 'Team Meeting',
//           description: 'Discuss upcoming sprints',
//           startTime: DateTime(2025, 4, 22, 14, 0),
//           endTime: DateTime(2025, 4, 22, 15, 0),
//           // color: Colors.green,
//         ),
//       ],
//       DateTime.utc(2025, 8, 03): [
//         EventCalenderModel(
//           id: 3,
//           name: 'Client Call 2 99348',
//           description: 'Project progress update',
//           startTime: DateTime(2025, 8, 3, 9, 0),
//           endTime: DateTime(2025, 8, 3, 10, 0),
//           // color: Colors.orange,
//         ),
//         EventCalenderModel(
//           id: 4,
//           name: 'Lunch with Team',
//           description: 'Team building lunch',
//           startTime: DateTime(2025, 8, 3, 12, 30),
//           endTime: DateTime(2025, 8, 3, 13, 30),
//           // color: Colors.purple,
//         ),
//       ],
//     };



_isLoading.value = false;

update();

      // events.value = receivedProduct;
// print("✅✅✅✅✅");
//   receivedProduct.forEach((dateKey, eventsList) {
       
//         // print(dateKey);
//         events.value = {
//            DateTime.utc(2025, 8, 06): [
//         EventCalenderModel(
//           id: 0,
//           name: 'Project Deadline',
//           description: 'Submit final project documents',
//           startTime: DateTime(2025, 4, 20, 10, 0),
//           endTime: DateTime(2025, 4, 20, 11, 30),
//           // color: Colors.red,
//         ),
//       ]
//         };
        
//       });

//       update();

//       print("✅✅✅✅✅");

//       print(receivedProduct);

//       // receivedProduct.images!
//       //     .add({"id": 0, "file": receivedProduct.image, "type": "image"});

//       // eventModel = receivedProduct;

//       // generateVideoThumb(receivedProduct);

//       // _isLoading.value = false;

      update();

    });

      // Replace this with your actual API call
     
      // final response = await ApiService.getEvents();

      // events.value = response.data;
      
      // For now, just reload sample data.

      // loadSampleData();

      updateSelectedEvents();
      
      Get.snackbar(
        'Success',
        'Events loaded successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load events: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  // Save events to API or database
  Future<void> saveEventsToApi() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Replace this with your actual API call
      // await ApiService.saveEvents(events.value);
      
      Get.snackbar(
        'Success',
        'Events saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save events: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search events by title
  List<EventCalenderModel> searchEvents(String query) {
    if (query.isEmpty) return [];
    
    final allEvents = getAllEventsSorted();
    return allEvents.where((event) =>
      event.name!.toLowerCase().contains(query.toLowerCase()) ||
      event.description!.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get events for a specific month
  List<EventCalenderModel> getEventsForMonth(DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    return getEventsForRange(startOfMonth, endOfMonth);
  }

  // Get upcoming events (next 7 days)
  List<EventCalenderModel> getUpcomingEvents() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return getEventsForRange(now, nextWeek);
  }

  // Alternative: More comprehensive method with error handling
void appendLaravelEventsToCalendarSafe(Map<String, dynamic> laravelResponse) {
  try {
    if (laravelResponse['success'] != true) {
      print('Laravel response indicates failure');
      return;
    }
    
    Map<String, dynamic>? eventData = laravelResponse['data'];
    if (eventData == null) return;
    
    eventData.forEach((dateString, eventList) {
      try {
        // Parse the date string
        DateTime eventDate = DateTime.parse(dateString + 'T00:00:00Z').toUtc();
        
        // Convert events
        List<EventCalenderModel> newEvents = [];
        for (var event in eventList) {
          // Handle potential null values
          int id = event['id'] ?? 0;
          String name = event['name'] ?? 'Unnamed Event';
          String description = event['description'] ?? '';
          
          // Parse start and end times
          DateTime startTime = DateTime.parse(event['startTime'] + 'T00:00:00');
          DateTime endTime = DateTime.parse(event['endTime'] + 'T23:59:59');
          
          newEvents.add(EventCalenderModel(
            id: id,
            name: name,
            description: description,
            startTime: startTime,
            endTime: endTime,
          ));
        }
        
        // Merge with existing events
        if (events.value.containsKey(eventDate)) {
          events.value[eventDate]!.addAll(newEvents);
        } else {
          events.value[eventDate] = newEvents;
        }
        
      } catch (e) {
        print('Error processing date $dateString: $e');
      }
    });
    
    // Update the UI
  
    
  } catch (e) {
    print('Error processing Laravel response: $e');
  }
}

}