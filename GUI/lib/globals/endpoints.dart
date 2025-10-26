import 'dart:io';

/// Base API + WS URLs.
/// - iOS Simulator: localhost
/// - Android Emulator: 10.0.2.2
class Endpoints {
  static String get _host {
    if (Platform.isAndroid) return "10.0.2.2";
    return "localhost";
  }

  static String get api => "http://$_host:8000";
  static String get ws => "ws://$_host:8000/ws";

  // Auth0 (facultatif) – si activé côté FastAPI (AUTH_MODE=auth0)
  static const auth0Domain =
      String.fromEnvironment("AUTH0_DOMAIN", defaultValue: "");
  static const auth0ClientId =
      String.fromEnvironment("AUTH0_CLIENT_ID", defaultValue: "");
  static const auth0Audience =
      String.fromEnvironment("AUTH0_AUDIENCE", defaultValue: "");
  static String get auth0RedirectUri => "com.example.gui://callback";
  static String get auth0AuthorizeUrl => "https://$auth0Domain/authorize";
}
