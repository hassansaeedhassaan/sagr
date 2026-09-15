import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/walkie_talkie/walkie_dev_config.dart';

/// Everything the LiveKit client needs to connect to the room for a walkie
/// channel.
class LiveKitTokenResult {
  final String url;
  final String token;
  final String room;
  final String identity;

  LiveKitTokenResult({
    required this.url,
    required this.token,
    required this.room,
    required this.identity,
  });

  /// Reads the backend's `POST /walkie-talkie/token` payload (`server_url`)
  /// as well as the local dev token server's (`url`).
  factory LiveKitTokenResult.fromJson(Map<String, dynamic> json) {
    return LiveKitTokenResult(
      url: (json['server_url'] ?? json['url'])?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      identity: json['identity']?.toString() ?? '',
    );
  }
}

/// The server answered but declined to issue a token; [message] says why
/// (for example: no active zone assignment for this event).
class WalkieTokenUnavailable implements Exception {
  final String message;

  const WalkieTokenUnavailable(this.message);

  @override
  String toString() => message;
}

/// Fetches a short-lived LiveKit access token from the backend for a channel.
class LiveKitTokenService {
  LiveKitTokenService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              // A walkie session that hangs on the token call looks identical to
              // a dead channel, so bound every leg of the request.
              connectTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  final Dio _dio;
  final _storage = GetStorage();

  /// The backend only signs rooms the caller is assigned to on [eventId], so
  /// the event id is required outside the dev override.
  Future<LiveKitTokenResult> fetchToken(String channelName,
      {int? eventId}) async {
    final auth = _storage.read('access_token');
    final options = Options(
      headers: {
        'Authorization': 'Bearer $auth',
        'Accept': 'application/json',
      },
    );

    if (WalkieDevConfig.enabled) {
      final response = await _dio.get(
        '${WalkieDevConfig.tokenBaseUrl}/livekit/${Uri.encodeComponent(channelName)}/token',
        options: options,
      );
      return LiveKitTokenResult.fromJson(_asMap(response.data));
    }

    if (eventId == null) {
      throw const WalkieTokenUnavailable('Channel information is unavailable.');
    }

    final response = await _dio.post(
      '$BASEURL/walkie-talkie/token',
      data: {'room': channelName, 'event_id': eventId},
      options: options,
    );

    // {status, data: {server_url, token, room, ...}, error}. When the server
    // can't issue a token it still answers 200, with data.channel = null and
    // the reason in data.message.
    final data = _asMap(_asMap(response.data)['data']);
    if (data['token'] == null) {
      throw WalkieTokenUnavailable(
          data['message']?.toString() ?? 'Could not start the walkie-talkie.');
    }
    return LiveKitTokenResult.fromJson(data);
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const FormatException('Unexpected token response.');
  }

  /// Turns a token-fetch failure into something worth showing on the walkie UI.
  static String describeError(Object error) {
    if (error is WalkieTokenUnavailable) return error.message;
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        return 'You are not allowed on this channel.';
      }
      if (status == 404) {
        return 'Walkie-talkie is not enabled on the server yet.';
      }
      if (status != null && status >= 500) {
        return 'The walkie-talkie server is unavailable.';
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return 'Could not reach the walkie-talkie server.';
        default:
          break;
      }
    }
    return 'Could not start the walkie-talkie.';
  }
}
