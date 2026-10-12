// const IMAGE_PATH = "https://staging.zahra.cc/";
// const BASEURL = "https://zahra.cc/api";
const HOSTURL = "https://sagr.net/";

/// Full URL of a user's photo. App uploads are stored under public/
/// ("images/..."), while photos set from the admin panel live on the public
/// disk ("employees/...").
String userImageUrl(String path) {
  if (path.startsWith('http')) return path;
  if (path.startsWith('images/') || path.startsWith('files/')) return HOSTURL + path;
  return '${HOSTURL}storage/$path';
}

/// Full URL of an event logo; the API sends a path under public/uploads/images.
String eventLogoUrl(String path) {
  if (path.startsWith('http')) return path;
  return '$APIHOST/uploads/images/${path.startsWith('/') ? path.substring(1) : path}';
}

// Local realtime testing over LAN: both devices (A52 + iPhone) reach the Mac's
// `php artisan serve --host=0.0.0.0` at its Wi-Fi IP on the shared network.
// Swap to one of the commented lines while testing, restore production first.
const BASEURL = "https://sagr.net/api/v1";
// const BASEURL = "https://sagr.softex-it.online/api/v1";
// const BASEURL = "http://172.20.10.11:8099/api/v1";
// const BASEURL = "http://127.0.0.1:8099/api/v1";      // single device via adb reverse

// Root of the API server (BASEURL without /api/v1). Chat media lives at
// $APIHOST/uploads/images/<path> — keep in sync with BASEURL when switching
// environments.
const APIHOST = "https://sagr.net";
// const APIHOST = "https://sagr.softex-it.online";
// const APIHOST = "http://172.20.10.11:8099";