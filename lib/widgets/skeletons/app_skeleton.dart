import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sagr/theme/app_theme.dart';

/// App-wide loading skeletons. Replace bare [CircularProgressIndicator] with
/// these for a premium, content-shaped loading state.
///
/// Usage:
/// ```dart
/// loading ? AppLoader.list() : MyList()
/// loading ? AppLoader.box(height: 180) : MyBanner()
/// ```
/// Build custom skeletons from [Bone] / [BoneCircle] wrapped in [AppShimmer].

/// Wraps a subtree of bones in a single, efficient shimmer sweep.
class AppShimmer extends StatelessWidget {
  final Widget child;
  const AppShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffe6eaee),
      highlightColor: const Color(0xfff5f8fa),
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}

/// A rounded rectangle placeholder. Must sit inside an [AppShimmer].
class Bone extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? margin;

  const Bone({
    Key? key,
    this.width,
    this.height = 12,
    this.radius = 8,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A circular placeholder (avatars). Must sit inside an [AppShimmer].
class BoneCircle extends StatelessWidget {
  final double size;
  const BoneCircle({Key? key, this.size = 48}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// One list row: avatar + two text lines + trailing stub.
class SkeletonTile extends StatelessWidget {
  final bool showTrailing;
  const SkeletonTile({Key? key, this.showTrailing = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const BoneCircle(size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Bone(width: 150, height: 13),
                SizedBox(height: 8),
                Bone(width: double.infinity, height: 11),
              ],
            ),
          ),
          if (showTrailing) ...const [
            SizedBox(width: 12),
            Bone(width: 34, height: 10),
          ],
        ],
      ),
    );
  }
}

/// A media/banner card skeleton: image block + title + subtitle.
class SkeletonCard extends StatelessWidget {
  final double imageHeight;
  const SkeletonCard({Key? key, this.imageHeight = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.line),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: double.infinity, height: imageHeight, radius: 14),
          const SizedBox(height: 10),
          const Bone(width: 120, height: 12),
          const SizedBox(height: 8),
          const Bone(width: 80, height: 10),
        ],
      ),
    );
  }
}

/// Drop-in skeleton loaders. Each self-wraps in [AppShimmer].
class AppLoader {
  const AppLoader._();

  /// Vertical list of row tiles (conversations, contacts, generic lists).
  static Widget list({int items = 8, bool showTrailing = true}) {
    return AppShimmer(
      child: ListView.builder(
        // These skeletons are dropped into Columns and SingleChildScrollViews
        // as often as into a full-height page. Without shrinkWrap the viewport
        // is handed unbounded height there and throws on every frame while the
        // real content loads.
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: items,
        itemBuilder: (_, __) => SkeletonTile(showTrailing: showTrailing),
      ),
    );
  }

  /// Grid of cards (products, ads, events).
  static Widget grid({
    int items = 6,
    int crossAxisCount = 2,
    double imageHeight = 120,
    double childAspectRatio = 0.72,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
  }) {
    return AppShimmer(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: items,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (_, __) => SkeletonCard(imageHeight: imageHeight),
      ),
    );
  }

  /// A single block placeholder (banners, headers, avatars).
  static Widget box({
    double? width,
    double height = 120,
    double radius = 14,
  }) {
    return AppShimmer(
      child: Bone(width: width, height: height, radius: radius),
    );
  }

  /// Centered compact loader for tight spaces (buttons, inline actions).
  /// Falls back to a small branded spinner where a skeleton makes no sense.
  static Widget inline({double size = 20, Color? color}) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppTheme.brand),
        ),
      ),
    );
  }
}
