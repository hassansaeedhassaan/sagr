import 'package:flutter_test/flutter_test.dart';
import 'package:sagr/features/events/data/models/event_model.dart';

/// Mirrors App\Http\Resources\Api\V1\Events\EventResource::toArray as of the
/// audited backend (types as MySQL/PDO + json_encode would emit them).
Map<String, dynamic> backendEvent({
  Map<String, dynamic>? channel,
  bool withSupervisor = false,
  Map<String, dynamic>? access,
}) {
  return {
    'id': 42,
    'name': 'Riyadh Season',
    'logo': 'events/logo.png',
    'user_id': 7,
    'description': 'desc',
    'datetime': 'Monday 12 October',
    'date': '12/10/2026',
    'time': '18:00:00 PM',
    'preparing': '2 hours',
    'address': 'Riyadh',
    'ago': '2 days ago',
    'company': {'id': 3, 'name': 'Acme'},
    'zone_id': 9,
    'jobs': [
      {'id': 1, 'name': 'Usher', 'quantity': 10, 'display_name': '10 Usher'},
      {'id': 2, 'name': 'Guard', 'quantity': null, 'display_name': ' Guard'},
    ],
    'appliedStatus': 'accepted',
    'nationalID': '1234567890',
    'startDateTimes': {'day': 12, 'hour': 18, 'min': 0, 'sec': 0},
    'startDateTime': {
      'days': 0,
      'hours': 1,
      'minutes': 2,
      'seconds': 3,
      'is_past': false,
      'total_seconds': 3723.0,
      'formatted': '0 days, 1 hours, 2 minutes, 3 seconds',
      'is_working_now': false,
      'status': 'upcoming',
    },
    'assigned': true,
    'event_status': 'active',
    'access': access ??
        {
          'check_in': false,
          'check_in_reason': 'not_started',
          'check_out': false,
          'check_out_reason': 'not_started',
          'walkie': false,
          'walkie_reason': 'not_started',
          'recordings': false,
        },
    'walkie_recorded': true,
    'channel': channel,
    'userType': withSupervisor ? 'supervisor' : 'employee',
    if (withSupervisor)
      'supervisorChannel': {
        'channel_name': 'zone-9-sup',
        'channel_display_name': 'Supervisors',
        'provider': 'livekit',
        'server_url': 'wss://example.livekit.cloud',
        'room': 'zone-9-sup',
        'token': 'jwt.sup',
        'identity': 'user-7',
        'can_publish': true,
        'expires_at': '2026-10-12T20:00:00+03:00',
        'expires_in': 3600,
      },
    'coordinates': [
      {'latitude': '24.7136000', 'longitude': '46.6753000', 'order': 1},
      {'latitude': '24.7140000', 'longitude': '46.6760000', 'order': 2},
    ],
    'isCheckIn': false,
    'attachment': null,
    'application': {
      'id': 100,
      'status': 'accepted',
      'submitted_at': '2026-10-01T10:00:00+03:00',
      'updated_at': '2026-10-02T10:00:00+03:00',
      'contract_url': 'https://sagr.net/storage/contracts/c.pdf',
      'can_apply': false,
      'timeline': [
        {'status': 'pending', 'at': '2026-10-01T10:00:00+03:00'},
        {'status': 'initAccept', 'at': '2026-10-01T12:00:00+03:00'},
        {'status': 'accepted', 'at': '2026-10-02T10:00:00+03:00'},
      ],
      'assignment': {
        'zone_id': 9,
        'zone_name': 'Gate A',
        'role': 'employee',
        'assigned_at': '2026-10-02T11:00:00+03:00',
      },
    },
    'periods': [
      {'id': 5, 'period': 'من الساعة ٤ مساءاً حتي الساعة ١٠ مساءاً'},
    ],
    'location': null,
  };
}

void main() {
  group('EventModel.fromJson against EventResource', () {
    test('parses the full payload', () {
      final e = EventModel.fromJson(backendEvent());
      expect(e.id, 42);
      expect(e.zone_id, 9);
      expect(e.user_id, 7);
      expect(e.companyName, 'Acme');
      expect(e.jobs, hasLength(2));
      expect(e.jobs!.last.quantity, isNull);
      expect(e.periods, hasLength(1));
      expect(e.zoneCoordinates, hasLength(2));
      expect(e.zoneCoordinates!.first.latitude, closeTo(24.7136, 1e-9));
      expect(e.startDateTime!.totalSeconds, 3723.0);
      expect(e.application!.status, 'accepted');
      expect(e.application!.reached('initAccept'), isTrue);
      expect(e.application!.assignment!.zoneId, 9);
      expect(e.application!.contractUrl, isNotNull);
      expect(e.walkieRecorded, isTrue);
      expect(e.attachment, 'undefined'); // null attachment -> 'undefined'
      expect(e.channel, isNull);
      expect(e.supervisorChannel, isNull);
      // server access block wins over the local derivation
      expect(e.access.checkInReason, 'not_started');
    });

    test('server zone_id null (not assigned) parses', () {
      final json = backendEvent()..['zone_id'] = null;
      expect(EventModel.fromJson(json).zone_id, isNull);
    });

    test('older payload without access block derives rules locally', () {
      final json = backendEvent()..remove('access');
      final e = EventModel.fromJson(json);
      expect(e.accessInfo, isNull);
      expect(e.access.checkInReason, 'not_started');
    });

    test('LiveKit join payload: room parsed, token is NOT read from the event '
        '(ChannelInfo reads legacy agora_token, backend sends token)', () {
      final e = EventModel.fromJson(backendEvent(
        channel: {
          'channel_name': 'zone-9',
          'channel_display_name': 'Gate A',
          'provider': 'livekit',
          'server_url': 'wss://example.livekit.cloud',
          'room': 'zone-9',
          'token': 'jwt.employee',
          'identity': 'user-7',
          'can_publish': true,
          'expires_at': '2026-10-12T20:00:00+03:00',
          'expires_in': 3600,
        },
        withSupervisor: true,
      ));
      expect(e.channel!.channelName, 'zone-9');
      expect(e.channel!.displayName, 'Gate A');
      expect(e.channel!.agoraToken, ''); // token key mismatch
      expect(e.supervisorChannel!.channelName, 'zone-9-sup');
      expect(e.userType, 'supervisor');
    });

    test('job with null name still parses (regression)', () {
      final json = backendEvent();
      (json['jobs'] as List).add({'id': 3, 'name': null, 'quantity': 1});
      final e = EventModel.fromJson(json);
      expect(e.jobs!.last.name, '');
    });
  });
}
