import 'package:get/get.dart';

import 'start_date_time_model.dart';

/// What the user may do on an event right now, from the payload's `access`
/// block: whether they can check in, check out and use the walkie-talkie, and
/// a reason code when they can't.
///
/// The server applies the same rules on the attendance and walkie-talkie
/// endpoints, so a tool the app offers is one the server accepts. Servers
/// that don't send the block yet get [EventAccess.derive], which rebuilds the
/// rules from the application status, the assignment and the event window.
class EventAccess {
  static const notAccepted = 'not_accepted';
  static const notAssigned = 'not_assigned';
  static const eventNotActive = 'event_not_active';
  static const notStarted = 'not_started';
  static const ended = 'ended';

  final bool checkIn;
  final String? checkInReason;
  final bool checkOut;
  final String? checkOutReason;
  final bool walkie;
  final String? walkieReason;

  /// A supervisor on the event: may listen back to their zone's walkie-talkie
  /// recordings, during the event or after it.
  final bool recordings;

  const EventAccess({
    required this.checkIn,
    this.checkInReason,
    required this.checkOut,
    this.checkOutReason,
    required this.walkie,
    this.walkieReason,
    this.recordings = false,
  });

  /// Accepted and placed in a zone: attendance and the walkie-talkie belong
  /// to this user's event, even while the event hasn't started. Before that
  /// neither is shown at all.
  bool get toolsUnlocked =>
      checkInReason != notAccepted && checkInReason != notAssigned;

  /// Whether the attendance screen has something to do: check in, or check
  /// out after a check-in (allowed past the event's end).
  bool attendanceOpen({required bool checkedIn}) =>
      checkedIn ? checkOut : checkIn;

  factory EventAccess.fromJson(Map<String, dynamic> json) {
    String? reason(Object? value) {
      final s = value?.toString() ?? '';
      return s.isEmpty ? null : s;
    }

    return EventAccess(
      checkIn: json['check_in'] == true,
      checkInReason: reason(json['check_in_reason']),
      checkOut: json['check_out'] == true,
      checkOutReason: reason(json['check_out_reason']),
      walkie: json['walkie'] == true,
      walkieReason: reason(json['walkie_reason']),
      recordings: json['recordings'] == true,
    );
  }

  /// The server's rules, rebuilt from what older payloads carry. The walkie
  /// follows check-in here: the day-wide window it gets on the server isn't
  /// derivable from the start countdown alone.
  factory EventAccess.derive({
    required String applicationStatus,
    required bool assigned,
    String? eventStatus,
    StartDateTimeModel? window,
  }) {
    final String? workflow = applicationStatus != 'accepted'
        ? notAccepted
        : !assigned
            ? notAssigned
            : eventStatus != null && eventStatus != 'active'
                ? eventNotActive
                : null;

    final started = window != null &&
        (window.isActive ||
            window.isFinished ||
            window.isWorkingNow ||
            (window.status == null && window.isPast));

    final checkIn = workflow ??
        (!started
            ? notStarted
            : window.isFinished
                ? ended
                : null);
    final checkOut = workflow ?? (started ? null : notStarted);

    return EventAccess(
      checkIn: checkIn == null,
      checkInReason: checkIn,
      checkOut: checkOut == null,
      checkOutReason: checkOut,
      walkie: checkIn == null,
      walkieReason: checkIn,
    );
  }
}

/// Why a tool is unavailable, in the user's language.
String eventAccessMessage(String? reason, {bool forWalkie = false}) {
  switch (reason) {
    case EventAccess.notAccepted:
      return 'Available once your application is accepted.'.tr;
    case EventAccess.notAssigned:
      return 'You have not been assigned to a zone for this event yet.'.tr;
    case EventAccess.eventNotActive:
      return 'This event has not been activated yet.'.tr;
    case EventAccess.notStarted:
      return forWalkie
          ? 'The walkie-talkie opens on the event day.'.tr
          : 'Check-in opens when the event starts.'.tr;
    case EventAccess.ended:
      return 'This event has ended.'.tr;
    default:
      return 'This action is not available.'.tr;
  }
}
