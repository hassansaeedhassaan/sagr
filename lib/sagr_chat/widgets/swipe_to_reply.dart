import 'package:flutter/material.dart';
import '../theme/chat_theme.dart';

/// Wraps a message bubble and fires [onReply] when the user swipes it
/// horizontally past a threshold, WhatsApp-style. Direction-aware (LTR/RTL):
/// the swipe always reads as "drag toward the start side".
class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;
  final double threshold;

  const SwipeToReply({
    Key? key,
    required this.child,
    required this.onReply,
    this.threshold = 64,
  }) : super(key: key);

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  double _drag = 0; // always >= 0, magnitude toward the start side
  bool _fired = false;

  static const double _maxDrag = 90;

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    // Visual offset follows reading direction.
    final dx = isRtl ? _drag : -_drag;
    final progress = (_drag / widget.threshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        // Dragging toward the start side increases _drag.
        final delta = isRtl ? d.delta.dx : -d.delta.dx;
        setState(() => _drag = (_drag + delta).clamp(0.0, _maxDrag));
        if (!_fired && _drag >= widget.threshold) {
          _fired = true;
          widget.onReply();
        }
      },
      onHorizontalDragEnd: (_) => setState(() {
        _drag = 0;
        _fired = false;
      }),
      onHorizontalDragCancel: () => setState(() {
        _drag = 0;
        _fired = false;
      }),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 8,
            child: Opacity(
              opacity: progress,
              child: Transform.scale(
                scale: 0.6 + 0.4 * progress,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: palette.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.reply, size: 18, color: palette.primary),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(dx, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
