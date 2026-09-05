import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sagr/data/colors.dart';
import 'package:sagr/theme/app_theme.dart';

import '../../../jobs/presentation/controllers/marital_status_controller.dart';
import '../../../../widgets/Common/no_results.dart';
import '../../../../widgets/skeletons/app_skeleton.dart';
import '../controllers/all_events_controller.dart';
import 'event_card.dart';

/// Shared, premium list scaffold for the All / My / Previous event screens.
/// Configured per screen via [tag] (controller instance), [title] and which
/// filters to show. Renders duration + job filters, infinite scroll and the
/// unified [EventCard].
class EventListView extends StatelessWidget {
  final String tag;
  final String title;
  final bool showDurationFilter;
  final bool showJobFilter;
  final String emptyTitle;

  const EventListView({
    super.key,
    required this.tag,
    required this.title,
    this.showDurationFilter = true,
    this.showJobFilter = true,
    this.emptyTitle = 'No events found',
  });

  AllEventsController get _c => Get.find<AllEventsController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        backgroundColor: WHITE_COLOR,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTitle,
          ),
        ),
      ),
      body: Column(
        children: [
          if (showDurationFilter) _durationFilter(),
          if (showJobFilter) _jobsFilter(),
          const SizedBox(height: 4),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  // ---- Duration filter (upcoming / finished) ----
  Widget _durationFilter() {
    return GetBuilder<AllEventsController>(
      tag: tag,
      builder: (c) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: [
            _durationChip("القادمة", ''),
            const SizedBox(width: 10),
            _durationChip("المنتهية", 'previous'),
          ],
        ),
      ),
    );
  }

  Widget _durationChip(String label, String value) {
    final selected = _c.duration == value;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _c.setDuration(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.brand : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppTheme.brand : AppTheme.line),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.textMuted,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // ---- Job filter chips (reuses JobsController) ----
  Widget _jobsFilter() {
    return SizedBox(
      height: 46,
      child: GetBuilder<JobsController>(
        init: JobsController(Get.find()),
        builder: (jobC) {
          if (jobC.isLoading) {
            return AppShimmer(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsetsDirectional.only(end: 8),
                  child: Bone(width: 72, height: 34, radius: 20),
                ),
              ),
            );
          }
          return GetBuilder<AllEventsController>(
            tag: tag,
            builder: (c) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: jobC.jobs.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) return _jobChip("الكل", null);
                final job = jobC.jobs[i - 1];
                return _jobChip(job.name ?? '', job.id);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _jobChip(String label, int? jobId) {
    final selected = _c.job == jobId;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _c.setJob(jobId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.brand.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppTheme.brand : AppTheme.line),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppTheme.brand : AppTheme.textMuted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ---- List with infinite scroll ----
  Widget _list() {
    return GetBuilder<AllEventsController>(
      tag: tag,
      builder: (c) {
        if (c.isLoading && c.events.isEmpty) {
          return AppLoader.list(items: 6);
        }
        if (c.events.isEmpty) {
          return NoResults(title: emptyTitle.tr, message: '');
        }
        return SmartRefresher(
          controller: c.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: c.onRefresh,
          onLoading: c.loadMore,
          header: const WaterDropHeader(),
          footer: CustomFooter(
            height: 55,
            builder: (ctx, mode) => _footer(mode, c),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 6, bottom: 16),
            itemCount: c.events.length,
            itemBuilder: (ctx, i) => EventCard(event: c.events[i]),
          ),
        );
      },
    );
  }

  Widget _footer(LoadStatus? mode, AllEventsController c) {
    if (mode == LoadStatus.loading) {
      return Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: AppTheme.brand,
          rightDotColor: AppTheme.sky,
          size: 34,
        ),
      );
    }
    if (mode == LoadStatus.noMore || !c.hasMore) {
      return const Center(
        child: Text(
          "لا يوجد المزيد من الفعاليات",
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
