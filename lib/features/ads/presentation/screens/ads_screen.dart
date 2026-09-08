import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import '../controllers/ads_controller.dart';
import '../widgets/ad_card.dart';

/// Advertisements feed.
///
/// Rebuilt on [AppTheme] and wired to the pagination the controller already
/// exposed but the screen never used: it was a bare `ListView` with no
/// pull-to-refresh, no load-more, and no error state, so a failed first page
/// showed the same "no ads" copy as an genuinely empty feed.
class AdScreen extends StatelessWidget {
  const AdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        backgroundColor: AppTheme.scaffold,
        appBar: AppBar(
          title: Text('Advertisements'.tr),
          scrolledUnderElevation: 0,
        ),
        body: GetBuilder<AdsController>(
          builder: (controller) {
            if (controller.isLoading && controller.ads.isEmpty) {
              return const _AdsSkeleton();
            }
            if (controller.ads.isEmpty) {
              return _EmptyOrError(controller: controller);
            }
            return SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: controller.hasMore,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              header: const ClassicHeader(
                idleIcon: Icon(Icons.arrow_downward_rounded,
                    color: AppTheme.textMuted, size: 18),
                idleText: '',
                releaseText: '',
                refreshingText: '',
                completeText: '',
                failedText: '',
                refreshingIcon: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              footer: const ClassicFooter(
                idleText: '',
                loadingText: '',
                canLoadingText: '',
                noDataText: '',
                failedText: '',
                loadingIcon: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                itemCount: controller.ads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final ad = controller.ads[index];
                  return AdCard(
                    ad: ad,
                    onTap: () => Get.toNamed(
                      '/product_detail_screen',
                      arguments: ad.id,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Cards-shaped placeholders, so the first paint matches the list that follows
/// instead of the generic row skeleton.
class _AdsSkeleton extends StatelessWidget {
  const _AdsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) => AppShimmer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AspectRatio(
                aspectRatio: 16 / 9,
                child: Bone(width: double.infinity, height: double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Bone(width: 180, height: 13),
                    SizedBox(height: 8),
                    Bone(width: double.infinity, height: 10),
                    SizedBox(height: 6),
                    Bone(width: 220, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One surface for "nothing here" and "we couldn't load it" — they differ only
/// by copy and whether a retry is offered.
class _EmptyOrError extends StatelessWidget {
  const _EmptyOrError({required this.controller});

  final AdsController controller;

  @override
  Widget build(BuildContext context) {
    final error = controller.loadError;
    final failed = error != null;

    // Kept scrollable so the state still feels like the list it replaces.
    // (Material's RefreshIndicator clashes by name with pull_to_refresh's, and
    // the retry button below already covers the action.)
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: (failed ? AppTheme.danger : AppTheme.brand)
                        .withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    failed ? Icons.wifi_off_rounded : Icons.campaign_outlined,
                    size: 34,
                    color: failed ? AppTheme.danger : AppTheme.brand,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  failed
                      ? 'Could not load advertisements'.tr
                      : 'No ads found'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  failed ? error.tr : 'New advertisements will appear here'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: controller.retry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text('Retry'.tr),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
