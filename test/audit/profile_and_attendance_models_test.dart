import 'package:flutter_test/flutter_test.dart';
import 'package:sagr/features/attendance/data/models/attendance_model.dart';
import 'package:sagr/models/customer_model.dart';

void main() {
  group('CustomerModel.fromJson vs ProfileIndexResource', () {
    final profile = {
      'id': 7,
      'name': 'Ali',
      'email': 'ali@example.com',
      'phone': '500000000',
      'type': 'employee',
      'firstName': 'Ali',
      'middleName': 'Saad',
      'lastName': 'Omar',
      'countryCode': 'sa',
      'gender': 'male',
      'is_completed': true,
      'fcm_token': null,
      'nationalID': '1234567890',
      'experts': null,
      'previous_events_past': null,
      'chronic_diseases': null,
      'image': 'images/1.jpg',
      'emp_cv': 'files/1.pdf',
      'iban_file': 'files/2.pdf',
      'status': 'active',
      'last_seen': null,
      'ibanNo': null,
      'bankAccountName': 'Ali',
      'job': {'id': 1, 'name': 'Usher'},
      'maritalStatus': null,
      'education': null,
      'region': null,
      'languages': [],
    };

    test('parses a completed profile', () {
      final c = CustomerModel.fromJson(profile);
      expect(c.id, 7);
      expect(c.isCompleted, isTrue);
      expect(c.nationalID, '1234567890');
    });

    test('freshly-registered user (signup response has no is_completed attr)', () {
      final c = CustomerModel.fromJson({...profile, 'is_completed': null, 'firstName': null});
      expect(c.isCompleted, isFalse);
      expect(c.firstName, '');
    });

    test('email/type are not mapped by fromJson', () {
      final c = CustomerModel.fromJson(profile);
      expect(c.email, isNull);
      expect(c.type, isNull);
    });
  });

  group('AttendanceModel.fromJson vs AttendanceReportService::getUserAttendanceReport', () {
    test('parses PHP shapes (floor() floats, string event ids)', () {
      final json = {
        'user_id': 7,
        'user_name': 'Ali',
        'daily_reports': [
          {
            'date': '2026-10-12',
            'event_id': '42', // explode() result -> string
            'event_name': 'Riyadh Season',
            'zone_name': 'Gate A',
            'total_hours': 2.0, // floor() -> float
            'total_minutes': 135,
            'formatted_duration': '2 hours 15 minutes',
            'attendance_time': '16:00:00',
            'departure_time': null,
            'sessions': [
              {
                'attendance': '16:00:00',
                'departure': '18:15:00',
                'duration_minutes': 135,
                'duration_formatted': '2h 15m',
              },
              {
                'attendance': '19:00:00',
                'departure': 'Still present',
                'duration_minutes': 0,
                'duration_formatted': 'Ongoing',
              },
            ],
            'records_count': 3,
          }
        ],
        'event_totals': [
          {
            'event_id': '42',
            'event_name': 'Riyadh Season',
            'total_minutes': 135,
            'days_count': 1,
            'total_hours': 2.0,
            'remaining_minutes': 15,
            'formatted_duration': '2 hours 15 minutes',
          }
        ],
        'grand_total_hours': 2.0,
        'grand_total_minutes': 135,
        'grand_total_formatted': '2 hours 15 minutes',
      };
      final m = AttendanceModel.fromJson(json);
      expect(m.userId, 7);
      expect(m.grandTotalHours, 2);
      expect(m.dailyReports, hasLength(1));
      expect(m.dailyReports.first.sessions, hasLength(2));
      expect(m.eventTotals, hasLength(1));
    });

    test('empty report', () {
      final m = AttendanceModel.fromJson({
        'user_id': 7,
        'user_name': 'Ali',
        'daily_reports': [],
        'event_totals': [],
        'grand_total_hours': 0,
        'grand_total_minutes': 0,
        'grand_total_formatted': '0 minutes',
      });
      expect(m.dailyReports, isEmpty);
    });
  });
}
