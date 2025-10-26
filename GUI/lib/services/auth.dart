import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../globals/endpoints.dart';
import 'api.dart';

/// AuthService gère le JWT mémoire, login/register via FastAPI,
/// et OAuth via Auth0 Universal Login (optionnel).
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService I = AuthService._();

  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<bool> register(String email, String password) async {
    final res = await ApiClient.I.postJson("/users/register", {
      "email": email,
      "password": password,
    });
    return res["ok"] == true;
  }

  Future<bool> login(String email, String password) async {
    final res = await ApiClient.I.postJson("/users/login", {
      "email": email,
      "password": password,
    });
    final t = res["token"] as String?;
    if (t == null) return false;
    _token = t;
    notifyListeners();
    return true;
  }

  /// OAuth via Auth0 (si AUTH_MODE=auth0 côté API).
  /// Configure `AUTH0_*` dans --dart-define pour pointer ton tenant.
  Future<bool> loginWithAuth0() async {
    if (Endpoints.auth0Domain.isEmpty || Endpoints.auth0ClientId.isEmpty) {
      throw Exception("Auth0 non configuré (dart-define).");
    }

    final url = Uri.https(Endpoints.auth0Domain, "/authorize", {
      "response_type": "token",
      "client_id": Endpoints.auth0ClientId,
      "redirect_uri": Endpoints.auth0RedirectUri,
      "scope": "openid profile email",
      "audience": Endpoints.auth0Audience,
    }).toString();

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: "com.example.gui",
    );

    // callback ex: com.example.gui://callback#access_token=...&token_type=Bearer&...
    final fragment = Uri.parse(result).fragment; // après '#'
    final params = Uri.splitQueryString(fragment);
    final t = params["access_token"];
    if (t == null) return false;
    _token = t; // JWT direct (côté API: valider avec JWKS)
    notifyListeners();
    return true;
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
