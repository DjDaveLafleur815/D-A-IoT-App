import '../globals/endpoints.dart';
import 'api.dart';

class AuthService {
  String? token;

  Future<bool> register(String email, String password, {String? name}) async {
    final j = await api.postJson(Endpoints.register, {
      "email": email,
      "password": password,
      "display_name": name,
    });
    return j['email'] != null;
  }

  Future<bool> login(String email, String password) async {
    final j = await api.postJson(Endpoints.login, {
      "email": email,
      "password": password,
    });
    token = j['access_token'];
    api.setToken(token);
    return token != null;
  }

  void logout() {
    token = null;
    api.setToken(null);
  }
}

final auth = AuthService();
