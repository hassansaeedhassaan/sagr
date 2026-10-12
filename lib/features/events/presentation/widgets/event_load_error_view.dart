import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/theme/app_theme.dart';

/// Shown when the event behind a screen could not be loaded.
class EventLoadErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const EventLoadErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppTheme.textHint),
            const SizedBox(height: 14),
            Text(
              'Could not load this event. Please try again.'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('Retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
