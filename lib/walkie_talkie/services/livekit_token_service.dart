import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';

/// Result of GET /api/v1/livekit/{channel}/token — everything the LiveKit
/// client needs to connect to the room for a walkie channel.
class LiveKitTokenResult {
  final String url;
  final String token;
  final String room;
  final String identity;
  final int expiresAt;

  LiveKitTokenResult({
    required this.url,
    required this.token,
    required this.room,
    required this.identity,
    required this.expiresAt,
  });

  factory LiveKitTokenResult.fromJson(Map<String, dynamic> json) {
    return LiveKitTokenResult(
      url: json['url']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      identity: json['identity']?.toString() ?? '',
      expiresAt: json['expires_at'] is int
          ? json['expires_at']
          : int.tryParse(json['expires_at']?.toString() ?? '') ?? 0,
    );
  }
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

  Future<LiveKitTokenResult> fetchToken(String channelName) async {
    final auth = _storage.read('access_token');

    final response = await _dio.get(
      '$BASEURL/livekit/${Uri.encodeComponent(channelName)}/token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $auth',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Unexpected token response.');
    }
    return LiveKitTokenResult.fromJson(Map<String, dynamic>.from(data));
  }

  /// Turns a token-fetch failure into something worth showing on the walkie UI.
  static String describeError(Object error) {
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
