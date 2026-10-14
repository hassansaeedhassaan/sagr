import 'dart:io';

import 'package:geolocator/geolocator.dart';

/// One fresh GPS fix at the best accuracy the platform offers.
///
/// `desiredAccuracy: high` let Android hand back a network/Wi-Fi guess tens
/// to hundreds of metres off, which put people standing inside their zone
/// outside it. The server allows for each fix's reported accuracy at the
/// zone edge (ZoneGeometry), so the accuracy is always sent with the fix.
class PreciseLocation {
  PreciseLocation._();

  /// Fixes older than this are the OS's cached position, not where the
  /// user is now.
  static const Duration maxAge = Duration(seconds: 30);

  /// Edge allowance in metres for a fix of this accuracy; the same clamp as
  /// the server's ZoneGeometry::tolerance().
  static double tolerance(double accuracy) => accuracy.clamp(10.0, 30.0);

  static LocationSettings settings(Duration timeLimit) {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: timeLimit,
      );
    }
    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: timeLimit,
      );
    }
    return LocationSettings(accuracy: LocationAccuracy.best, timeLimit: timeLimit);
  }

  /// Throws like Geolocator.getCurrentPosition (permission, timeout, ...).
  static Future<Position> current({
    Duration timeLimit = const Duration(seconds: 12),
  }) async {
    var position = await Geolocator.getCurrentPosition(
      locationSettings: settings(timeLimit),
    );
    if (DateTime.now().difference(position.timestamp) > maxAge) {
      // A stale cached fix: ask once more for a live one.
      position = await Geolocator.getCurrentPosition(
        locationSettings: settings(timeLimit),
      );
    }
    return position;
  }
}
