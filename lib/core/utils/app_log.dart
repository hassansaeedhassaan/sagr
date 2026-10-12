import 'package:flutter/foundation.dart';

/// Debug-only logging. Release builds print nothing, so tokens and profile
/// data never reach the device log.
void appLog(Object? message) {
  if (kDebugMode) debugPrint('$message');
}
