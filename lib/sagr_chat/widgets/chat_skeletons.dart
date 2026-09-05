import 'package:flutter/material.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// Chat message thread skeleton — alternating incoming/outgoing bubble stubs.
class ChatMessagesSkeleton extends StatelessWidget {
  const ChatMessagesSkeleton({Key? key}) : super(key: key);

  static const _widths = [0.55, 0.35, 0.7, 0.45, 0.6, 0.3, 0.5];

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: List.generate(_widths.length, (i) {
            final isMe = i.isOdd;
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Bone(
                  width: maxW * _widths[i],
                  height: 38,
                  radius: 16,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
