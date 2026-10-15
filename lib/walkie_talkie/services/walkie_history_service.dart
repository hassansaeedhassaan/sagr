import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';

/// Where one message sits inside its room's recording: play [url] from
/// [offset] for [length].
class WalkieMessageAudio {
  final String url;
  final Duration offset;
  final Duration length;

  const WalkieMessageAudio({
    required this.url,
    required this.offset,
    required this.length,
  });

  static WalkieMessageAudio? fromJson(Object? json) {
    if (json is! Map) return null;
    final url = json['url']?.toString() ?? '';
    if (url.isEmpty) return null;
    int ms(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    return WalkieMessageAudio(
      url: url,
      offset: Duration(milliseconds: ms(json['offset_ms'])),
      length: Duration(milliseconds: ms(json['length_ms'])),
    );
  }
}

/// One push-to-talk message on a walkie-talkie channel.
class WalkieMessage {
  final int id;
  final int speakerId;
  final String speakerName;
  final String? speakerImage;
  final bool isMe;
  final String channel;
  final String channelType;
  final DateTime startedAt;
  final Duration duration;

  /// Null while the room's recording isn't finished, or recording is off.
  final WalkieMessageAudio? audio;

  const WalkieMessage({
    required this.id,
    required this.speakerId,
    required this.speakerName,
    this.speakerImage,
    required this.isMe,
    required this.channel,
    required this.channelType,
    required this.startedAt,
    required this.duration,
    this.audio,
  });

  bool get isSupervisorChannel => channelType == 'supervisor';

  factory WalkieMessage.fromJson(Map<String, dynamic> json) {
    final speaker = json['speaker'] is Map
        ? Map<String, dynamic>.from(json['speaker'] as Map)
        : <String, dynamic>{};
    final image = speaker['image']?.toString() ?? '';

    return WalkieMessage(
      id: int.tryParse('${json['id']}') ?? 0,
      speakerId: int.tryParse('${speaker['id']}') ?? 0,
      speakerName: speaker['name']?.toString() ?? '',
      speakerImage: image.isEmpty ? null : image,
      isMe: speaker['is_me'] == true,
      channel: json['channel']?.toString() ?? '',
      channelType: json['channel_type']?.toString() ?? 'public',
      startedAt:
          DateTime.tryParse('${json['started_at']}')?.toLocal() ?? DateTime.now(),
      duration: Duration(
          milliseconds: json['duration_ms'] is num
              ? (json['duration_ms'] as num).toInt()
              : 0),
      audio: WalkieMessageAudio.fromJson(json['audio']),
    );
  }
}

/// One page of the history.
class WalkieHistoryPage {
  final List<WalkieMessage> items;
  final int currentPage;
  final int lastPage;

  const WalkieHistoryPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;
}

/// The server declined, with a reason worth showing.
class WalkieHistoryDenied implements Exception {
  final String message;

  const WalkieHistoryDenied(this.message);

  @override
  String toString() => message;
}

/// `POST /walkie-talkie/transmissions` and `GET /walkie-talkie/history`: the
/// log of who said what on the walkie-talkie channels.
class WalkieHistoryService {
  WalkieHistoryService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
            ));

  final Dio _dio;
  final _storage = GetStorage();

  Options get _options => Options(
        headers: {
          'Authorization': 'Bearer ${_storage.read('access_token')}',
          'Accept': 'application/json',
        },
        // A refusal carries its reason in the body.
        validateStatus: (status) => status != null && status < 500,
      );

  /// Reports a finished transmission. Best effort: a lost report only means
  /// one missing line in the history, never a failed walkie-talkie.
  Future<void> report({
    required int eventId,
    required String channel,
    required Duration held,
  }) async {
    try {
      await _dio.post(
        '$BASEURL/walkie-talkie/transmissions',
        data: {
          'event_id': eventId,
          'channel': channel,
          'duration_ms': held.inMilliseconds.clamp(100, 300000),
        },
        options: _options,
      );
    } catch (_) {}
  }

  Future<WalkieHistoryPage> fetch(int eventId, {int page = 1}) async {
    final response = await _dio.get(
      '$BASEURL/walkie-talkie/history',
      queryParameters: {'event_id': eventId, 'page': page},
      options: _options,
    );

    final body = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final status =
        body['status'] is int ? body['status'] as int : response.statusCode;

    if (response.statusCode != 200 || status != 200) {
      final error = body['error'];
      throw WalkieHistoryDenied(error is Map && error['message'] != null
          ? error['message'].toString()
          : 'Could not load the messages.');
    }

    final data = body['data'] is Map
        ? Map<String, dynamic>.from(body['data'] as Map)
        : <String, dynamic>{};
    final items = data['items'] is List
        ? (data['items'] as List)
            .whereType<Map>()
            .map((e) => WalkieMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WalkieMessage>[];

    return WalkieHistoryPage(
      items: items,
      currentPage: int.tryParse('${data['current_page']}') ?? page,
      lastPage: int.tryParse('${data['last_page']}') ?? page,
    );
  }

  static String describeError(Object error) => error is WalkieHistoryDenied
      ? error.message
      : 'Could not load the messages.';
}
