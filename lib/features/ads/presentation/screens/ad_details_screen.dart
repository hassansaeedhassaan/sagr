import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/features/ads/data/models/ad_model.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/features/ads/presentation/widgets/ad_card.dart';
import 'package:sagr/theme/app_theme.dart';

/// Full view of a single advertisement.
///
/// Renders the [AdModel] handed over by the feed rather than re-fetching it:
/// the backend exposes no ad-detail route (`/advertisement/{id}/show` 404s), and
/// the list response already carries every field this screen shows. Tapping an
/// ad used to route into the product detail screen, whose failed fetch left a
/// null product and threw "Null check operator used on a null value".
class AdDetailsScreen extends StatelessWidget {
  const AdDetailsScreen({super.key});

  AdModel? get _ad {
    final args = Get.arguments;
    return args is AdModel ? args : null;
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;

    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        title: Text('Ad Details'.tr),
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.surface,
      ),
      body: ad == null ? const _Unavailable() : _Body(ad: ad),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.ad});

  final AdModel ad;

  String get _meta {
    final parts = <String>[
      if (ad.date?.isNotEmpty == true) ad.date!,
      if (ad.time?.isNotEmpty == true) AdCard.shortTime(ad.time!),
    ];
    return parts.isNotEmpty ? parts.join('  ·  ') : (ad.datetime ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final logo = ad.logo;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: (logo == null || logo.isEmpty)
                ? const _CoverFallback()
                : CachedNetworkImage(
                    imageUrl: '$HOSTURL$logo',
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ColoredBox(color: AppTheme.field),
                    errorWidget: (_, __, ___) => const _CoverFallback(),
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          ad.name ?? '',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.textTitle,
            height: 1.3,
          ),
        ),
        if (_meta.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.schedule_rounded,
                  size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              // Dates and clock times read left-to-right even in the Arabic UI.
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  _meta,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMuted,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ],
        if (ad.description?.isNotEmpty == true) ...[
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: AppTheme.line),
            ),
            child: Text(
              ad.description!,
              style: const TextStyle(
                fontSize: 14,
                height: 1.7,
                color: AppTheme.textBody,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.brand.withOpacity(0.10), AppTheme.field],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.campaign_rounded,
          size: 40,
          color: AppTheme.brand.withOpacity(0.45),
        ),
      ),
    );
  }
}

/// Reached only if the route is opened without an ad (e.g. a stale deep link).
class _Unavailable extends StatelessWidget {
  const _Unavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 40, color: AppTheme.textHint),
            const SizedBox(height: 12),
            Text(
              'Could not load this ad'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
