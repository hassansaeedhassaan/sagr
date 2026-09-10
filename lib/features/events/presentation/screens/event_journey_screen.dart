import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:sagr/helper/base_url.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../../data/models/application_info.dart';
import '../../data/models/event_model.dart';
import '../../data/models/start_date_time_model.dart';
import '../controllers/event_controller.dart';
import '../widgets/event_status_pill.dart';

const _tabular = [FontFeature.tabularFigures()];

/// One place to follow an application from submission to event day.
///
/// Every application status opens this screen. It shows where the application
/// is (a stage tracker with the time each stage was reached, from the
/// server's status history), the one thing the user can do next (apply,
/// answer the contract, re-apply, check in) in a fixed bottom bar, their zone
/// and role once assigned, and every status change with its time.
class EventJourneyScreen extends StatefulWidget {
  const EventJourneyScreen({super.key});

  @override
  State<EventJourneyScreen> createState() => _EventJourneyScreenState();
}

enum _StepState { done, current, failed, upcoming }

class _JourneyStep {
  final String title;
  final _StepState state;
  final String? subtitle;
  final DateTime? at;

  const _JourneyStep(this.title, this.state, {this.subtitle, this.at});
}

class _StateCopy {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StateCopy(this.title, this.subtitle, this.icon, this.color);
}

class _EventJourneyScreenState extends State<EventJourneyScreen> {
  final EventController _controller = Get.put(EventController(Get.find()));

  bool _loadedOnce = false;
  bool _deciding = false;

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    // The controller is shared across event screens and may hold another
    // event, or this one with a stale status; always load it fresh.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEventInfo().whenComplete(() {
        if (mounted) setState(() => _loadedOnce = true);
      });
    });
  }

  Future<void> _refresh() => _controller.getEventInfo();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      init: _controller,
      builder: (c) {
        final event = c.event;
        final wanted = eventIdFromArguments(Get.arguments);

        if (event == null || (wanted != null && event.id != wanted)) {
          return Scaffold(
            backgroundColor: AppTheme.scaffold,
            appBar: AppBar(
              backgroundColor: AppTheme.scaffold,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            body: _loadedOnce && !c.isLoading ? _error() : _loading(),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.scaffold,
          body: _content(event),
          bottomNavigationBar: _actionBar(event),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  String _statusOf(EventModel event) =>
      event.application?.status ?? event.appliedStatus ?? 'undefined';

  bool _isAssigned(EventModel event) =>
      event.application?.assignment != null || event.assigned == true;

  bool _isLive(StartDateTimeModel? sdt) =>
      sdt != null && (sdt.isActive || sdt.isWorkingNow);

  /// The contract was sent before the rejection, so the applicant declined it.
  bool _declinedContract(ApplicationInfo? app) =>
      app != null && app.reached('initAccept');

  String _assignmentLine(AssignmentInfo? a) {
    if (a == null) return '';
    final role = (a.isSupervisor ? 'Supervisor' : 'Employee').tr;
    return '${'Your zone'.tr}: ${a.zoneName ?? '—'} · ${'Your role'.tr}: $role';
  }

  String? _contractUrl(EventModel event) {
    final fromServer = event.application?.contractUrl;
    if (fromServer != null && fromServer.isNotEmpty) return fromServer;

    // Older servers only send the stored path.
    final path = event.attachment;
    if (path == null || path.isEmpty || path == 'undefined') return null;
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path.substring(1) : path;
    return p.startsWith('uploads/') || p.startsWith('storage/')
        ? '$HOSTURL$p'
        : '${HOSTURL}storage/$p';
  }

  _StateCopy _stateCopy(EventModel event) {
    final app = event.application;
    final status = _statusOf(event);
    final sdt = event.startDateTime;

    switch (status) {
      case 'pending':
        return _StateCopy(
          'Your application is under review'.tr,
          "We'll notify you as soon as there's a decision.".tr,
          Icons.hourglass_top_rounded,
          AppTheme.warning,
        );
      case 'initAccept':
        return _StateCopy(
          "You've been preliminarily accepted".tr,
          'Read the contract, then accept or decline it.'.tr,
          Icons.description_outlined,
          AppTheme.sky,
        );
      case 'accepted':
        if (!_isAssigned(event)) {
          return _StateCopy(
            'Contract accepted'.tr,
            'The organizer will assign your zone and role soon.'.tr,
            Icons.verified_rounded,
            AppTheme.success,
          );
        }
        if (sdt?.isFinished == true) {
          return _StateCopy(
            'This event has ended'.tr,
            _assignmentLine(app?.assignment),
            Icons.flag_rounded,
            AppTheme.textMuted,
          );
        }
        if (_isLive(sdt)) {
          return _StateCopy(
            'The event has started'.tr,
            'Check in from inside your zone to start.'.tr,
            Icons.play_circle_fill_rounded,
            AppTheme.brand,
          );
        }
        return _StateCopy(
          "You're all set".tr,
          _assignmentLine(app?.assignment),
          Icons.event_available_rounded,
          AppTheme.success,
        );
      case 'rejected':
        return _StateCopy(
          _declinedContract(app)
              ? 'You declined the contract'.tr
              : "Your application wasn't accepted".tr,
          (app?.canApply ?? false)
              ? 'You can apply to this event again once.'.tr
              : "You can't apply to this event again.".tr,
          Icons.cancel_rounded,
          AppTheme.danger,
        );
      default:
        final canApply = app?.canApply ?? true;
        return _StateCopy(
          canApply
              ? 'Apply for this event'.tr
              : 'Applications are closed for you on this event.'.tr,
          'Pick a role and shift, then send your application.'.tr,
          Icons.edit_note_rounded,
          AppTheme.brand,
        );
    }
  }

  List<_JourneyStep> _steps(EventModel event) {
    final app = event.application;
    final status = _statusOf(event);
    final applied = status != 'undefined';
    final sentContract = status == 'initAccept' ||
        status == 'accepted' ||
        (app?.reached('initAccept') ?? false);
    final rejected = status == 'rejected';
    final rejectedAtReview = rejected && !sentContract;
    final declined = rejected && sentContract;
    final assigned = _isAssigned(event);
    final sdt = event.startDateTime;

    return [
      _JourneyStep(
        'Submitted'.tr,
        applied ? _StepState.done : _StepState.upcoming,
        at: app?.submittedAt ?? app?.firstAt('pending'),
      ),
      _JourneyStep(
        'Under Review'.tr,
        status == 'pending'
            ? _StepState.current
            : rejectedAtReview
                ? _StepState.failed
                : sentContract
                    ? _StepState.done
                    : _StepState.upcoming,
        subtitle: status == 'pending'
            ? 'Waiting for the organizer'.tr
            : rejectedAtReview
                ? 'Not accepted'.tr
                : null,
        at: rejectedAtReview ? app?.lastAt('rejected') : app?.firstAt('initAccept'),
      ),
      _JourneyStep(
        'Preliminary acceptance'.tr,
        status == 'initAccept'
            ? _StepState.current
            : sentContract
                ? _StepState.done
                : _StepState.upcoming,
        subtitle: status == 'initAccept'
            ? 'Read the contract, then accept or decline it.'.tr
            : null,
        at: app?.firstAt('initAccept'),
      ),
      _JourneyStep(
        'Contract decision'.tr,
        status == 'accepted'
            ? _StepState.done
            : declined
                ? _StepState.failed
                : _StepState.upcoming,
        subtitle: declined ? 'Declined'.tr : null,
        at: status == 'accepted'
            ? app?.firstAt('accepted')
            : declined
                ? app?.lastAt('rejected')
                : null,
      ),
      _JourneyStep(
        'Zone assignment'.tr,
        assigned
            ? _StepState.done
            : status == 'accepted'
                ? _StepState.current
                : _StepState.upcoming,
        subtitle: assigned
            ? _assignmentLine(app?.assignment)
            : status == 'accepted'
                ? 'Waiting for the organizer'.tr
                : null,
        at: app?.assignment?.assignedAt,
      ),
      _JourneyStep(
        'Event day'.tr,
        !assigned
            ? _StepState.upcoming
            : sdt?.isFinished == true
                ? _StepState.done
                : _isLive(sdt)
                    ? _StepState.current
                    : _StepState.upcoming,
        subtitle: !assigned
            ? null
            : sdt?.isFinished == true
                ? 'Event ended'.tr
                : _isLive(sdt)
                    ? 'Event in progress'.tr
                    : null,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _decide(bool accept) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            accept ? 'Accept the contract?'.tr : 'Decline the contract?'.tr),
        content: Text(
            "Make sure you have read the contract. This decision can't be undone."
                .tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: accept ? AppTheme.brand : AppTheme.danger,
            ),
            child: Text(accept ? 'Accept contract'.tr : 'Decline'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.lightImpact();
    setState(() => _deciding = true);
    final saved =
        await _controller.contractDecisions(accept ? 'accepted' : 'rejected');
    if (!mounted) return;
    setState(() => _deciding = false);

    // Reload so the tracker shows the new stage with its time.
    if (saved) await _controller.getEventInfo();
  }

  void _openContract(String url) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Contract'.tr)),
          body: SfPdfViewer.network(url),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  Widget _content(EventModel event) {
    final app = event.application;
    final status = _statusOf(event);
    final contractUrl = _contractUrl(event);
    final sdt = event.startDateTime;
    final showCountdown = status == 'accepted' && sdt != null && sdt.isUpcoming;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppTheme.brand,
      edgeOffset: 110,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          _header(event, status),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _stateCard(event),
                if (app?.assignment != null) ...[
                  const SizedBox(height: 12),
                  _assignmentCard(app!.assignment!),
                ],
                if (showCountdown) ...[
                  const SizedBox(height: 12),
                  _CountdownCard(start: sdt!),
                ],
                if (status == 'initAccept' && contractUrl != null) ...[
                  const SizedBox(height: 12),
                  _contractCard(contractUrl),
                ],
                const SizedBox(height: 12),
                _section('Application journey'.tr, _tracker(_steps(event))),
                const SizedBox(height: 12),
                _section('Event details'.tr, _details(event)),
                if ((app?.timeline ?? const <ApplicationStage>[]).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _section('Status history'.tr, _history(app!)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(EventModel event, String status) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 168,
      backgroundColor: AppTheme.navy,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: EventStatusPill(status: status, compact: true),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            const EdgeInsetsDirectional.only(start: 56, end: 16, bottom: 14),
        title: Text(
          event.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        background: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [AppTheme.navy, AppTheme.brandDark],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 56, 20, 50),
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Text(
                  event.companyName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(Widget child) {
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

  Widget _section(String title, Widget child) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textTitle,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _stateCard(EventModel event) {
    final s = _stateCopy(event);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: s.color.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: s.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(s.icon, color: s.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                  ),
                ),
                if (s.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    s.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assignmentCard(AssignmentInfo a) {
    return _card(
      Row(
        children: [
          _infoTile(Icons.place_rounded, 'Your zone'.tr, a.zoneName ?? '—'),
          const SizedBox(width: 12),
          _infoTile(
            a.isSupervisor ? Icons.shield_rounded : Icons.badge_rounded,
            'Your role'.tr,
            (a.isSupervisor ? 'Supervisor' : 'Employee').tr,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.brand.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.brand, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textTitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contractCard(String url) {
    return _card(
      Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded,
              color: AppTheme.danger, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Contract'.tr,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textTitle,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => _openContract(url),
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: Text('View contract'.tr),
            style: TextButton.styleFrom(foregroundColor: AppTheme.brand),
          ),
        ],
      ),
    );
  }

  Widget _tracker(List<_JourneyStep> steps) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _stepRow(steps[i], isLast: i == steps.length - 1),
      ],
    );
  }

  Widget _stepRow(_JourneyStep step, {required bool isLast}) {
    final color = switch (step.state) {
      _StepState.done => AppTheme.success,
      _StepState.current => AppTheme.brand,
      _StepState.failed => AppTheme.danger,
      _StepState.upcoming => AppTheme.textHint,
    };
    final icon = switch (step.state) {
      _StepState.done => Icons.check_rounded,
      _StepState.current => Icons.more_horiz_rounded,
      _StepState.failed => Icons.close_rounded,
      _StepState.upcoming => Icons.circle,
    };
    final upcoming = step.state == _StepState.upcoming;
    final subtitle = step.subtitle ?? '';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: upcoming ? AppTheme.surface : color,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    icon,
                    size: upcoming ? 8 : 15,
                    color: upcoming ? color : Colors.white,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: step.state == _StepState.done
                          ? AppTheme.success.withOpacity(0.5)
                          : AppTheme.line,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: step.state == _StepState.current
                                ? FontWeight.w800
                                : FontWeight.w700,
                            color: upcoming
                                ? AppTheme.textHint
                                : AppTheme.textTitle,
                          ),
                        ),
                      ),
                      if (step.at != null)
                        Text(
                          _shortDate(step.at!),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                            fontFeatures: _tabular,
                          ),
                        ),
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: step.state == _StepState.failed
                            ? AppTheme.danger
                            : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _details(EventModel event) {
    final about = (event.description ?? '').trim();
    final location = (event.location ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailRow(Icons.calendar_today_rounded, 'Date'.tr, event.date),
        _detailRow(Icons.access_time_rounded, 'Time'.tr, event.time),
        _detailRow(
          Icons.place_outlined,
          'Event Location'.tr,
          event.address,
          onTap: location.isEmpty ? null : () => MapsUtils.openMap(location),
        ),
        if (about.isNotEmpty) ...[
          const Divider(height: 24, color: AppTheme.line),
          Text(
            'About'.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            about,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.6,
              color: AppTheme.textBody,
            ),
          ),
        ],
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String? value,
      {VoidCallback? onTap}) {
    final v = (value ?? '').trim();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.textMuted),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                v.isEmpty ? '—' : v,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textTitle,
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(Icons.open_in_new_rounded,
                  size: 16, color: AppTheme.brand),
            ],
          ],
        ),
      ),
    );
  }

  Widget _history(ApplicationInfo app) {
    final entries = app.timeline.reversed.toList();
    return Column(
      children: [
        for (final s in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  eventStatusStyle(s.status).icon,
                  size: 18,
                  color: eventStatusStyle(s.status).color,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.status == 'pending'
                        ? 'Submitted'.tr
                        : eventStatusStyle(s.status).label,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textTitle,
                    ),
                  ),
                ),
                Text(
                  s.at == null ? '—' : _longDate(s.at!),
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
    );
  }

  Widget? _actionBar(EventModel event) {
    final app = event.application;
    final status = _statusOf(event);
    final canApply = app?.canApply ?? status == 'undefined';

    Widget? content;
    if (status == 'initAccept') {
      content = Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _deciding ? null : () => _decide(false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.danger,
                side: const BorderSide(color: AppTheme.danger),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
              ),
              child: Text('Decline'.tr),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _deciding ? null : () => _decide(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.brand,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
              ),
              child: _deciding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Accept contract'.tr),
            ),
          ),
        ],
      );
    } else if ((status == 'undefined' || status == 'rejected') && canApply) {
      content = _primaryButton(
        status == 'rejected' ? 'Apply again'.tr : 'Apply now'.tr,
        Icons.send_rounded,
        () => Get.toNamed('/event_apply_screen', arguments: event.id),
      );
    } else if (status == 'accepted' &&
        _isAssigned(event) &&
        _isLive(event.startDateTime)) {
      content = _primaryButton(
        'Go to check-in'.tr,
        Icons.how_to_reg_rounded,
        () => Get.toNamed('/attendance_screen', arguments: event.id),
      );
    }

    if (content == null) return null;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: content,
        ),
      ),
    );
  }

  Widget _primaryButton(String label, IconData icon, VoidCallback onTap) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppTheme.brand,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _loading() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppLoader.box(height: 160),
          const SizedBox(height: 16),
          AppLoader.box(height: 110),
          const SizedBox(height: 16),
          Expanded(child: AppLoader.list(items: 4, showTrailing: false)),
        ],
      ),
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 40, color: AppTheme.textHint),
          const SizedBox(height: 12),
          Text(
            'Could not load the event.'.tr,
            style: const TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _controller.getEventInfo,
            child: Text('Retry'.tr),
          ),
        ],
      ),
    );
  }

  String _shortDate(DateTime d) => DateFormat('d MMM', _locale).format(d);

  String _longDate(DateTime d) =>
      DateFormat('d MMM y · h:mm a', _locale).format(d);
}

/// Live countdown to the event's start. When it reaches zero it reloads the
/// event, so the screen switches to the check-in action on its own.
class _CountdownCard extends StatefulWidget {
  final StartDateTimeModel start;

  const _CountdownCard({required this.start});

  @override
  State<_CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<_CountdownCard> {
  late StartDateTimeModel _value = widget.start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _value = _value.copyWithDecrementedSecond());
      if (_value.isActive) {
        _timer?.cancel();
        Get.find<EventController>().getEventInfo();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _CountdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.start, widget.start)) _value = widget.start;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppTheme.navy, AppTheme.brandDark],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event starts in'.tr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _box('${_value.days}', 'days'.tr),
              const SizedBox(width: 8),
              _box(_two(_value.hours), 'hours'.tr),
              const SizedBox(width: 8),
              _box(_two(_value.minutes), 'minutes'.tr),
              const SizedBox(width: 8),
              _box(_two(_value.seconds), 'seconds'.tr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _box(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFeatures: _tabular,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
