import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../globals/endpoints.dart';
import 'auth.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? query,
  }) async {
    final uri =
        Uri.parse("${Endpoints.api}$path").replace(queryParameters: query);
    final token = AuthService.I.token;
    final baseHeaders = <String, String>{"Content-Type": "application/json"};
    if (token != null) baseHeaders["Authorization"] = "Bearer $token";

    final h = {...baseHeaders, if (headers != null) ...headers};
    http.Response res;
    switch (method) {
      case "GET":
        res = await http.get(uri, headers: h);
        break;
      case "POST":
        res = await http.post(uri, headers: h, body: body);
        break;
      default:
        throw UnsupportedError("HTTP $method not implemented");
    }

    if (kDebugMode) {
      debugPrint("[HTTP] $method $uri -> ${res.statusCode}");
    }
    return res;
  }

  Future<Map<String, dynamic>> postJson(
      String path, Map<String, dynamic> data) async {
    final res = await _request("POST", path, body: jsonEncode(data));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return (res.body.isEmpty)
          ? {}
          : jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception("POST $path failed: ${res.statusCode} ${res.body}");
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await _request("GET", path);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = (res.body.isEmpty) ? [] : jsonDecode(res.body);
      if (data is List) return data;
      if (data is Map && data["items"] is List) return data["items"];
      return [];
    }
    throw Exception("GET $path failed: ${res.statusCode} ${res.body}");
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await _request("GET", path);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return (res.body.isEmpty)
          ? {}
          : jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception("GET $path failed: ${res.statusCode} ${res.body}");
  }
}
