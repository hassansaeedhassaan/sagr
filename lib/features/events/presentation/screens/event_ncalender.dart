import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/events/data/models/event_calender_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/event_calender_controller.dart';

class EventCalendarPage extends StatelessWidget {
  const EventCalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final EventCalendarController controller = Get.put(EventCalendarController(Get.find()));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Events Calendar'),
          bottom: TabBar(
            onTap: (index) => controller.setTabIndex(index),
            tabs: const [
              Tab(text: 'Calendar', icon: Icon(Icons.calendar_month)),
              Tab(text: 'Events List', icon: Icon(Icons.list)),
            ],
          ),
          actions: [
            Obx(() => IconButton(
              icon: Icon(controller.calendarFormat.value == CalendarFormat.month
                  ? Icons.view_week
                  : Icons.calendar_month),
              onPressed: controller.toggleCalendarFormat,
              tooltip: 'Toggle calendar format',
            )),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.loadEventsFromApi,
              tooltip: 'Refresh events',
            ),
          ],
        ),
        body: Obx( () => controller.isLoading ? Center(child: CircularProgressIndicator(),) : TabBarView(
          children: [
            _buildCalendarTab(controller),
            _buildEventsListTab(controller),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEventDialog(controller),
          child: const Icon(Icons.add),
          tooltip: 'Add new event',
        ),
      ),
    );
  }

  Widget _buildCalendarTab(EventCalendarController controller) {
    return Column(
      children: [
        Obx(() => TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2026, 12, 31),
          focusedDay: controller.focusedDay.value,
          selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
          rangeStartDay: controller.rangeStart.value,
          rangeEndDay: controller.rangeEnd.value,
          calendarFormat: controller.calendarFormat.value,
          rangeSelectionMode: controller.rangeSelectionMode.value,
          eventLoader: controller.getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Get.theme.primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onDaySelected: controller.onDaySelected,
          onRangeSelected: controller.onRangeSelected,
          onFormatChanged: (format) {
            if (controller.calendarFormat.value != format) {
              controller.calendarFormat.value = format;
            }
          },
          onPageChanged: (focusedDay) {
            controller.focusedDay.value = focusedDay;
          },
        )),
        const SizedBox(height: 8.0),
        Expanded(
          child: Obx(() {
            final selectedEvents = controller.selectedEvents;
            return selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_busy, size: 50, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          controller.selectedDay.value != null
                              ? 'No events for ${DateFormat('MMM d, yyyy').format(controller.selectedDay.value!)}'
                              : 'No events selected',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(selectedEvents[index], controller);
                    },
                  );
          }),
        ),
      ],
    );
  }

  Widget _buildEventsListTab(EventCalendarController controller) {
    return Obx(() {
      final allEvents = controller.getAllEventsSorted();
      
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
                    _buildEventCard(event, controller),
                  ],
                );
              },
            );
    });
  }

  Widget _buildEventCard(EventCalenderModel event, EventCalendarController controller) {
    final timeFormat = DateFormat('h:mm a');
    final timeString =  'All Day';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber!.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 12,
          decoration: BoxDecoration(
            color: PURPLE_COLOR,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        title: Text(
          event.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(timeString),
            if (event.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                event.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => controller.deleteEvent(event),
          tooltip: 'Delete event',
        ),
        onTap: () => _showEventDetails(event, controller),
      ),
    );
  }

  void _showEventDetails(EventCalenderModel event, EventCalendarController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: PURPLE_COLOR,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 8),
                Text('All Day'
                ),
              ],
            ),
            if (event.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(event.description!),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.deleteEvent(event);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAddEventDialog(EventCalendarController controller) {
    controller.initializeNewEventForm();

    Get.bottomSheet(
      Obx(() => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
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
                value: controller.isAllDay.value,
                onChanged: controller.setAllDay,
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Start Date & Time'),
                subtitle: Text(
                  DateFormat(controller.isAllDay.value ? 'EEE, MMM d, yyyy' : 'EEE, MMM d, yyyy • h:mm a')
                      .format(controller.newEventStartDate.value),
                ),
                leading: const Icon(Icons.access_time),
                onTap: () => _selectStartDateTime(controller),
              ),
              if (!controller.isAllDay.value)
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(DateFormat('EEE, MMM d, yyyy • h:mm a').format(controller.newEventEndDate.value)),
                  leading: const Icon(Icons.access_time_filled),
                  onTap: () => _selectEndDateTime(controller),
                ),
              const SizedBox(height: 16),
              const Text(
                'Event Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: controller.colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () => controller.setEventColor(color),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: color,
                      child: controller.selectedColor.value == color
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
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.addEvent();
                      Get.back();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
      isScrollControlled: true,
    );
  }

  Future<void> _selectStartDateTime(EventCalendarController controller) async {
    final DateTime? date = await Get.to(() => CalendarDatePicker(
      initialDate: controller.newEventStartDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      onDateChanged: (date) => Get.back(result: date),
    ));

    if (date != null) {
      DateTime dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        controller.newEventStartDate.value.hour,
        controller.newEventStartDate.value.minute,
      );

      if (!controller.isAllDay.value) {
        final TimeOfDay? time = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.fromDateTime(controller.newEventStartDate.value),
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

      controller.setStartDateTime(dateTime);
    }
  }

  Future<void> _selectEndDateTime(EventCalendarController controller) async {
    final DateTime? date = await Get.to(() => CalendarDatePicker(
      initialDate: controller.newEventEndDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      onDateChanged: (date) => Get.back(result: date),
    ));

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(controller.newEventEndDate.value),
      );
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        controller.setEndDateTime(dateTime);
      }
    }
  }
}