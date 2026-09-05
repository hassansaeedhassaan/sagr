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
  final Dio _dio = Dio();
  final _storage = GetStorage();

  Future<LiveKitTokenResult> fetchToken(String channelName) async {
    final auth = _storage.read('access_token');

    final response = await _dio.get(
      '$BASEURL/livekit/$channelName/token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $auth',
          'Accept': 'application/json',
        },
      ),
    );

    return LiveKitTokenResult.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
