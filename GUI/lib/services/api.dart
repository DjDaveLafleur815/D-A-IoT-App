import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> postJson(
    String url,
    Map<String, dynamic> body,
  ) async {
    final r = await http.post(
      Uri.parse(url),
      headers: _headers(),
      body: jsonEncode(body),
    );
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('POST $url -> ${r.statusCode} ${r.body}');
  }

  Future<List<dynamic>> getList(String url) async {
    final r = await http.get(Uri.parse(url), headers: _headers());
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as List<dynamic>;
    }
    throw Exception('GET $url -> ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> getJson(String url) async {
    final r = await http.get(Uri.parse(url), headers: _headers());
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('GET $url -> ${r.statusCode} ${r.body}');
  }
}

final api = Api();
