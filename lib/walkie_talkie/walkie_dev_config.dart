/// Development-only overrides for testing the walkie-talkie without the
/// backend pieces that are not deployed yet.
///
/// Two things are missing server-side today:
///   * events come back with `channel: null`, so there is no room name, and
///   * `GET /api/v1/livekit/{channel}/token` returns 404, so there is no token.
///
/// With [enabled] set to true the app talks to a local token server instead
/// (see `scratchpad/livekit_token_server.py`) and falls back to
/// [fallbackChannel] when the event carries no channel of its own.
///
/// MUST stay false on any branch that ships.
class WalkieDevConfig {
  const WalkieDevConfig._();

  /// Master switch. Everything below is ignored while this is false.
  static const bool enabled = true;

  /// Base URL of the local token server, matching BASEURL's shape
  /// (`.../api/v1`). Use the Mac's LAN IP for a physical device;
  /// `http://127.0.0.1:8090/api/v1` also works for the iOS simulator.
  static const String tokenBaseUrl = 'http://127.0.0.1:8090/api/v1';

  /// Room to join when the event has no channel assigned. Every tester must
  /// use the same value to end up in the same room.
  static const String fallbackChannel = 'sagr-dev';
}
