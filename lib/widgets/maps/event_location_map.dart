import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sagr/features/events/data/models/zone_coordinate_model.dart';
import 'package:sagr/theme/app_theme.dart';

/// Live OpenStreetMap view of an event's geofenced zone.
///
/// Replaces the `assets/images/map.png` placeholder that used to stand in for a
/// map: it draws the actual zone polygon the attendance check runs against, so
/// what the employee sees is the boundary they have to be inside.
///
/// Falls back to the old static image when the event carries no coordinates,
/// so a zone-less event still renders a sane card instead of grey tiles.
class EventLocationMap extends StatelessWidget {
  const EventLocationMap({
    super.key,
    required this.zone,
    this.locationUrl,
    this.interactive = false,
  });

  /// Zone boundary, in the order the backend defines it.
  final List<ZoneCoordinates> zone;

  /// The event's `location` field — a Google Maps link of the form
  /// `https://maps.google.com/maps?q=<lat>,<lng>`. Events without a mapped
  /// zone still carry this, so it's the fallback the map centres on.
  final String? locationUrl;

  /// Whether the user can pan/zoom. Off inside small preview cards, where the
  /// map would otherwise swallow the parent scroll gesture.
  final bool interactive;

  List<LatLng> get _points {
    if (zone.isNotEmpty) {
      final sorted = [...zone]..sort((a, b) => a.order.compareTo(b.order));
      return sorted.map((c) => LatLng(c.latitude, c.longitude)).toList();
    }
    final single = _pointFromLocationUrl(locationUrl);
    return single == null ? const [] : [single];
  }

  /// Pulls `q=<lat>,<lng>` out of the event's maps link. Returns null for
  /// anything that isn't a usable coordinate pair.
  static LatLng? _pointFromLocationUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final q = Uri.tryParse(url)?.queryParameters['q'];
    if (q == null) return null;
    final parts = q.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final points = _points;
    if (points.isEmpty) {
      return Image.asset('assets/images/map.png', fit: BoxFit.cover);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: points.first,
        initialZoom: 15,
        // A single point has no extent to fit — just centre on it.
        initialCameraFit: points.length > 1
            ? CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(points),
                padding: const EdgeInsets.all(28),
              )
            : null,
        interactionOptions: InteractionOptions(
          flags: interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
        backgroundColor: AppTheme.field,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // OSM's tile policy requires a real identifier on every request.
          userAgentPackageName: 'com.etlaq.sagrapp',
          maxNativeZoom: 19,
        ),
        if (points.length > 2)
          PolygonLayer(
            polygons: [
              Polygon(
                points: points,
                color: AppTheme.brand.withOpacity(0.18),
                borderColor: AppTheme.brand,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: _centroid(points),
              width: 36,
              height: 36,
              alignment: Alignment.topCenter,
              child: const _ZonePin(),
            ),
          ],
        ),
        // Attribution is a condition of using OSM's tiles, so it sits top-left
        // — the bottom of these cards is covered by the address bar.
        const Align(
          alignment: Alignment.topLeft,
          child: _OsmAttribution(),
        ),
      ],
    );
  }

  LatLng _centroid(List<LatLng> points) {
    var lat = 0.0;
    var lng = 0.0;
    for (final p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }
}

class _ZonePin extends StatelessWidget {
  const _ZonePin();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.place_rounded, color: Colors.white, size: 18),
    );
  }
}

class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(4)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: Directionality(
            // The app runs RTL by default, which would render this as
            // "OpenStreetMap ©".
            textDirection: TextDirection.ltr,
            child: Text(
              '© OpenStreetMap',
              style: TextStyle(fontSize: 8.5, color: AppTheme.textMuted),
            ),
          ),
        ),
      ),
    );
  }
}
