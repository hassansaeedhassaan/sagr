import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:sagr/data/colors.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../../data/models/job_model.dart';
import '../../data/models/start_date_time_model.dart';
import '../controllers/event_controller.dart';
import '../widgets/event_status_pill.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Premium, compact "application pending" screen.
///
/// Shown when the user's application status is `pending` — awaiting a decision
/// from the organizer. Surfaces a calm amber review banner with a three-step
/// timeline (Submitted → Under Review → Decision), an event hero, countdown,
/// quick stats, location card and roles wrap. Uses the shared AppTheme tokens
/// and the unified [EventBottomNavigation].
class EventProcessingScreen extends StatefulWidget {
  const EventProcessingScreen({super.key});

  @override
  State<EventProcessingScreen> createState() => _EventProcessingScreenState();
}

class _EventProcessingScreenState extends State<EventProcessingScreen>
    with SingleTickerProviderStateMixin {
  final EventController eventController = Get.put(EventController(Get.find()));

  late final AnimationController _fade;
  late final Animation<double> _fadeAnim;

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fade, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await eventController.getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: _appBar(),
      body: GetBuilder<EventController>(
        init: eventController,
        builder: (c) {
          if (c.isLoading && c.event == null) return _shimmer();
          return FadeTransition(
            opacity: _fadeAnim,
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppTheme.brand,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reviewBanner(),
                    const SizedBox(height: 12),
                    _timelineCard(),
                    const SizedBox(height: 12),
                    _eventHero(c),
                    const SizedBox(height: 12),
                    _countdownCard(c),
                    const SizedBox(height: 12),
                    _quickStats(c),
                    const SizedBox(height: 12),
                    _locationCard(c),
                    const SizedBox(height: 12),
                    _aboutCard(c),
                    _rolesSection(c),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: EventBottomNavigation(
        active: EventNavTab.attendance,
        eventId: eventController.event?.id?.toString(),
      ),
    );
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
        'Application Status'.tr,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textTitle,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12, left: 12),
          child: Center(
            child: EventStatusPill(status: 'pending', compact: true),
          ),
        ),
      ],
    );
  }

  // ---- Amber review banner ----
  Widget _reviewBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.warning.withOpacity(0.16),
            AppTheme.warning.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.warning.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: AppTheme.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application under review'.tr,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "We'll notify you once a decision is made".tr,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Three-step timeline (Submitted → Under Review → Decision) ----
  Widget _timelineCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _timelineStep(
            icon: Icons.check_rounded,
            label: 'Submitted'.tr,
            state: _StepState.done,
          ),
          _timelineConnector(active: true),
          _timelineStep(
            icon: Icons.hourglass_bottom_rounded,
            label: 'Under Review'.tr,
            state: _StepState.current,
          ),
          _timelineConnector(active: false),
          _timelineStep(
            icon: Icons.flag_outlined,
            label: 'Decision'.tr,
            state: _StepState.pending,
          ),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required IconData icon,
    required String label,
    required _StepState state,
  }) {
    late final Color bg;
    late final Color fg;
    late final Color textColor;
    late final FontWeight fontWeight;
    switch (state) {
      case _StepState.done:
        bg = AppTheme.success;
        fg = Colors.white;
        textColor = AppTheme.textTitle;
        fontWeight = FontWeight.w700;
        break;
      case _StepState.current:
        bg = AppTheme.warning;
        fg = Colors.white;
        textColor = AppTheme.warning;
        fontWeight = FontWeight.w800;
        break;
      case _StepState.pending:
        bg = AppTheme.field;
        fg = AppTheme.textMuted;
        textColor = AppTheme.textMuted;
        fontWeight = FontWeight.w600;
        break;
    }
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: state == _StepState.current
                  ? [
                      BoxShadow(
                        color: AppTheme.warning.withOpacity(0.32),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: fg, size: 17),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineConnector({required bool active}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: 22,
        height: 2,
        decoration: BoxDecoration(
          color: active ? AppTheme.success : AppTheme.line,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ---- Event hero (teal gradient) ----
  Widget _eventHero(EventController c) {
    final String name = c.event?.name?.isNotEmpty == true
        ? c.event!.name!
        : 'Event'.tr;
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
            child: const Icon(
              Icons.event_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _heroDate(c),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _heroDate(EventController c) {
    final raw = c.event?.date;
    if (raw == null || raw.isEmpty) return c.event?.datetime ?? '';
    try {
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        return DateFormat.yMMMMd(_locale).format(dt);
      }
    } catch (_) {}
    return raw;
  }

  // ---- Countdown card ----
  Widget _countdownCard(EventController c) {
    final StartDateTimeModel? sdt = c.event?.startDateTime;
    if (sdt == null) return const SizedBox.shrink();

    final Color statusColor =
        Color(sdt.status?.colorValue ?? AppTheme.warning.value);
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
  Widget _quickStats(EventController c) {
    final e = c.event;
    final int periodsCount = e?.periods?.length ?? 0;
    final int jobsCount = e?.jobs?.length ?? 0;
    return Row(
      children: [
        _stat(Icons.calendar_today_rounded, _heroDate(c).isNotEmpty
            ? _heroDate(c)
            : (e?.date ?? '—'), 'Date'.tr),
        const SizedBox(width: 8),
        _stat(Icons.access_time_rounded, e?.time ?? '—', 'Time'.tr),
        const SizedBox(width: 8),
        _stat(Icons.work_outline_rounded, '$jobsCount', 'Roles'.tr),
        const SizedBox(width: 8),
        _stat(Icons.event_repeat_rounded, '$periodsCount', 'Shifts'.tr),
      ],
    );
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
            Text(
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

  // ---- Location card with Open-in-Maps CTA ----
  Widget _locationCard(EventController c) {
    final String address = (c.event?.address?.isNotEmpty == true
            ? c.event!.address!
            : null) ??
        'Event Location'.tr;
    final bool hasLocation = (c.event?.location ?? '').isNotEmpty;

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
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
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
              child: _addressBar(address, hasLocation, c),
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

  Widget _addressBar(String address, bool hasLocation, EventController c) {
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
                ? () => MapsUtils.openMap(c.event?.location ?? '')
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

  // ---- About card ----
  Widget _aboutCard(EventController c) {
    final String desc = c.event?.description ?? '';
    if (desc.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _sectionCard(
        title: 'About'.tr,
        icon: Icons.info_outline_rounded,
        child: Text(
          desc,
          maxLines: 5,
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

  // ---- Roles (jobs) chip wrap ----
  Widget _rolesSection(EventController c) {
    final List<JobModel> jobs = c.event?.jobs ?? [];
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

  // ---- Shimmer / skeleton loader ----
  Widget _shimmer() {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Bone(width: double.infinity, height: 64, radius: 14),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 86, radius: 14),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 80, radius: 18),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 96, radius: 14),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 64, radius: 12),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 170, radius: 18),
            SizedBox(height: 12),
            Bone(width: double.infinity, height: 110, radius: 14),
          ],
        ),
      ),
    );
  }
}

enum _StepState { done, current, pending }
