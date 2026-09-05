import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';

/// Fetches short-lived Agora RTC tokens from the backend.
///
/// Replaces the old flow where the App ID was hardcoded and the token was
/// embedded in the event JSON. The server now mints a token bound to the
/// authenticated user for the requested channel.
class WalkieTokenResult {
  final String appId;
  final String channel;
  final int uid;
  final String token;
  final int expiresAt;

  WalkieTokenResult({
    required this.appId,
    required this.channel,
    required this.uid,
    required this.token,
    required this.expiresAt,
  });

  factory WalkieTokenResult.fromJson(Map<String, dynamic> json) {
    return WalkieTokenResult(
      appId: json['app_id'].toString(),
      channel: json['channel'].toString(),
      uid: json['uid'] is int ? json['uid'] : int.parse(json['uid'].toString()),
      token: json['token'].toString(),
      expiresAt: json['expires_at'] is int
          ? json['expires_at']
          : int.tryParse(json['expires_at'].toString()) ?? 0,
    );
  }
}

class WalkieTokenService {
  final Dio _dio = Dio();
  final _storage = GetStorage();

  /// GET /api/v1/walkie-talkie/{channel}/token
  Future<WalkieTokenResult> fetchToken(String channelName) async {
    final token = _storage.read('access_token');

    final response = await _dio.get(
      '$BASEURL/walkie-talkie/$channelName/token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return WalkieTokenResult.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
