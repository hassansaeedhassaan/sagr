import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/config/reverb_config.dart';

/// Realtime chat transport backed by Laravel Reverb.
///
/// Reverb speaks the Pusher WebSocket protocol. `pusher_channels_flutter`
/// cannot target a self-hosted host, so we implement the small slice of the
/// protocol we need directly over a raw WebSocket:
///   1. connect to `/app/{appKey}` and read the `socket_id`
///   2. authorize private channels via `POST {BASEURL}/broadcasting/auth`
///   3. send `pusher:subscribe`, answer `pusher:ping`, parse incoming events
///
/// Private-channel auth uses the logged-in user's JWT (`access_token`), which
/// the backend authorizes with the `api` guard.
class ReverbService extends GetxService {
  final _storage = GetStorage();
  final _authDio = Dio();

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  String? _socketId;
  bool _connecting = false;
  bool _manuallyClosed = false;
  Timer? _reconnectTimer;

  /// Channels we want to be subscribed to, so we can restore them after a
  /// reconnect. Values are the full pusher channel names (`private-...`).
  final Set<String> _desired = <String>{};
  final Set<String> _active = <String>{};

  void Function(Map<String, dynamic> data)? onMessageSent;
  void Function(Map<String, dynamic> data)? onMessageRead;
  void Function(Map<String, dynamic> data)? onUserTyping;

  Future<ReverbService> init() async {
    await _connect();
    return this;
  }

  String get _wsUrl {
    final scheme = ReverbConfig.useTLS ? 'wss' : 'ws';
    final port = ReverbConfig.useTLS ? ReverbConfig.wssPort : ReverbConfig.wsPort;
    return '$scheme://${ReverbConfig.host}:$port/app/${ReverbConfig.appKey}'
        '?protocol=7&client=flutter&version=2.0&flash=false';
  }

  Future<void> _connect() async {
    if (_connecting || _channel != null) return;
    _connecting = true;
    _manuallyClosed = false;

    try {
      final channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _channel = channel;
      _sub = channel.stream.listen(
        _onData,
        onDone: _onDone,
        onError: (e) {
          print('❌ Reverb socket error: $e');
          _onDone();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('❌ Reverb connect failed: $e');
      _scheduleReconnect();
    } finally {
      _connecting = false;
    }
  }

  void _onData(dynamic raw) {
    final frame = _asMap(raw);
    if (frame == null) return;

    final event = frame['event']?.toString();
    final data = _decodeData(frame['data']);

    switch (event) {
      case 'pusher:connection_established':
        _socketId = data?['socket_id']?.toString();
        print('🔌 Reverb connected, socket_id=$_socketId');
        _resubscribeAll();
        break;
      case 'pusher:ping':
        _send({'event': 'pusher:pong', 'data': {}});
        break;
      case 'pusher_internal:subscription_succeeded':
        if (frame['channel'] != null) _active.add(frame['channel'].toString());
        break;
      case 'message.sent':
        if (data != null) onMessageSent?.call(data);
        break;
      case 'message.read':
        if (data != null) onMessageRead?.call(data);
        break;
      case 'user.typing':
        if (data != null) onUserTyping?.call(data);
        break;
    }
  }

  void _onDone() {
    _sub?.cancel();
    _sub = null;
    _channel = null;
    _socketId = null;
    _active.clear();
    if (!_manuallyClosed) _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_manuallyClosed) _connect();
    });
  }

  Future<void> _resubscribeAll() async {
    for (final channel in _desired) {
      await _subscribe(channel);
    }
  }

  Future<void> _subscribe(String channel) async {
    final socketId = _socketId;
    if (socketId == null) return;

    try {
      final auth = await _authorize(channel, socketId);
      _send({
        'event': 'pusher:subscribe',
        'data': {'channel': channel, 'auth': auth},
      });
    } catch (e) {
      print('❌ Reverb auth/subscribe failed for $channel: $e');
    }
  }

  Future<String> _authorize(String channelName, String socketId) async {
    final token = _storage.read('access_token');

    final response = await _authDio.post(
      '$BASEURL/broadcasting/auth',
      data: {'socket_id': socketId, 'channel_name': channelName},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final body = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;
    return (body as Map)['auth'].toString();
  }

  // ── Public API ───────────────────────────────────────────────────────────

  Future<void> subscribeConversation(int conversationId) async {
    final channel = 'private-conversation.$conversationId';
    _desired.add(channel);
    await _connect();
    if (_socketId != null && !_active.contains(channel)) {
      await _subscribe(channel);
    }
  }

  Future<void> unsubscribeConversation(int conversationId) async {
    final channel = 'private-conversation.$conversationId';
    _desired.remove(channel);
    _active.remove(channel);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channel},
    });
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _send(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      try {
        return Map<String, dynamic>.from(jsonDecode(raw) as Map);
      } catch (_) {
        return null;
      }
    }
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  /// Pusher delivers the `data` field as a JSON-encoded string.
  Map<String, dynamic>? _decodeData(dynamic data) {
    if (data == null) return null;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.trim().startsWith('{')) {
      try {
        return Map<String, dynamic>.from(jsonDecode(data) as Map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  void onClose() {
    _manuallyClosed = true;
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
    super.onClose();
  }
}
