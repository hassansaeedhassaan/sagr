import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/utilities/map.dart';

import '../../data/models/event_model.dart';
import 'event_status_pill.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Premium, compact event card (logo-left) — the single card used across the
/// All / My / Previous event lists. Tap opens the event; the location button
/// opens the map; the status pill routes by application status.
class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => openEventByStatus(event.id, event.appliedStatus),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 1, color: AppTheme.line),
                ),
                _meta(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logo(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppTheme.textTitle,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      event.address ?? "غير متوفر",
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.2,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if ((event.ago ?? '').isNotEmpty) ...[
          const SizedBox(width: 8),
          _timeAgo(event.ago!),
        ],
      ],
    );
  }

  Widget _meta() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.date.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTitle,
                  fontFeatures: _tabular,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                event.time.toString(),
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.textMuted,
                  fontFeatures: _tabular,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _mapButton(),
        const SizedBox(width: 8),
        EventStatusPill(
          status: event.appliedStatus,
          compact: true,
          onTap: () => openEventByStatus(event.id, event.appliedStatus),
        ),
      ],
    );
  }

  Widget _logo() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset("assets/images/sagr-logo.png", fit: BoxFit.contain),
      ),
    );
  }

  Widget _timeAgo(String ago) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded,
              size: 11, color: AppTheme.textMuted),
          const SizedBox(width: 3),
          Text(
            ago,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w600,
              fontFeatures: _tabular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton() {
    return Material(
      color: AppTheme.navy,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => MapsUtils.openMap(event.location ?? ''),
        child: const SizedBox(
          width: 34,
          height: 34,
          child: Icon(Icons.location_on_outlined,
              color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
