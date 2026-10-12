import 'package:flutter_test/flutter_test.dart';
import 'package:sagr/features/events/data/models/event_access.dart';
import 'package:sagr/features/events/data/models/start_date_time_model.dart';

StartDateTimeModel _window(String status, {bool past = false}) =>
    StartDateTimeModel.fromJson({
      'days': 0,
      'hours': 0,
      'minutes': 0,
      'seconds': 0,
      'is_past': past,
      'total_seconds': 0.0,
      'formatted': '',
      'status': status,
      'is_working_now': status == 'active',
    });

void main() {
  group('EventAccess.fromJson (EventAccess::summary shape)', () {
    test('everything allowed', () {
      final a = EventAccess.fromJson({
        'check_in': true,
        'check_in_reason': null,
        'check_out': true,
        'check_out_reason': null,
        'walkie': true,
        'walkie_reason': null,
        'recordings': true,
      });
      expect(a.checkIn, isTrue);
      expect(a.checkInReason, isNull);
      expect(a.walkie, isTrue);
      expect(a.recordings, isTrue);
      expect(a.toolsUnlocked, isTrue);
      expect(a.attendanceOpen(checkedIn: false), isTrue);
    });

    test('not accepted hides the tools', () {
      final a = EventAccess.fromJson({
        'check_in': false,
        'check_in_reason': 'not_accepted',
        'check_out': false,
        'check_out_reason': 'not_accepted',
        'walkie': false,
        'walkie_reason': 'not_accepted',
        'recordings': false,
      });
      expect(a.toolsUnlocked, isFalse);
      expect(a.checkInReason, EventAccess.notAccepted);
    });

    test('ended: check-in closed but check-out still open', () {
      final a = EventAccess.fromJson({
        'check_in': false,
        'check_in_reason': 'ended',
        'check_out': true,
        'check_out_reason': null,
        'walkie': false,
        'walkie_reason': 'ended',
      });
      expect(a.toolsUnlocked, isTrue);
      expect(a.attendanceOpen(checkedIn: false), isFalse);
      expect(a.attendanceOpen(checkedIn: true), isTrue);
      expect(a.recordings, isFalse);
    });

    test('empty-string reason is treated as no reason', () {
      final a = EventAccess.fromJson({'check_in': true, 'check_in_reason': ''});
      expect(a.checkInReason, isNull);
      expect(a.checkOut, isFalse); // missing key => false
    });
  });

  group('EventAccess.derive mirrors server workflow order', () {
    test('pending application => not_accepted', () {
      final a = EventAccess.derive(
          applicationStatus: 'pending', assigned: true, eventStatus: 'active');
      expect(a.checkInReason, EventAccess.notAccepted);
    });

    test('accepted but unassigned => not_assigned', () {
      final a = EventAccess.derive(
          applicationStatus: 'accepted', assigned: false, eventStatus: 'active');
      expect(a.checkInReason, EventAccess.notAssigned);
    });

    test('accepted+assigned, draft event => event_not_active', () {
      final a = EventAccess.derive(
          applicationStatus: 'accepted', assigned: true, eventStatus: 'draft');
      expect(a.checkInReason, EventAccess.eventNotActive);
    });

    test('upcoming => not_started for both', () {
      final a = EventAccess.derive(
          applicationStatus: 'accepted',
          assigned: true,
          eventStatus: 'active',
          window: _window('upcoming'));
      expect(a.checkInReason, EventAccess.notStarted);
      expect(a.checkOutReason, EventAccess.notStarted);
    });

    test('running => all open', () {
      final a = EventAccess.derive(
          applicationStatus: 'accepted',
          assigned: true,
          eventStatus: 'active',
          window: _window('active'));
      expect(a.checkIn, isTrue);
      expect(a.checkOut, isTrue);
      expect(a.walkie, isTrue);
    });

    test('finished => check-in ended, check-out allowed', () {
      final a = EventAccess.derive(
          applicationStatus: 'accepted',
          assigned: true,
          eventStatus: 'active',
          window: _window('finished', past: true));
      expect(a.checkInReason, EventAccess.ended);
      expect(a.checkOut, isTrue);
    });
  });
}
