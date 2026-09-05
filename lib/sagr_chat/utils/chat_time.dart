import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// WhatsApp-style compact, locale-aware time formatting.
///
/// Clock format follows the active locale (12h vs 24h) via [DateFormat.jm].
/// Relative words ("Today", "Yesterday") are translated through GetX `.tr`.
class ChatTime {
  const ChatTime._();

  static String get _locale => Get.locale?.toString() ?? 'en';

  /// Clock time only, e.g. "5:30 PM" / "17:30" / Arabic equivalent.
  static String clock(DateTime dt) =>
      DateFormat.jm(_locale).format(dt.toLocal());

  /// Trailing time shown in a conversation list row.
  /// Today -> clock, yesterday -> "Yesterday", this week -> weekday, else date.
  static String listTime(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final day = DateTime(local.year, local.month, local.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;

    if (diff == 0) return clock(local);
    if (diff == 1) return 'Yesterday'.tr;
    if (diff < 7) return DateFormat.E(_locale).format(local); // Mon, Tue...
    return DateFormat.yMd(_locale).format(local);
  }

  /// Centered divider label between message groups.
  static String dateDivider(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final day = DateTime(local.year, local.month, local.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;

    if (diff == 0) return 'Today'.tr;
    if (diff == 1) return 'Yesterday'.tr;
    if (diff < 7) return DateFormat.EEEE(_locale).format(local); // Monday...
    return DateFormat.yMMMMd(_locale).format(local); // May 12, 2025
  }
}
