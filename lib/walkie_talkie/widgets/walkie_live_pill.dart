import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/walkie_talkie/services/walkie_manager.dart';

/// A small "walkie on" pill over the app while a walkie-talkie channel is
/// live in the background: the user always knows the team can be heard, and
/// one tap goes back to the walkie screen. Hidden on the walkie screens and
/// while the channel is paused for a chat conversation.
class WalkieLivePill extends StatelessWidget {
  const WalkieLivePill({super.key});

  /// Wraps the app's navigator (GetMaterialApp.builder).
  static Widget overlay(BuildContext context, Widget? child) => Stack(
        children: [
          if (child != null) child,
          PositionedDirectional(
            start: 12,
            bottom: MediaQuery.of(context).padding.bottom + 84,
            child: const WalkieLivePill(),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final manager = WalkieManager.to;

    return Obx(() {
      final show = manager.live.value &&
          !manager.pausedForChat.value &&
          !WalkieManager.walkieRoutes.contains(manager.currentRoute.value);
      if (!show) return const SizedBox.shrink();

      final color =
          manager.reconnecting.value ? AppTheme.warning : AppTheme.success;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: manager.openWalkie,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.navy.withOpacity(0.92),
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.settings_voice_rounded,
                    color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    manager.channelLabel.value.isEmpty
                        ? 'Walkie-talkie is on'.tr
                        : manager.channelLabel.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
