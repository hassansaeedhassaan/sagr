import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sagr/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../widgets/notification_tile.dart';

/// Notifications inbox.
///
/// Unread items are highlighted until tapped; tapping marks one read and opens
/// its event, and "Mark all as read" clears the rest. Pull to refresh, scroll
/// to load more.
class NotificationsScreen extends StatelessWidget {
  final NotificationsController _controller;

  const NotificationsScreen(this._controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: GetBuilder<NotificationsController>(
        init: _controller,
        builder: (controller) => Scaffold(
          backgroundColor: AppTheme.scaffold,
          appBar: AppBar(
            title: Text('Notifications'.tr),
            scrolledUnderElevation: 0,
            actions: [
              if (controller.unreadCount > 0)
                TextButton(
                  onPressed: controller.markAllRead,
                  child: Text(
                    'Mark all as read'.tr,
                    style: const TextStyle(
                      color: AppTheme.brand,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(NotificationsController controller) {
    if (controller.isLoadingList && controller.notifications.isEmpty) {
      return const _NotificationsSkeleton();
    }
    if (controller.notifications.isEmpty) {
      return _EmptyOrError(controller: controller);
    }

    final items = controller.notifications;
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
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final n = items[index];
          return NotificationTile(
            notification: n,
            onTap: () => controller.open(n),
          );
        },
      ),
    );
  }
}

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => AppShimmer(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(color: AppTheme.line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              BoneCircle(size: 42),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone(width: 160, height: 12),
                    SizedBox(height: 8),
                    Bone(width: double.infinity, height: 10),
                    SizedBox(height: 6),
                    Bone(width: 90, height: 9),
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

/// One surface for "nothing here" and "we couldn't load it".
class _EmptyOrError extends StatelessWidget {
  const _EmptyOrError({required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final error = controller.loadError;
    final failed = error != null;

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
                    failed
                        ? Icons.wifi_off_rounded
                        : Icons.notifications_none_rounded,
                    size: 34,
                    color: failed ? AppTheme.danger : AppTheme.brand,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  failed
                      ? 'Could not load notifications'.tr
                      : 'No notifications found'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  failed ? error.tr : 'New notifications will appear here'.tr,
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
