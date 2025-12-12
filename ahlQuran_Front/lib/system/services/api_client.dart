import 'dart:convert';
import 'dart:developer' as code;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class NoNetworkException implements Exception {
  final String message;
  NoNetworkException([this.message = 'No network connection']);
  @override
  String toString() => message;
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No actual internet access']);
  @override
  String toString() => message;
}

class ApiService {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json'
  };

  static Uri _buildUri(String endpoint) => Uri.parse(endpoint);

  static void _log(String message) {
    code.log('[ApiService] $message');
  }

  static Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      throw NoNetworkException();
    }
  }

  static Future<T> _withConnection<T>(Future<T> Function() operation) async {
    await _checkConnectivity();
    return await operation();
  }

  static Future<T> fetchObject<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      _withConnection(() async {
        _log('GET $endpoint');
        final response =
            await http.get(_buildUri(endpoint), headers: defaultHeaders);

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return fromJson(data);
        } else {
          throw Exception('GET $endpoint failed: ${response.statusCode}');
        }
      });

  static Future<List<T>> fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,  // fromJson build in function to converts each item form the json after parsing it
  ) =>
  // check connection first
      _withConnection(() async {
        // log request if debug mode
        _log('GET $endpoint');
        final response =
        // parse it to json using Uri build in class
            await http.get(_buildUri(endpoint), headers: defaultHeaders);

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is List) {
            return data.map((item) => fromJson(item)).toList();
          } else if (data['data'] is List) {
            return (data['data'] as List)
                .map((item) => fromJson(item))
                .toList();
          } else {
            throw Exception('Expected a list but got: $data');
          }
        } else {
          throw Exception('GET $endpoint failed: ${response.statusCode}');
        }
      });

  static Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      _withConnection(() async {
        _log('POST $endpoint\nBody: $body');
        final response = await http.post(
          _buildUri(endpoint),
          headers: defaultHeaders,
          body: json.encode(body),
        );

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = json.decode(response.body);
          return fromJson(data);
        } else {
          throw Exception('POST $endpoint failed: ${response.statusCode}');
        }
      });

  static Future<T> put<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      _withConnection(() async {
        _log('PUT $endpoint\nBody: $body');
        final response = await http.put(
          _buildUri(endpoint),
          headers: defaultHeaders,
          body: json.encode(body),
        );

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return fromJson(data);
        } else {
          throw Exception(
              'PUT $endpoint failed: ${response.statusCode} - ${response.body}');
        }
      });

  static Future<T> patch<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      _withConnection(() async {
        _log('PATCH $endpoint\nBody: $body');
        final response = await http.patch(
          _buildUri(endpoint),
          headers: defaultHeaders,
          body: json.encode(body),
        );

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return fromJson(data);
        } else {
          throw Exception('PATCH $endpoint failed: ${response.statusCode}');
        }
      });

  static Future<void> delete(String endpoint) => _withConnection(() async {
        _log('DELETE $endpoint');
        final response =
            await http.delete(_buildUri(endpoint), headers: defaultHeaders);

        _log('Response (${response.statusCode}): ${response.body}');
        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('DELETE $endpoint failed: ${response.statusCode}');
        }
      });
}
