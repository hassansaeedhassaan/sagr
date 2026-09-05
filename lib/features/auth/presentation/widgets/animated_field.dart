import 'package:flutter/material.dart';

/// Wraps [child] in a one-shot slide-up + fade-in entrance animation.
/// [delay] staggers the animation (in arbitrary units) for sequential fields.
class AnimatedField extends StatelessWidget {
  final Widget child;
  final int delay;

  const AnimatedField({super.key, required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (delay * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
