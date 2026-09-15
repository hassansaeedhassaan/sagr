/// Laravel Reverb (WebSocket) connection settings for the realtime chat.
///
/// These MUST match the backend `.env` REVERB_* values and how Reverb is
/// exposed in production.
///
/// Local dev (php artisan reverb:start on the same machine):
///   host = 10.0.2.2 (Android emulator) / localhost (iOS sim), wsPort = 8080,
///   useTLS = false.
///
/// Production: run Reverb behind your TLS reverse proxy (nginx) on sagr.net,
/// proxying the /app and /apps paths to the Reverb server. Then:
///   host = 'sagr.net', wssPort = 443, useTLS = true.
class ReverbConfig {
  /// Matches backend REVERB_APP_KEY on production sagr.net. For local testing
  /// against the Mac backend, swap in its dev key 'lpjal8h86sa8ldjmpniw'.
  static const String appKey = 'vbxy7ig3xcwsl3vdl7cd';

  /// Host that serves the Reverb WebSocket. No scheme, no path.
  /// Must be the same server as BASEURL — Reverb runs there behind the nginx
  /// proxy. For LAN testing, point at the Mac's Wi-Fi IP (e.g. 172.20.10.11)
  /// and set useTLS = false; restore both before committing.
  static const String host = 'sagr.net';

  /// TLS (wss) port. Behind an nginx proxy this is normally 443.
  static const int wssPort = 443;

  /// Plain (ws) port used only when [useTLS] is false (local dev).
  static const int wsPort = 8080;

  /// Use wss in production. Set false only for local plaintext dev.
  static const bool useTLS = true;

  /// pusher_channels_flutter requires a non-empty cluster string even though
  /// Reverb ignores it. Any value works.
  static const String cluster = 'mt1';
}
