import 'dart:convert';
import 'dart:io';

/// Simple HTTP client for communicating with the backend API.
///
/// Attaches an auth token (if present) as a Bearer token on each request.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.token,
  });

  final String baseUrl;
  String? token;

  final HttpClient _httpClient = HttpClient();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Send a GET request.
  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.getUrl(uri);
    _applyHeaders(request);
    final response = await request.close();
    return _parseResponse(response);
  }

  /// Send a POST request with a JSON body.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.postUrl(uri);
    _applyHeaders(request);
    if (body != null) {
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    return _parseResponse(response);
  }

  /// Send a PUT request with a JSON body.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.openUrl('PUT', uri);
    _applyHeaders(request);
    if (body != null) {
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    return _parseResponse(response);
  }

  /// Send a DELETE request.
  Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = await _httpClient.deleteUrl(uri);
    _applyHeaders(request);
    final response = await request.close();
    return _parseResponse(response);
  }

  void _applyHeaders(HttpClientRequest request) {
    _headers.forEach((key, value) {
      request.headers.set(key, value);
    });
  }

  Future<Map<String, dynamic>> _parseResponse(
    HttpClientResponse response,
  ) async {
    final body = await response.transform(utf8.decoder).join();
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  }
}
