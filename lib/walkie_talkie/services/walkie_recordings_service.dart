import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';

/// One finished recording of a walkie-talkie channel, with a short-lived
/// playback link to the audio in the server's bucket.
class WalkieRecording {
  final int id;
  final String channelType;
  final String channelName;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final String? url;

  const WalkieRecording({
    required this.id,
    required this.channelType,
    required this.channelName,
    this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.url,
  });

  bool get isSupervisorChannel => channelType == 'supervisor';

  factory WalkieRecording.fromJson(Map<String, dynamic> json) {
    DateTime? date(Object? value) =>
        value == null ? null : DateTime.tryParse(value.toString())?.toLocal();
    final url = json['url']?.toString() ?? '';

    return WalkieRecording(
      id: int.tryParse('${json['id']}') ?? 0,
      channelType: json['channel_type']?.toString() ?? 'public',
      channelName: json['channel_name']?.toString() ?? '',
      startedAt: date(json['started_at']),
      endedAt: date(json['ended_at']),
      durationSeconds: json['duration_seconds'] is num
          ? (json['duration_seconds'] as num).toInt()
          : null,
      url: url.isEmpty ? null : url,
    );
  }
}

/// The server declined, with a reason worth showing (not a supervisor).
class WalkieRecordingsDenied implements Exception {
  final String message;

  const WalkieRecordingsDenied(this.message);

  @override
  String toString() => message;
}

/// `GET /walkie-talkie/recordings`: an event supervisor's recordings of
/// their zone's channels, newest first.
class WalkieRecordingsService {
  WalkieRecordingsService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
            ));

  final Dio _dio;
  final _storage = GetStorage();

  Future<List<WalkieRecording>> fetch(int eventId) async {
    final response = await _dio.get(
      '$BASEURL/walkie-talkie/recordings',
      queryParameters: {'event_id': eventId},
      options: Options(
        headers: {
          'Authorization': 'Bearer ${_storage.read('access_token')}',
          'Accept': 'application/json',
        },
        // A refusal carries its reason in the body.
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    final body = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final status = body['status'] is int ? body['status'] as int : response.statusCode;

    if (response.statusCode != 200 || status != 200) {
      final error = body['error'];
      throw WalkieRecordingsDenied(error is Map && error['message'] != null
          ? error['message'].toString()
          : 'Could not load the recordings.');
    }

    final data = body['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => WalkieRecording.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static String describeError(Object error) => error is WalkieRecordingsDenied
      ? error.message
      : 'Could not load the recordings.';
}
