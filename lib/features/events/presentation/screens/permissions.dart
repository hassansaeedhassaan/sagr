import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:sagr/features/evocations/data/models/evocation_model.dart';
import 'package:sagr/features/evocations/presentation/controllers/evocations_controller.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/Common/no_results.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final EvocationsController evoController =
      Get.put(EvocationsController(Get.find()));

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat.yMMMMd(Get.locale?.toString() ?? 'ar').format(dt);
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '$m ${"minutes".tr}';
  }

  ({IconData icon, String label, Color color}) _typeMeta(EvocationType type) {
    switch (type) {
      case EvocationType.prayer:
        return (
          icon: Icons.self_improvement_rounded,
          label: 'Prayer'.tr,
          color: AppTheme.brand,
        );
      case EvocationType.food:
        return (
          icon: Icons.restaurant_rounded,
          label: 'Food'.tr,
          color: AppTheme.warning,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Permissions'.tr,
          style: const TextStyle(
            color: AppTheme.navy,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (evoController.isLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AppLoader.list(items: 6),
            );
          }

          final items = evoController.events;

          if (items.isEmpty) {
            return NoResults(
              title: 'No permissions yet'.tr,
              message: 'Submit your first permission request'.tr,
            );
          }

          return Column(
            children: [
              _SummaryHeader(items: items),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final evocation = items.elementAt(index);
                    return _PermissionCard(
                      evocation: evocation,
                      meta: _typeMeta(evocation.type),
                      formattedDate: _formatDate(evocation.createdAt),
                      formattedDuration: _formatDuration(evocation.duration),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar:
          const EventBottomNavigation(active: EventNavTab.attendance),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final List<EvocationModel> items;
  const _SummaryHeader({required this.items});

  @override
  Widget build(BuildContext context) {
    final total = items.length;
    final totalMinutes =
        items.fold<int>(0, (sum, e) => sum + e.duration);
    final prayers =
        items.where((e) => e.type == EvocationType.prayer).length;
    final foods = items.where((e) => e.type == EvocationType.food).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
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
      child: Row(
        children: [
          _stat(
            icon: Icons.fact_check_outlined,
            label: 'Permissions'.tr,
            value: '$total',
            color: AppTheme.brand,
          ),
          _divider(),
          _stat(
            icon: Icons.timer_outlined,
            label: 'Duration'.tr,
            value: _shortDuration(totalMinutes),
            color: AppTheme.navy,
          ),
          _divider(),
          _stat(
            icon: Icons.self_improvement_rounded,
            label: 'Prayer'.tr,
            value: '$prayers',
            color: AppTheme.brand,
          ),
          _divider(),
          _stat(
            icon: Icons.restaurant_rounded,
            label: 'Food'.tr,
            value: '$foods',
            color: AppTheme.warning,
          ),
        ],
      ),
    );
  }

  String _shortDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: AppTheme.line,
      );

  Widget _stat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppTheme.textTitle,
              fontFeatures: _tabular,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final EvocationModel evocation;
  final ({IconData icon, String label, Color color}) meta;
  final String formattedDate;
  final String formattedDuration;

  const _PermissionCard({
    required this.evocation,
    required this.meta,
    required this.formattedDate,
    required this.formattedDuration,
  });

  @override
  Widget build(BuildContext context) {
    final hasNotes = (evocation.notes ?? '').trim().isNotEmpty;
    final hasZone = (evocation.zone ?? '').trim().isNotEmpty;
    final hasEvent = (evocation.event ?? '').trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: type icon + label + date
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: meta.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(meta.icon, color: meta.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        meta.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textTitle,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (formattedDate.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                            fontFeatures: _tabular,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                _DurationPill(text: formattedDuration),
              ],
            ),

            const SizedBox(height: 12),

            // Meta chips row: zone + event
            if (hasZone || hasEvent)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (hasZone)
                    _MetaChip(
                      icon: Icons.place_outlined,
                      text: evocation.zone!,
                      color: AppTheme.sky,
                    ),
                  if (hasEvent)
                    _MetaChip(
                      icon: Icons.event_outlined,
                      text: evocation.event!,
                      color: AppTheme.brand,
                    ),
                ],
              ),

            // Notes
            if (hasNotes) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.field,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.sticky_note_2_outlined,
                          size: 14,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Note'.tr,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textMuted,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      evocation.notes!.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: AppTheme.textBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  final String text;
  const _DurationPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.navy.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded,
              size: 13, color: AppTheme.textTitle),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTitle,
              fontFeatures: _tabular,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _MetaChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
