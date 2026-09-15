import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:sagr/data/colors.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import 'package:sagr/walkie_talkie/widgets/push_to_talk_button.dart';

import '../../../evocations/data/models/evocation_model.dart';
import '../../../evocations/presentation/controllers/evocations_controller.dart';
import '../../../evocations/presentation/widgets/evocation_create.dart';
import '../../data/models/job_model.dart';
import '../../data/models/start_date_time_model.dart';
import '../controllers/event_controller.dart';
import 'loading.dart';
import 'package:sagr/widgets/maps/event_location_map.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Premium, compact attendance & departure screen.
/// Compact event hero with live clock → status row → location card with
/// Open-in-Maps CTA → primary Check-In/Out CTA → permissions request →
/// minimal bottom nav. Uses the unified AppTheme tokens; no gimmicky borders.
class AttendanceAndDepartureScreen extends StatefulWidget {
  AttendanceAndDepartureScreen({super.key});

  @override
  State<AttendanceAndDepartureScreen> createState() =>
      _AttendanceAndDepartureScreenState();
}

class _AttendanceAndDepartureScreenState
    extends State<AttendanceAndDepartureScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _clockTimer;
  String _now = '';

  final EventController eventController = Get.put(EventController(Get.find()));
  final EvocationsController evocationsController =
      Get.put(EvocationsController(Get.find()));

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);
    _refreshNow();
    _clockTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(_refreshNow);
    });
  }

  void _refreshNow() {
    _now = DateFormat.jm(_locale).format(DateTime.now());
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _openEvocationSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEvocationBottomSheet(
        eventId: eventController.event?.id,
        zoneId: eventController.event?.zone_id,
        userId: eventController.event?.user_id,
        onEvocationCreated: (EvocationModel e) => evocationsController.apply(e),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CenterCircleOverlay(
          showIndicator: eventController.isLoading,
          isAnimated: true,
          circleColor: Colors.transparent,
          circleSize: 70.0,
          child: Scaffold(
            backgroundColor: AppTheme.scaffold,
            appBar: _appBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  _eventHero(),
                  const SizedBox(height: 12),
                  _countdownCard(),
                  const SizedBox(height: 12),
                  _statusRow(),
                  const SizedBox(height: 12),
                  _quickStats(),
                  const SizedBox(height: 12),
                  _locationCard(),
                  const SizedBox(height: 18),
                  _windowNotice(),
                  _primaryAction(),
                  // Once checked in, the employee can talk on the event's
                  // walkie channel without leaving this screen.
                  if (eventController.isCheckedIn &&
                      (eventController.event?.channel?.channelName ?? '')
                          .isNotEmpty) ...[
                    const SizedBox(height: 12),
                    PushToTalkButton(
                      key: ValueKey(
                          eventController.event!.channel!.channelName),
                      channelName:
                          eventController.event!.channel!.channelName,
                      eventId: eventController.event!.id,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _hint(),
                  const SizedBox(height: 16),
                  _aboutCard(),
                  _rolesSection(),
                  _permissionsCard(),
                ],
              ),
            ),
            bottomNavigationBar: EventBottomNavigation(
              active: EventNavTab.attendance,
              eventId: eventController.event?.id?.toString(),
            ),
          ),
        ));
  }

  // ---- AppBar ----
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: WHITE_COLOR,
      foregroundColor: AppTheme.textTitle,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'Attendance & Departure'.tr,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textTitle,
        ),
      ),
    );
  }

  // ---- Event hero with live clock ----
  Widget _eventHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.brand, AppTheme.brandDark],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brand.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventController.event?.name ?? 'Event'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Live attendance window'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time_rounded,
                    color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  _now,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFeatures: _tabular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Status row (pulse dot + label + icon) ----
  Widget _statusRow() {
    final bool checkedIn = eventController.isCheckedIn;
    final Color color = checkedIn ? AppTheme.warning : AppTheme.success;
    final String label = eventController.isLoading
        ? 'Processing...'.tr
        : checkedIn
            ? 'Checked In'.tr
            : 'Ready to Check In'.tr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.15).animate(
              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
            ),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.40), blurRadius: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(
            checkedIn
                ? Icons.timer_outlined
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 18,
          ),
        ],
      ),
    );
  }

  // ---- Location card with Open-in-Maps CTA ----
  Widget _locationCard() {
    final String address = (eventController.event?.address?.isNotEmpty == true
            ? eventController.event!.address!
            : null) ??
        'Event Location'.tr;

    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: EventLocationMap(
                zone: eventController.event?.zoneCoordinates ?? const [],
                locationUrl: eventController.event?.location,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.navy.withOpacity(0.0),
                      AppTheme.navy.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 12, right: 12, child: _gpsChip()),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _addressBar(address),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gpsChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_fixed_rounded, color: AppTheme.success, size: 14),
          SizedBox(width: 5),
          Text(
            'GPS',
            style: TextStyle(
              color: AppTheme.success,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressBar(String address) {
    final hasLocation = (eventController.event?.location ?? '').isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppTheme.brand, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textTitle,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: hasLocation
                ? () => MapsUtils.openMap(eventController.event!.location!)
                : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasLocation
                    ? AppTheme.navy
                    : AppTheme.navy.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.navigation_rounded,
                      color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    'Open'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Warns when the event isn't running yet, without blocking the action —
  /// the server has the final say, and nothing in the app checked the window
  /// at all before this.
  Widget _windowNotice() {
    final sdt = eventController.event?.startDateTime;
    if (sdt == null || sdt.isWorkingNow) return const SizedBox.shrink();

    final finished = sdt.isFinished;
    final color = finished ? AppTheme.textMuted : AppTheme.warning;
    final text = finished
        ? 'This event has ended. Attendance may be rejected.'.tr
        : 'This event has not started yet. Attendance may be rejected.'.tr;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.40)),
      ),
      child: Row(
        children: [
          Icon(
            finished ? Icons.event_busy_rounded : Icons.schedule_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppTheme.textBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Primary check-in / check-out CTA ----
  Widget _primaryAction() {
    final bool checkedIn = eventController.isCheckedIn;
    final bool loading = eventController.isLoading;
    final Color color = checkedIn ? AppTheme.danger : AppTheme.success;
    final Color dark =
        checkedIn ? const Color(0xffdc2626) : const Color(0xff15803d);
    final String label = checkedIn ? 'Check Out'.tr : 'Check In'.tr;
    final IconData icon =
        checkedIn ? Icons.logout_rounded : Icons.fingerprint_rounded;

    return GestureDetector(
      onTap: loading
          ? null
          : () => eventController.attendanceCheckInOut(
              checkedIn ? 'departure' : 'attendance'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, dark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.32),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: loading
                  ? AppLoader.inline(size: 18, color: Colors.white)
                  : Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline_rounded,
            size: 14, color: AppTheme.textMuted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Tap to record your attendance'.tr,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ---- Permissions request row ----
  Widget _permissionsCard() {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _openEvocationSheet,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.line),
            boxShadow: [
              BoxShadow(
                color: AppTheme.navy.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment_outlined,
                    color: AppTheme.brand, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Permissions'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Submit a leave or permission request'.tr,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isRtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppTheme.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Countdown card ----
  Widget _countdownCard() {
    final StartDateTimeModel? sdt = eventController.event?.startDateTime;
    if (sdt == null) return const SizedBox.shrink();

    final Color statusColor = Color(sdt.status?.colorValue ?? 0xFF2196F3);
    final String label = sdt.isFinished
        ? 'Event ended'.tr
        : sdt.isActive
            ? 'Event in progress'.tr
            : 'Event starts in'.tr;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statusBadge(sdt.statusText.tr, statusColor),
              const Spacer(),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (!sdt.isFinished) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _timeBox('${sdt.days}', 'days'.tr),
                const SizedBox(width: 8),
                _timeBox(sdt.hours.toString().padLeft(2, '0'), 'hours'.tr),
                const SizedBox(width: 8),
                _timeBox(sdt.minutes.toString().padLeft(2, '0'), 'minutes'.tr),
                const SizedBox(width: 8),
                _timeBox(sdt.seconds.toString().padLeft(2, '0'), 'seconds'.tr),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.field,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textTitle,
                height: 1,
                fontFeatures: _tabular,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Quick stats row ----
  Widget _quickStats() {
    final e = eventController.event;
    final int periodsCount = e?.periods?.length ?? 0;
    final int jobsCount = e?.jobs?.length ?? 0;
    return Row(
      children: [
        _stat(Icons.calendar_today_rounded, e?.date ?? '—', 'Date'.tr),
        const SizedBox(width: 8),
        _stat(Icons.access_time_rounded, _fmtTime(e?.time), 'Time'.tr),
        const SizedBox(width: 8),
        _stat(Icons.work_outline_rounded, '$jobsCount', 'Roles'.tr),
        const SizedBox(width: 8),
        _stat(Icons.event_repeat_rounded, '$periodsCount', 'Shifts'.tr),
      ],
    );
  }

  /// "00:00:00 AM" overflows a quarter-width tile; seconds add nothing here.
  String _fmtTime(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final m = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*([AaPp][Mm])?')
        .firstMatch(raw.trim());
    if (m == null) return raw;
    final suffix = m.group(3);
    final hhmm = '${m.group(1)}:${m.group(2)}';
    return suffix == null ? hhmm : '$hhmm ${suffix.toUpperCase()}';
  }

  Widget _stat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.line),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppTheme.brand),
            const SizedBox(height: 4),
            // Dates and clock times are LTR strings even in this RTL layout.
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textTitle,
                  fontFeatures: _tabular,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- About card (event description) ----
  Widget _aboutCard() {
    final String desc = eventController.event?.description ?? '';
    if (desc.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _sectionCard(
        title: 'About'.tr,
        icon: Icons.info_outline_rounded,
        child: Text(
          desc,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppTheme.textBody,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ---- Roles section (event jobs) ----
  Widget _rolesSection() {
    final List<JobModel> jobs = eventController.event?.jobs ?? [];
    if (jobs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _sectionCard(
        title: 'Roles'.tr,
        icon: Icons.work_outline_rounded,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: jobs
              .map((j) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.brand.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      j.name,
                      style: const TextStyle(
                        color: AppTheme.brand,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.brand),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textTitle,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Location utilities (still imported by [EventController]). Kept in this file
/// for backwards compatibility — should eventually move to its own service file.
class SagrLocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<Position?> getLocationWithSettings({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
