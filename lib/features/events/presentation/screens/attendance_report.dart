import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/attendance/domain/entities/attendance.dart';
import 'package:sagr/features/attendance/presentation/controllers/attendance_controller.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

/// Premium, international attendance-report screen.
///
/// Layout: white AppBar -> compact user header -> headline grand-total card ->
/// 2x2 stats grid -> daily ledger grouped by locale-aware date headers.
/// Bottom nav is the unified [EventBottomNavigation] (attendance tab active).
class AttendanceReportPage extends StatelessWidget {
  AttendanceReportPage({Key? key}) : super(key: key);

  final AttendanceController _controller = Get.put(AttendanceController(
    getCurrentUserAttendanceUseCase: Get.find(),
    getAttendanceReportUseCase: Get.find(),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        backgroundColor: WHITE_COLOR,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        title: Text(
          'Attendance Report'.tr,
          style: const TextStyle(
            color: AppTheme.navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar:
          const EventBottomNavigation(active: EventNavTab.attendance),
      body: Obx(() {
        if (_controller.isLoading) {
          return _LoadingSkeleton();
        }
        final attendance = _controller.attendance;
        if (attendance == null) {
          return _EmptyState();
        }
        return RefreshIndicator(
          color: AppTheme.brand,
          onRefresh: _controller.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _UserHeader(attendance: attendance),
              const SizedBox(height: 16),
              _GrandTotalCard(attendance: attendance),
              const SizedBox(height: 16),
              _StatsGrid(attendance: attendance),
              const SizedBox(height: 24),
              _DailyLedger(reports: attendance.dailyReports),
              const SizedBox(height: 8),
            ],
          ),
        );
      }),
    );
  }
}

// ============================================================================
// Loading + empty states
// ============================================================================

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        AppLoader.box(height: 84, radius: AppTheme.radiusLg),
        const SizedBox(height: 16),
        AppLoader.box(height: 150, radius: AppTheme.radiusLg),
        const SizedBox(height: 16),
        AppLoader.box(height: 130, radius: AppTheme.radiusLg),
        const SizedBox(height: 24),
        AppLoader.list(items: 4, showTrailing: false),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.brand.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: AppTheme.brand,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No attendance records yet'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textTitle,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// User header
// ============================================================================

class _UserHeader extends StatelessWidget {
  final Attendance attendance;
  const _UserHeader({required this.attendance});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts[1].characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brand, AppTheme.brandDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(attendance.userName),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attendance.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textTitle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'Employee ID'.tr} · ${attendance.userId}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
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
}

// ============================================================================
// Grand total card
// ============================================================================

class _GrandTotalCard extends StatelessWidget {
  final Attendance attendance;
  const _GrandTotalCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.navy, Color(0xff1e293b)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.brand.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Total Hours'.tr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            attendance.grandTotalFormatted,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              fontFeatures: _tabular,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${attendance.grandTotalHours}h ${attendance.grandTotalMinutes}m',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFeatures: _tabular,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Stats grid (2x2 mini-cards)
// ============================================================================

class _StatsGrid extends StatelessWidget {
  final Attendance attendance;
  const _StatsGrid({required this.attendance});

  @override
  Widget build(BuildContext context) {
    // Compute on-time / late from session attendance times.
    // Heuristic: an event "on-time" if its first session starts <= 08:00.
    // Falls back gracefully when time strings are not parseable.
    int onTime = 0;
    int late = 0;
    int sessionCount = 0;
    for (final r in attendance.dailyReports) {
      sessionCount += r.sessions.length;
      final first = r.attendanceTime.trim();
      final hour = _parseHour(first);
      if (hour == null) continue;
      if (hour <= 8) {
        onTime++;
      } else {
        late++;
      }
    }

    final cells = <_StatCell>[
      _StatCell(
        icon: Icons.event_available_rounded,
        label: 'Events'.tr,
        value: '${attendance.eventTotals.length}',
        tint: AppTheme.brand,
      ),
      _StatCell(
        icon: Icons.layers_rounded,
        label: 'Total Sessions'.tr,
        value: '$sessionCount',
        tint: AppTheme.sky,
      ),
      _StatCell(
        icon: Icons.verified_rounded,
        label: 'On Time'.tr,
        value: '$onTime',
        tint: AppTheme.success,
      ),
      _StatCell(
        icon: Icons.timer_outlined,
        label: 'Late'.tr,
        value: '$late',
        tint: AppTheme.warning,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: cells,
    );
  }

  int? _parseHour(String raw) {
    if (raw.isEmpty) return null;
    final m = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
    if (m == null) return null;
    return int.tryParse(m.group(1)!);
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: tint, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                    height: 1.1,
                    fontFeatures: _tabular,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
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
}

// ============================================================================
// Daily ledger — grouped by date
// ============================================================================

class _DailyLedger extends StatelessWidget {
  final List<DailyReport> reports;
  const _DailyLedger({required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No attendance records yet'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // Group by date string
    final Map<String, List<DailyReport>> grouped = {};
    for (final r in reports) {
      grouped.putIfAbsent(r.date, () => []).add(r);
    }
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
          child: Text(
            'Daily Log'.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTitle,
            ),
          ),
        ),
        for (final date in sortedKeys) ...[
          _DateHeader(date: date),
          const SizedBox(height: 8),
          for (final report in grouped[date]!) ...[
            _DailyRow(report: report),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;
  const _DateHeader({required this.date});

  String _format(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final locale = Get.locale?.toString() ?? 'en';
      return DateFormat.yMMMMEEEEd(locale).format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _format(date),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyReport report;
  const _DailyRow({required this.report});

  bool get _isLate {
    final m = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(report.attendanceTime);
    if (m == null) return false;
    final hour = int.tryParse(m.group(1)!) ?? 0;
    return hour > 8;
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _isLate ? AppTheme.warning : AppTheme.success;
    final String statusLabel = _isLate ? 'Late'.tr : 'On Time'.tr;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textTitle,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.7,
            color: AppTheme.line,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _TimeBlock(
                    icon: Icons.login_rounded,
                    label: 'Check In'.tr,
                    time: report.attendanceTime,
                    color: AppTheme.success,
                  ),
                ),
                Container(
                  width: 0.7,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppTheme.line,
                ),
                Expanded(
                  child: _TimeBlock(
                    icon: Icons.logout_rounded,
                    label: 'Check Out'.tr,
                    time: report.departureTime,
                    color: AppTheme.warning,
                  ),
                ),
                Container(
                  width: 0.7,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: AppTheme.line,
                ),
                Expanded(
                  child: _DurationBlock(
                    label: 'Duration'.tr,
                    value: report.formattedDuration,
                  ),
                ),
              ],
            ),
          ),
          if (report.sessions.length > 1) ...[
            Container(height: 0.7, color: AppTheme.line),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: _SessionsBlock(sessions: report.sessions),
            ),
          ],
          Container(height: 0.7, color: AppTheme.line),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 13, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    report.zoneName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.bar_chart_rounded,
                    size: 13, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${report.recordsCount} ${'Records'.tr}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
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
}

class _TimeBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _TimeBlock({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time.isEmpty ? '—' : time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTitle,
            fontFeatures: _tabular,
          ),
        ),
      ],
    );
  }
}

class _DurationBlock extends StatelessWidget {
  final String label;
  final String value;
  const _DurationBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.timelapse_rounded,
                size: 12, color: AppTheme.brand),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppTheme.brand,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTitle,
            fontFeatures: _tabular,
          ),
        ),
      ],
    );
  }
}

class _SessionsBlock extends StatelessWidget {
  final List<Session> sessions;
  const _SessionsBlock({required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sessions'.tr,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppTheme.textMuted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        for (int i = 0; i < sessions.length; i++) ...[
          _SessionRow(index: i + 1, session: sessions[i]),
          if (i != sessions.length - 1) const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  final int index;
  final Session session;
  const _SessionRow({required this.index, required this.session});

  @override
  Widget build(BuildContext context) {
    final bool stillPresent = session.departure == 'Still present';
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppTheme.brand.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.brand,
              fontFeatures: _tabular,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(
                session.attendance,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textTitle,
                  fontFeatures: _tabular,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded,
                  size: 12, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Text(
                stillPresent ? 'Still present'.tr : session.departure,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: stillPresent
                      ? AppTheme.success
                      : AppTheme.textTitle,
                  fontFeatures: _tabular,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.field,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            session.durationFormatted,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.brand,
              fontFeatures: _tabular,
            ),
          ),
        ),
      ],
    );
  }
}
