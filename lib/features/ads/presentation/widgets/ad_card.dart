import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/features/ads/data/models/ad_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/theme/app_theme.dart';

/// Advertisement card for the ads feed.
///
/// Built on [AppTheme] rather than the private palette the old
/// `PremiumAdCard` carried — that widget shipped its own near-black accent and
/// warm greys, so the ads list looked like a different app from every other
/// screen.
///
/// The whole card is one tap target (the previous design hid the action behind
/// a small "Read More" pill), and the cover image degrades to a branded
/// placeholder instead of a broken-image box.
class AdCard extends StatelessWidget {
  const AdCard({super.key, required this.ad, this.onTap});

  final AdModel ad;
  final VoidCallback? onTap;

  /// The API returns `datetime` as pre-formatted Arabic prose
  /// ("الثلاثاء 08 سبتمبر 2026"), which no date parser accepts. The old card
  /// ran it through `DateTime.tryParse(...) ?? DateTime.now()` and so stamped
  /// every ad with the current time. Prefer the server's own strings.
  String get _meta {
    final parts = <String>[
      if (ad.date?.isNotEmpty == true) ad.date!,
      if (ad.time?.isNotEmpty == true) shortTime(ad.time!),
    ];
    if (parts.isNotEmpty) return parts.join('  ·  ');
    return ad.datetime ?? '';
  }

  /// "07:20:00 AM" -> "07:20 AM". Seconds are noise on an ad.
  static String shortTime(String time) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*([AaPp][Mm])?')
        .firstMatch(time.trim());
    if (match == null) return time;
    final suffix = match.group(3);
    final hhmm = '${match.group(1)}:${match.group(2)}';
    return suffix == null ? hhmm : '$hhmm ${suffix.toUpperCase()}';
  }

  String? get _imageUrl {
    final logo = ad.logo;
    if (logo == null || logo.isEmpty) return null;
    return '$HOSTURL$logo';
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.radiusLg);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: radius,
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cover(url: _imageUrl, meta: _meta),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textTitle,
                        height: 1.3,
                      ),
                    ),
                    if (ad.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      Text(
                        ad.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Read more'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.brand,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                          color: AppTheme.brand,
                        ),
                      ],
                    ),
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

/// 16:9 cover with the date stamped over a scrim, so the meta line never
/// competes with the title for space in the body.
class _Cover extends StatelessWidget {
  const _Cover({required this.url, required this.meta});

  final String? url;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppTheme.radiusLg),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url == null)
              const _CoverFallback()
            else
              CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(color: AppTheme.field),
                errorWidget: (_, __, ___) => const _CoverFallback(),
              ),
            if (meta.isNotEmpty)
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _MetaChip(text: meta),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shown when an ad has no logo, or the server can't serve it. Reads as a
/// deliberate empty state rather than a failed image.
class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.brand.withOpacity(0.10),
            AppTheme.field,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.campaign_rounded,
          size: 34,
          color: AppTheme.brand.withOpacity(0.45),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.navy.withOpacity(0.72),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Flexible(
            // Dates and clock times read left-to-right even in the Arabic UI;
            // the app's RTL default was rendering "AM 07:20 · 10/10/2025".
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
