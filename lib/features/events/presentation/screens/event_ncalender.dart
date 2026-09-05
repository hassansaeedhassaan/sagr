import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:sagr/data/colors.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../../data/models/event_calender_model.dart';
import '../controllers/event_calender_controller.dart';
import '../widgets/event_status_pill.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Premium, compact, international events calendar.
/// Two views: a refined month calendar with status-colored markers and a
/// month-grouped list. Both reuse the unified [EventStatusPill] design system.
class EventCalendarPage extends StatelessWidget {
  const EventCalendarPage({super.key});

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  Widget build(BuildContext context) {
    final EventCalendarController controller =
        Get.put(EventCalendarController(Get.find()));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.scaffold,
        appBar: _appBar(controller),
        body: Obx(() => controller.isLoading
            ? const Padding(
                padding: EdgeInsets.only(top: 16),
                child: _CalendarSkeleton(),
              )
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _calendarTab(controller),
                  _listTab(controller),
                ],
              )),
      ),
    );
  }

  // ---- AppBar with premium pill-style segmented tab ----
  PreferredSizeWidget _appBar(EventCalendarController c) {
    return AppBar(
      backgroundColor: WHITE_COLOR,
      foregroundColor: AppTheme.textTitle,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'Events Calendar',
        style: TextStyle(
          color: AppTheme.textTitle,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppTheme.textTitle, size: 22),
            onPressed: c.loadEventsFromApi,
            tooltip: 'Refresh',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.field,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textMuted,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
              indicator: BoxDecoration(
                color: AppTheme.brand,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.brand.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: c.setTabIndex,
              tabs: const [
                Tab(text: 'Calendar'),
                Tab(text: 'List'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- Calendar tab ----
  Widget _calendarTab(EventCalendarController c) {
    return Column(
      children: [
        _calendarCard(c),
        const SizedBox(height: 4),
        Expanded(child: _daySection(c)),
      ],
    );
  }

  Widget _calendarCard(EventCalendarController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line),
          boxShadow: [
            BoxShadow(
              color: AppTheme.navy.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(() => TableCalendar<EventCalenderModel>(
                locale: _locale,
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: c.focusedDay.value,
                selectedDayPredicate: (day) =>
                    isSameDay(c.selectedDay.value, day),
                rangeStartDay: c.rangeStart.value,
                rangeEndDay: c.rangeEnd.value,
                calendarFormat: c.calendarFormat.value,
                rangeSelectionMode: c.rangeSelectionMode.value,
                eventLoader: c.getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                availableGestures: AvailableGestures.horizontalSwipe,
                daysOfWeekHeight: 28,
                rowHeight: 44,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  cellMargin: const EdgeInsets.all(4),
                  defaultTextStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textTitle,
                    fontFeatures: _tabular,
                  ),
                  weekendTextStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textTitle,
                    fontFeatures: _tabular,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppTheme.brand,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    fontFeatures: _tabular,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppTheme.brand.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.brand, width: 1.2),
                  ),
                  todayTextStyle: const TextStyle(
                    color: AppTheme.brand,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    fontFeatures: _tabular,
                  ),
                  rangeHighlightColor: AppTheme.brand.withOpacity(0.10),
                  rangeStartDecoration: const BoxDecoration(
                      color: AppTheme.brand, shape: BoxShape.circle),
                  rangeEndDecoration: const BoxDecoration(
                      color: AppTheme.brand, shape: BoxShape.circle),
                  withinRangeTextStyle: const TextStyle(
                    color: AppTheme.textTitle,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFeatures: _tabular,
                  ),
                  markersMaxCount: 0, // overridden by markerBuilder
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textTitle,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded,
                      color: AppTheme.textTitle, size: 24),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded,
                      color: AppTheme.textTitle, size: 24),
                  headerPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                  weekendStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
                calendarBuilders: CalendarBuilders<EventCalenderModel>(
                  markerBuilder: (ctx, day, events) {
                    if (events.isEmpty) return const SizedBox.shrink();
                    final colors = events
                        .take(3)
                        .map((e) => eventStatusStyle(e.appliedStatus).color)
                        .toList();
                    return Positioned(
                      bottom: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < colors.length; i++) ...[
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: colors[i],
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (i != colors.length - 1)
                              const SizedBox(width: 2),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                onDaySelected: c.onDaySelected,
                onRangeSelected: c.onRangeSelected,
                onFormatChanged: (f) {
                  if (c.calendarFormat.value != f) {
                    c.calendarFormat.value = f;
                  }
                },
                onPageChanged: (d) => c.focusedDay.value = d,
              )),
        ),
      ),
    );
  }

  Widget _daySection(EventCalendarController c) {
    return Obx(() {
      final selected = c.selectedDay.value;
      final list = c.selectedEvents;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected != null
                        ? DateFormat.yMMMMEEEEd(_locale).format(selected)
                        : 'Select a date',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textTitle,
                    ),
                  ),
                ),
                if (list.isNotEmpty) _countChip(list.length),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? _emptyDay()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 2, bottom: 16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) => _eventTile(list[i]),
                  ),
          ),
        ],
      );
    });
  }

  Widget _countChip(int n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.brand.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$n',
        style: const TextStyle(
          color: AppTheme.brand,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          fontFeatures: _tabular,
        ),
      ),
    );
  }

  // ---- List tab — grouped by year-month ----
  Widget _listTab(EventCalendarController c) {
    return Obx(() {
      final all = c.getAllEventsSorted();
      if (all.isEmpty) return _emptyAll();

      final groups = <String, List<EventCalenderModel>>{};
      for (final e in all) {
        final key = DateFormat.yMMMM(_locale).format(e.startTime);
        groups.putIfAbsent(key, () => []).add(e);
      }
      final entries = groups.entries.toList();

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: entries.length,
        itemBuilder: (ctx, i) {
          final g = entries[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.brand,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      g.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textTitle,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _countChip(g.value.length),
                  ],
                ),
              ),
              for (final e in g.value) _eventTile(e),
            ],
          );
        },
      );
    });
  }

  // ---- Event tile — premium compact, status-aware navigation ----
  Widget _eventTile(EventCalenderModel event) {
    final statusColor = eventStatusStyle(event.appliedStatus).color;
    final desc = event.description ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => openEventByStatus(event.id, event.appliedStatus),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateBadge(event.startTime, statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppTheme.textTitle,
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 13, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _rangeText(event),
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppTheme.textMuted,
                                fontFeatures: _tabular,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          desc,
                          style: const TextStyle(
                              fontSize: 11.5, color: AppTheme.textMuted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                EventStatusPill(status: event.appliedStatus, compact: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateBadge(DateTime dt, Color accent) {
    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat.MMM(_locale).format(dt).toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat.d(_locale).format(dt),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textTitle,
              height: 1,
              fontFeatures: _tabular,
            ),
          ),
        ],
      ),
    );
  }

  // Locale-aware start → end range.
  String _rangeText(EventCalenderModel e) {
    final loc = _locale;
    final dfShort = DateFormat.MMMd(loc);
    final dfFull = DateFormat.yMMMMd(loc);
    final tf = DateFormat.jm(loc);
    final sameDay = e.startTime.year == e.endTime.year &&
        e.startTime.month == e.endTime.month &&
        e.startTime.day == e.endTime.day;
    if (sameDay) {
      return '${dfFull.format(e.startTime)} · ${tf.format(e.startTime)} – ${tf.format(e.endTime)}';
    }
    return '${dfShort.format(e.startTime)} ${tf.format(e.startTime)} → ${dfShort.format(e.endTime)} ${tf.format(e.endTime)}';
  }

  // ---- Empty states ----
  Widget _emptyDay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: AppTheme.field, shape: BoxShape.circle),
            child: const Icon(Icons.event_busy_rounded,
                size: 26, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 10),
          const Text(
            'No events on this day',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyAll() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: AppTheme.field, shape: BoxShape.circle),
            child: const Icon(Icons.calendar_today_rounded,
                size: 30, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 14),
          const Text(
            'No events scheduled',
            style: TextStyle(
              color: AppTheme.textTitle,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your events will appear here',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Subtle skeleton for the calendar card while events load.
class _CalendarSkeleton extends StatelessWidget {
  const _CalendarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: AppShimmer(
        child: Column(
          children: [
            Bone(width: double.infinity, height: 320, radius: 16),
            const SizedBox(height: 16),
            Bone(width: double.infinity, height: 70, radius: 14),
            const SizedBox(height: 10),
            Bone(width: double.infinity, height: 70, radius: 14),
          ],
        ),
      ),
    );
  }
}
