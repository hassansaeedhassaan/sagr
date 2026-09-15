import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:sagr/data/colors.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/features/events/data/models/job_model.dart';
import 'package:sagr/features/events/data/models/period_model.dart';
import 'package:sagr/features/events/data/models/start_date_time_model.dart';
import 'package:sagr/features/events/presentation/widgets/event_status_pill.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../controllers/event_controller.dart';
import 'pdf_viewer_screen.dart';

/// Tabular-figure feature used for countdown / numeric stats so digits never
/// jitter when the value changes.
const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

/// Premium event details screen. Also rendered for the `initAccept` status —
/// in that case the bottom of the page exposes an accept/reject action row
/// that delegates back to [EventController.contractDecisions].
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final EventController _eventController =
      Get.put(EventController(Get.find()));

  bool _descExpanded = false;
  bool _isAccepted = false;
  bool _isRejected = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Accept / Reject (initAccept flow)
  // ---------------------------------------------------------------------------

  Future<void> _handleDecision(bool isAccept) async {
    HapticFeedback.lightImpact();
    setState(() {
      _isAccepted = isAccept;
      _isRejected = !isAccept;
    });

    // Confirm only once the server has saved the decision; the dialog used to
    // appear even when the request failed.
    final saved = await _eventController
        .contractDecisions(isAccept ? 'accepted' : 'rejected');
    if (!mounted) return;
    if (saved) {
      _showStatusDialog(isAccept);
    } else {
      setState(() {
        _isAccepted = false;
        _isRejected = false;
      });
    }
  }

  void _showStatusDialog(bool isAccept) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.line),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (isAccept ? AppTheme.success : AppTheme.danger)
                      .withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAccept ? Icons.check_rounded : Icons.close_rounded,
                  color: isAccept ? AppTheme.success : AppTheme.danger,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isAccept ? 'accepted'.tr : 'rejected'.tr,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTitle,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAccept ? AppTheme.success : AppTheme.danger,
                  ),
                  child: Text('OK'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PDF attachment viewer
  // ---------------------------------------------------------------------------

  bool get _hasAttachment {
    final a = _eventController.event?.attachment;
    return a != null && a.isNotEmpty && a != 'undefined';
  }

  /// Admin-panel contracts are stored as `contracts/…` on Laravel's public
  /// disk, which is served under /storage/; company-panel uploads are already
  /// public under /uploads/.
  String _attachmentUrl(String path) {
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path.substring(1) : path;
    if (p.startsWith('uploads/') || p.startsWith('storage/')) {
      return '$HOSTURL$p';
    }
    return '${HOSTURL}storage/$p';
  }

  void _openAttachment() {
    final attachment = _eventController.event?.attachment;
    if (attachment == null || attachment.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PdfViewerScreen(
          url: _attachmentUrl(attachment),
          title: 'Attachment'.tr,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: _buildAppBar(),
      body: GetBuilder<EventController>(
        init: _eventController,
        builder: (c) {
          if (c.isLoading || c.event == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  AppLoader.box(height: 160),
                  const SizedBox(height: 16),
                  AppLoader.box(height: 120),
                  const SizedBox(height: 16),
                  Expanded(child: AppLoader.list(items: 3, showTrailing: false)),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeCtrl,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroCard(event: c.event!),
                        const SizedBox(height: 16),
                        _CountdownCard(start: c.event!.startDateTime),
                        const SizedBox(height: 16),
                        _QuickStatsRow(
                          date: c.event!.date,
                          time: c.event!.time,
                          rolesCount: _validJobs(c.event!.jobs).length,
                          shiftsCount: _validPeriods(c.event!.periods).length,
                        ),
                        const SizedBox(height: 16),
                        _LocationCard(
                          address: c.event!.address,
                          location: c.event!.location,
                        ),
                        const SizedBox(height: 16),
                        _AboutCard(
                          description: c.event!.description,
                          expanded: _descExpanded,
                          onToggle: () =>
                              setState(() => _descExpanded = !_descExpanded),
                        ),
                        if (_validJobs(c.event!.jobs).isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _RolesCard(jobs: _validJobs(c.event!.jobs)),
                        ],
                        if (_validPeriods(c.event!.periods).isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _PeriodsCard(
                              periods: _validPeriods(c.event!.periods)),
                        ],
                        if (_hasAttachment) ...[
                          const SizedBox(height: 16),
                          _AttachmentRow(onTap: _openAttachment),
                        ],
                        if (c.event!.appliedStatus == 'initAccept') ...[
                          const SizedBox(height: 16),
                          _DecisionRow(
                            isAccepted: _isAccepted,
                            isRejected: _isRejected,
                            onAccept: () => _handleDecision(true),
                            onReject: () => _handleDecision(false),
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                EventBottomNavigation(
                  active: EventNavTab.attendance,
                  eventId: c.event!.id?.toString(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final name = _eventController.event?.name;
    return AppBar(
      backgroundColor: WHITE_COLOR,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: AppTheme.statusBarLight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textTitle),
        onPressed: () => Get.back(),
      ),
      title: Text(
        (name != null && name.isNotEmpty) ? name : 'Event Details'.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppTheme.textTitle,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppTheme.textTitle),
          tooltip: 'Share'.tr,
          onPressed: () => HapticFeedback.lightImpact(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Safe accessors — the API contract is loose, defend against nulls/types.
  // ---------------------------------------------------------------------------

  List<JobModel> _validJobs(List<JobModel>? jobs) {
    if (jobs == null) return const [];
    return jobs.where((j) => j.name.trim().isNotEmpty).toList(growable: false);
  }

  List<String> _validPeriods(List? periods) {
    if (periods == null) return const [];
    final out = <String>[];
    for (final p in periods) {
      if (p is PeriodModel) {
        final s = p.period.trim();
        if (s.isNotEmpty) out.add(s);
      } else if (p is Map && p['period'] is String) {
        final s = (p['period'] as String).trim();
        if (s.isNotEmpty) out.add(s);
      }
    }
    return out;
  }
}

// =============================================================================
// Hero card
// =============================================================================

class _HeroCard extends StatelessWidget {
  final dynamic event;
  const _HeroCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final name = (event.name as String?) ?? 'Event Details'.tr;
    final ago = event.ago as String?;
    // The app bar already says "Event Details"; naming the organiser here is
    // information the screen didn't show anywhere.
    final eyebrow = (event.companyName as String?)?.trim();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.brand, AppTheme.brandDark],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brand.withOpacity(0.22),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.event_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  (eyebrow != null && eyebrow.isNotEmpty)
                      ? eyebrow
                      : 'Event Details'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (event.appliedStatus != null)
                _InvertedPill(status: event.appliedStatus as String?),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          if (ago != null && ago.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule_rounded,
                    size: 13, color: Colors.white.withOpacity(0.8)),
                const SizedBox(width: 4),
                Text(
                  ago,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Status pill rendered on the teal hero. Reuses [EventStatusPill] but on a
/// translucent white chip so it stays legible on a saturated background.
class _InvertedPill extends StatelessWidget {
  final String? status;
  const _InvertedPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = eventStatusStyle(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 13, color: s.color),
          const SizedBox(width: 5),
          Text(
            s.label,
            style: TextStyle(
              color: s.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Countdown card
// =============================================================================

class _CountdownCard extends StatelessWidget {
  final StartDateTimeModel? start;
  const _CountdownCard({required this.start});

  @override
  Widget build(BuildContext context) {
    final s = start;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.timer_outlined,
            title: 'Event starts in'.tr,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _CountUnit(value: s?.days ?? 0, label: 'days'.tr)),
              const SizedBox(width: 8),
              Expanded(child: _CountUnit(value: s?.hours ?? 0, label: 'hours'.tr)),
              const SizedBox(width: 8),
              Expanded(
                  child: _CountUnit(value: s?.minutes ?? 0, label: 'minutes'.tr)),
              const SizedBox(width: 8),
              Expanded(
                  child: _CountUnit(value: s?.seconds ?? 0, label: 'seconds'.tr)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountUnit extends StatelessWidget {
  final int value;
  final String label;
  const _CountUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textTitle,
              fontFeatures: _tabular,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Quick stats row
// =============================================================================

class _QuickStatsRow extends StatelessWidget {
  final String? date;
  final String? time;
  final int rolesCount;
  final int shiftsCount;

  const _QuickStatsRow({
    required this.date,
    required this.time,
    required this.rolesCount,
    required this.shiftsCount,
  });

  /// The API sends dd/MM/yyyy, which DateTime.tryParse rejects — the raw
  /// slashes were being rendered instead of a localised date.
  String _fmtDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw) ?? _parseSlashDate(raw);
    if (dt == null) return raw;
    try {
      return DateFormat('d MMM', Get.locale?.languageCode).format(dt);
    } catch (_) {
      return DateFormat('d MMM').format(dt);
    }
  }

  static DateTime? _parseSlashDate(String raw) {
    final m = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(raw.trim());
    if (m == null) return null;
    return DateTime(
      int.parse(m.group(3)!),
      int.parse(m.group(2)!),
      int.parse(m.group(1)!),
    );
  }

  /// "00:00:00 AM" doesn't fit a quarter-width tile and was ellipsised to
  /// "00:00:00 ...". Seconds carry no meaning for a start time.
  String _fmtTime(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final m = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*([AaPp][Mm])?')
        .firstMatch(raw.trim());
    if (m == null) return raw;
    final hhmm = '${m.group(1)}:${m.group(2)}';
    final suffix = m.group(3);
    return suffix == null ? hhmm : '$hhmm ${suffix.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.calendar_today_rounded,
            label: 'Date'.tr,
            value: _fmtDate(date),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.access_time_rounded,
            label: 'Time'.tr,
            value: _fmtTime(time),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.work_outline_rounded,
            label: 'Roles'.tr,
            value: rolesCount.toString(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.event_note_rounded,
            label: 'Shifts'.tr,
            value: shiftsCount.toString(),
          ),
        ),
      ],
    );
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppTheme.brand),
          const SizedBox(height: 6),
          // "00:00 AM" and slash dates are LTR strings; the RTL layout was
          // rendering them as "AM 00:00".
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textTitle,
                fontFeatures: _tabular,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Location card
// =============================================================================

class _LocationCard extends StatelessWidget {
  final String? address;
  final String? location;
  const _LocationCard({required this.address, required this.location});

  bool get _hasMapUrl => location != null && location!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.location_on_outlined,
            title: 'Event Location'.tr,
          ),
          const SizedBox(height: 10),
          Text(
            (address != null && address!.isNotEmpty) ? address! : '—',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textBody,
              height: 1.4,
            ),
          ),
          if (_hasMapUrl) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => MapsUtils.openMap(location ?? ''),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: Text('Open in Maps'.tr),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// About card
// =============================================================================

class _AboutCard extends StatelessWidget {
  final String? description;
  final bool expanded;
  final VoidCallback onToggle;

  const _AboutCard({
    required this.description,
    required this.expanded,
    required this.onToggle,
  });

  static const int _collapsedMax = 4;
  static const int _longThreshold = 180;

  /// The backend stores descriptions as HTML, so the raw value leaked markup
  /// and entities into the UI ("... hkjh&nbsp;"). Strip tags and decode the
  /// entities that actually show up rather than rendering a whole HTML tree
  /// for what is a paragraph of text.
  static String _plainText(String html) {
    var out = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '');
    const entities = {
      '&nbsp;': ' ',
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'",
      '&apos;': "'",
    };
    entities.forEach((k, v) => out = out.replaceAll(k, v));
    // Collapse the whitespace the stripped markup leaves behind.
    return out.replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final text = _plainText((description ?? '').trim());
    final isLong = text.length > _longThreshold;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.description_outlined,
            title: 'About'.tr,
          ),
          const SizedBox(height: 10),
          Text(
            text.isEmpty ? '—' : text,
            maxLines: (isLong && !expanded) ? _collapsedMax : null,
            overflow: (isLong && !expanded) ? TextOverflow.ellipsis : null,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textBody,
              height: 1.5,
            ),
          ),
          if (isLong) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  expanded ? 'Show less'.tr : 'Show more'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.brand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Roles card
// =============================================================================

class _RolesCard extends StatelessWidget {
  final List<JobModel> jobs;
  const _RolesCard({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.work_outline_rounded,
            title: 'Roles'.tr,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: jobs.map((j) {
              final qty = (j.quantity ?? 0) > 1 ? '  ×${j.quantity}' : '';
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppTheme.brand.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.brand.withOpacity(0.18),
                  ),
                ),
                child: Text(
                  '${j.name}$qty',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandDark,
                    fontFeatures: _tabular,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Periods card
// =============================================================================

class _PeriodsCard extends StatelessWidget {
  final List<String> periods;
  const _PeriodsCard({required this.periods});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.event_note_rounded,
            title: 'Shifts'.tr,
          ),
          const SizedBox(height: 8),
          ...List.generate(periods.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.field,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                        fontFeatures: _tabular,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      periods[i],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textBody,
                        fontFeatures: _tabular,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// =============================================================================
// Attachment row
// =============================================================================

class _AttachmentRow extends StatelessWidget {
  final VoidCallback onTap;
  const _AttachmentRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.line),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(Icons.picture_as_pdf_outlined,
                    color: AppTheme.brand, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachment'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'View attachment'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Decision row (initAccept only)
// =============================================================================

class _DecisionRow extends StatelessWidget {
  final bool isAccepted;
  final bool isRejected;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _DecisionRow({
    required this.isAccepted,
    required this.isRejected,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DecisionButton(
            color: AppTheme.success,
            label: isAccepted ? 'accepted'.tr : 'Accept'.tr,
            icon: Icons.check_rounded,
            filled: isAccepted,
            onTap: onAccept,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DecisionButton(
            color: AppTheme.danger,
            label: isRejected ? 'rejected'.tr : 'Reject'.tr,
            icon: Icons.close_rounded,
            filled: isRejected,
            onTap: onReject,
          ),
        ),
      ],
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _DecisionButton({
    required this.color,
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? color : AppTheme.surface;
    final fg = filled ? Colors.white : color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(color: color, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Shared section primitives
// =============================================================================

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.line),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppTheme.brand.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppTheme.brand),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTitle,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
