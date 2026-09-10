import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:sagr/data/colors.dart';
import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/features/events/data/models/job_model.dart';
import 'package:sagr/features/events/data/models/start_date_time_model.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/features/events/presentation/widgets/event_status_pill.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

/// Accepted-application landing for an event. Premium, compact, celebratory.
///
/// Wires through [EventController] for event data and reuses the shared
/// [EventBottomNavigation] + [EventStatusPill] design tokens. Countdown is
/// driven by the server-provided [StartDateTimeModel] (days/hours/minutes/
/// seconds) with a local 1-second tick so we no longer need the third-party
/// `flutter_timer_countdown` package on this screen.
class EventAcceptScreen extends StatefulWidget {
  const EventAcceptScreen({super.key});

  @override
  State<EventAcceptScreen> createState() => _EventAcceptScreenState();
}

class _EventAcceptScreenState extends State<EventAcceptScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..forward();
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      init: EventController(Get.find()),
      builder: (eventController) {
        final EventModel? event = eventController.event;
        final bool loading = eventController.isLoading;

        return Scaffold(
          backgroundColor: AppTheme.scaffold,
          appBar: AppBar(
            title: Text('Welcome aboard'.tr),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Get.back<void>(),
            ),
          ),
          body: FadeTransition(
            opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
            child: loading || event == null
                ? _buildLoading()
                : _buildContent(context, event),
          ),
          bottomNavigationBar: loading || event == null
              ? null
              : EventBottomNavigation(
                  active: EventNavTab.attendance,
                  eventId: event.id?.toString(),
                ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        AppLoader.box(height: 140, radius: AppTheme.radius),
        const SizedBox(height: 16),
        AppLoader.box(height: 110, radius: AppTheme.radius),
        const SizedBox(height: 16),
        AppLoader.box(height: 80, radius: AppTheme.radius),
        const SizedBox(height: 16),
        AppLoader.box(height: 120, radius: AppTheme.radius),
        const SizedBox(height: 16),
        AppLoader.box(height: 110, radius: AppTheme.radius),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  Widget _buildContent(BuildContext context, EventModel event) {
    final List<JobModel> jobs = event.jobs ?? const <JobModel>[];
    final int rolesCount = jobs.length;
    final int shiftsCount = event.periods?.length ?? 0;
    final String? description = (event.description ?? '').trim().isEmpty
        ? null
        : event.description!.trim();
    final String? location = (event.location ?? '').trim().isEmpty
        ? null
        : event.location!.trim();
    final StartDateTimeModel? sdt = event.startDateTime;
    final bool showCountdown = sdt != null && sdt.status == EventStatus.upcoming;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _HeroCard(eventName: event.name ?? ''),
        const SizedBox(height: 16),

        _StatusRow(status: event.appliedStatus),
        const SizedBox(height: 16),

        if (showCountdown) ...[
          _CountdownCard(startDateTime: sdt),
          const SizedBox(height: 16),
        ],

        _QuickStats(
          date: event.date,
          time: event.time,
          roles: rolesCount,
          shifts: shiftsCount,
        ),
        const SizedBox(height: 16),

        if (location != null) ...[
          _LocationCard(location: location, address: event.address),
          const SizedBox(height: 16),
        ],

        if (description != null) ...[
          _AboutCard(description: description),
          const SizedBox(height: 16),
        ],

        if (jobs.isNotEmpty) ...[
          _RolesChips(jobs: jobs),
          const SizedBox(height: 20),
        ],

        _PrimaryCta(),
        const SizedBox(height: 8),
      ],
    );
  }
}

// =============================================================================
// Hero card — teal brand gradient with success accent.
// =============================================================================

class _HeroCard extends StatelessWidget {
  final String eventName;
  const _HeroCard({required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.brand, AppTheme.brandDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brand.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: WHITE_COLOR.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: WHITE_COLOR.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: WHITE_COLOR,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Application accepted'.tr,
                  style: TextStyle(
                    color: WHITE_COLOR.withOpacity(0.92),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  eventName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: WHITE_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Status row — prominent accepted pill.
// =============================================================================

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.status});

  /// The event's own application status. Hardcoding 'accepted' here made the
  /// pill disagree with the one shown for the same event elsewhere whenever
  /// the backend moved the application on.
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EventStatusPill(status: status ?? 'accepted'),
      ],
    );
  }
}

// =============================================================================
// Countdown — local 1-second tick driven by StartDateTimeModel.
// =============================================================================

class _CountdownCard extends StatefulWidget {
  final StartDateTimeModel startDateTime;
  const _CountdownCard({required this.startDateTime});

  @override
  State<_CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<_CountdownCard> {
  late StartDateTimeModel _value;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _value = widget.startDateTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _value = _value.copyWithDecrementedSecond();
      });
      if (_value.isPast) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined,
                  size: 18, color: AppTheme.brand),
              const SizedBox(width: 8),
              Text(
                'Event starts in'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(child: _TimePill(value: _value.days, label: 'days'.tr)),
                const SizedBox(width: 8),
                Expanded(
                    child: _TimePill(value: _value.hours, label: 'hours'.tr)),
                const SizedBox(width: 8),
                Expanded(
                    child:
                        _TimePill(value: _value.minutes, label: 'minutes'.tr)),
                const SizedBox(width: 8),
                Expanded(
                    child:
                        _TimePill(value: _value.seconds, label: 'seconds'.tr)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final int value;
  final String label;
  const _TimePill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final String txt = value.toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.brand.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: AppTheme.brand.withOpacity(0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            txt,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.navy,
              fontFeatures: _tabular,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Quick stats — 4 inline tiles (Date / Time / Roles / Shifts).
// =============================================================================

class _QuickStats extends StatelessWidget {
  final String? date;
  final String? time;
  final int roles;
  final int shifts;

  const _QuickStats({
    required this.date,
    required this.time,
    required this.roles,
    required this.shifts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.event_outlined,
              label: 'Date'.tr,
              value: _shortDate(date) ?? '—',
            ),
          ),
          _divider(),
          Expanded(
            child: _StatTile(
              icon: Icons.schedule_rounded,
              label: 'Time'.tr,
              value: time ?? '—',
            ),
          ),
          _divider(),
          Expanded(
            child: _StatTile(
              icon: Icons.work_outline_rounded,
              label: 'Roles'.tr,
              value: roles.toString(),
            ),
          ),
          _divider(),
          Expanded(
            child: _StatTile(
              icon: Icons.access_time_rounded,
              label: 'Shifts'.tr,
              value: shifts.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppTheme.line,
      );

  String? _shortDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // Try to parse as ISO; fall back to whatever was provided.
    try {
      final DateTime dt = DateTime.parse(raw);
      return DateFormat('d MMM').format(dt);
    } catch (_) {
      return raw;
    }
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.brand),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTitle,
              fontFeatures: _tabular,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Location card — opens external maps app.
// =============================================================================

class _LocationCard extends StatelessWidget {
  final String location;
  final String? address;

  const _LocationCard({required this.location, this.address});

  @override
  Widget build(BuildContext context) {
    final bool hasAddress = (address ?? '').trim().isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          onTap: () => MapsUtils.openMap(location),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.brand.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.place_outlined,
                      color: AppTheme.brand, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textTitle,
                        ),
                      ),
                      if (hasAddress) ...[
                        const SizedBox(height: 2),
                        Text(
                          address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.brand,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined,
                          size: 14, color: WHITE_COLOR),
                      const SizedBox(width: 6),
                      Text(
                        'Open'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: WHITE_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// About card — event description.
// =============================================================================

class _AboutCard extends StatelessWidget {
  final String description;
  const _AboutCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 18, color: AppTheme.brand),
              const SizedBox(width: 8),
              Text(
                'About'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textBody,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Roles chips — JobModel.name list.
// =============================================================================

class _RolesChips extends StatelessWidget {
  final List<JobModel> jobs;
  const _RolesChips({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.work_outline_rounded,
                  size: 18, color: AppTheme.brand),
              const SizedBox(width: 8),
              Text(
                'Roles'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: jobs.map((j) => _roleChip(j)).toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(JobModel job) {
    final String label = (job.displayName?.isNotEmpty ?? false)
        ? job.displayName!
        : job.name;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.brand.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.brand.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.brandDark,
        ),
      ),
    );
  }
}

// =============================================================================
// Primary CTA — Go to attendance.
// =============================================================================

class _PrimaryCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed<void>('/attendance_screen'),
        icon: const Icon(Icons.campaign_rounded, size: 20),
        label: Text(
          'Go to attendance'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
