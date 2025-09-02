import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/events/presentation/controllers/event_calender_controller.dart';
import 'package:table_calendar/table_calendar.dart';


class EventsCalenderScreen extends StatefulWidget {
  @override
  _EventsCalenderScreenState createState() => _EventsCalenderScreenState();
}

class _EventsCalenderScreenState extends State<EventsCalenderScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

final EventCalendarController _controller = Get.put(EventCalendarController(Get.find()));
  // Sample events (normalize dates)
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 2, 14): ['Valentine’s Day Event'],
    DateTime(2025, 2, 20): ['Meeting with John', 'Project Deadline','Project Deadline','Project Deadline','Project Deadline'],
    DateTime(2025, 2, 28): ['Flutter Workshop'],
  };

  // Normalize the date (remove time part)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Event Calendar")),
      body: Obx(() => _controller.isLoading? Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: [
          // Calendar Widget
          TableCalendar(
            // locale: "ar_AR",
             locale: "ar",
            availableCalendarFormats: {
              CalendarFormat.month: 'شهر',
              CalendarFormat.twoWeeks: 'أسبوعان',
              CalendarFormat.week: 'أسبوع',
            },

             onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = _normalizeDate(selectedDay);
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => _events[_normalizeDate(day)] ?? [],
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: BLACK_COLOR,
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
              ),
              
            ),
          ),
          
          SizedBox(height: 20),

          // Display events of the selected day
          Expanded(
            child: _events[_selectedDay]?.isNotEmpty == true
                ? ListView.builder(
                    itemCount: _events[_selectedDay]!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.event, color: Colors.blue),
                        title: Text(_events[_selectedDay]![index]),
                      );
                    },
                  )
                : Center(child: Text("No Events on this day")),
          ),
        ],
      )),
    );
  }
}