
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Event class to store event details
class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue,
    this.isAllDay = false,
  });
}

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({Key? key}) : super(key: key);

  @override
  State<EventCalendarPage> createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> with TickerProviderStateMixin {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _newEventStartDate = DateTime.now();
  DateTime _newEventEndDate = DateTime.now().add(const Duration(hours: 1));
  bool _isAllDay = false;
  Color _selectedColor = Colors.blue;

  // Sample event data
  final Map<DateTime, List<Event>> _events = {
    DateTime.utc(2025, 4, 20): [
      Event(
        title: 'Project Deadline',
        description: 'Submit final project documents',
        startTime: DateTime(2025, 4, 20, 10, 0),
        endTime: DateTime(2025, 4, 20, 11, 30),
        color: Colors.red,
      ),
    ],
    DateTime.utc(2025, 4, 22): [
      Event(
        title: 'Team Meeting',
        description: 'Discuss upcoming sprints',
        startTime: DateTime(2025, 4, 22, 14, 0),
        endTime: DateTime(2025, 4, 22, 15, 0),
        color: Colors.green,
      ),
    ],
    DateTime.utc(2025, 8, 03): [
      Event(
        title: 'Client Call 2',
        description: 'Project progress update',
        startTime: DateTime(2025, 4, 25, 9, 0),
        endTime: DateTime(2025, 4, 25, 10, 0),
        color: Colors.orange,
      ),
      Event(
        title: 'Lunch with Team',
        description: 'Team building lunch',
        startTime: DateTime(2025, 4, 25, 12, 30),
        endTime: DateTime(2025, 4, 25, 13, 30),
        color: Colors.purple,
      ),
    ],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final day in days) ..._getEventsForDay(day),
    ];
  }

  void _addEvent() {
    if (_titleController.text.isEmpty) return;

    final newEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      startTime: _newEventStartDate,
      endTime: _newEventEndDate,
      color: _selectedColor,
      isAllDay: _isAllDay,
    );

    final day = DateTime.utc(_newEventStartDate.year, _newEventStartDate.month, _newEventStartDate.day);
    if (_events[day] != null) {
      _events[day]!.add(newEvent);
    } else {
      _events[day] = [newEvent];
    }

    _titleController.clear();
    _descriptionController.clear();
    setState(() {});

    if (_selectedDay != null && isSameDay(day, _selectedDay)) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }

    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${newEvent.title}" added successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _deleteEvent(Event event) {
    final day = DateTime.utc(event.startTime.year, event.startTime.month, event.startTime.day);
    _events[day]?.remove(event);
    
    if (_events[day]?.isEmpty ?? false) {
      _events.remove(day);
    }
    
    setState(() {
      if (_selectedDay != null) {
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${event.title}" deleted'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Events Calendar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar', icon: Icon(Icons.calendar_month)),
            Tab(text: 'Events List', icon: Icon(Icons.list)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_calendarFormat == CalendarFormat.month
                ? Icons.view_week
                : Icons.calendar_month),
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
            tooltip: 'Toggle calendar format',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarTab(),
          _buildEventsListTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add new event',
      ),
    );
  }

  Widget _buildCalendarTab() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2026, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_busy, size: 50, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            _selectedDay != null
                                ? 'No events for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}'
                                : 'No events selected',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(value[index]);
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventsListTab() {
    // Get all unique events sorted by date
    List<Event> allEvents = [];
    for (final dayEvents in _events.values) {
      allEvents.addAll(dayEvents);
    }
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return allEvents.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No events scheduled',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: allEvents.length,
            itemBuilder: (context, index) {
              // Group events by day
              final event = allEvents[index];
              final bool showHeader = index == 0 ||
                  !isSameDay(event.startTime, allEvents[index - 1].startTime);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(event.startTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  _buildEventCard(event),
                ],
              );
            },
          );
  }

  Widget _buildEventCard(Event event) {
    final timeFormat = DateFormat('h:mm a');
    final timeString = event.isAllDay
        ? 'All Day'
        : '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: event.color.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 12,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(timeString),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteEvent(event),
          tooltip: 'Delete event',
        ),
        onTap: () => _showEventDetails(event),
      ),
    );
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: event.color,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    event.isAllDay
                        ? 'All Day'
                        : '${DateFormat('E, MMM d • h:mm a').format(event.startTime)} - '
                            '${DateFormat('h:mm a').format(event.endTime)}',
                  ),
                ],
              ),
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(event.description),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteEvent(event);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showAddEventDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _newEventStartDate = _selectedDay ?? DateTime.now();
    _newEventEndDate = (_selectedDay ?? DateTime.now()).add(const Duration(hours: 1));
    _isAllDay = false;
    _selectedColor = Colors.blue;

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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Event Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('All Day'),
                      value: _isAllDay,
                      onChanged: (value) {
                        setState(() {
                          _isAllDay = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Start Date & Time'),
                      subtitle: Text(
                        DateFormat(_isAllDay ? 'EEE, MMM d, yyyy' : 'EEE, MMM d, yyyy • h:mm a')
                            .format(_newEventStartDate),
                      ),
                      leading: const Icon(Icons.access_time),
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _newEventStartDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          DateTime dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _newEventStartDate.hour,
                            _newEventStartDate.minute,
                          );
                          
                          if (!_isAllDay) {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_newEventStartDate),
                            );
                            if (time != null) {
                              dateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            }
                          }
                          
                          setState(() {
                            _newEventStartDate = dateTime;
                            // Ensure end time is after start time
                            if (_newEventEndDate.isBefore(_newEventStartDate)) {
                              _newEventEndDate = _isAllDay
                                  ? _newEventStartDate
                                  : _newEventStartDate.add(const Duration(hours: 1));
                            }
                          });
                        }
                      },
                    ),
                    if (!_isAllDay)
                      ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(DateFormat('EEE, MMM d, yyyy • h:mm a').format(_newEventEndDate)),
                        leading: const Icon(Icons.access_time_filled),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _newEventEndDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_newEventEndDate),
                            );
                            if (time != null) {
                              setState(() {
                                _newEventEndDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                
                                // Ensure end time is after start time
                                if (_newEventEndDate.isBefore(_newEventStartDate)) {
                                  _newEventEndDate = _newEventStartDate.add(const Duration(hours: 1));
                                }
                              });
                            }
                          }
                        },
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Event Color',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: colorOptions.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: color,
                            child: _selectedColor == color
                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addEvent,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}