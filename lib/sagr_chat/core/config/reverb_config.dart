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
  /// Matches backend REVERB_APP_KEY. The dev key is the default; replace with
  /// the production key once Reverb is deployed.
  static const String appKey = 'lpjal8h86sa8ldjmpniw';

  /// Host that serves the Reverb WebSocket. No scheme, no path.
  /// Must be the same server as BASEURL (staging) — Reverb runs there behind
  /// the nginx proxy. sagr.net is the future production host.
  // TEMP — local realtime testing over LAN. Point at the Mac's Wi-Fi IP so a
  // physical device on the same network reaches Reverb (127.0.0.1 = the phone).
  // Restore 'sagr.softex-it.online' (and useTLS = true) for staging builds.
  static const String host = '172.20.10.11';

  /// TLS (wss) port. Behind an nginx proxy this is normally 443.
  static const int wssPort = 443;

  /// Plain (ws) port used only when [useTLS] is false (local dev).
  static const int wsPort = 8080;

  /// Use wss in production. Set false only for local plaintext dev.
  // TEMP — false for local plaintext ws on 8080; restore true for staging.
  static const bool useTLS = false;

  /// pusher_channels_flutter requires a non-empty cluster string even though
  /// Reverb ignores it. Any value works.
  static const String cluster = 'mt1';
}
