import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';

class ApiClient {
  ApiClient._();

  static String? accessToken;
  static String? refreshToken;
  static String? kullaniciId;

  static Map<String, String> headers({bool json = false}) {
    return {
      if (json) ApiSabitler.headerContentType: ApiSabitler.headerContentTypeJson,
      if (accessToken != null && accessToken!.isNotEmpty)
        ApiSabitler.headerAuthorization: 'Bearer $accessToken',
    };
  }

  static void setSession(Map<String, dynamic> data) {
    accessToken = data['accessToken']?.toString();
    refreshToken = data['refreshToken']?.toString();
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      kullaniciId = user['id']?.toString();
    }
  }

  static void clearSession() {
    accessToken = null;
    refreshToken = null;
    kullaniciId = null;
  }

  static dynamic decode(http.Response response, String fallbackMessage) {
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ApiClientException(fallbackMessage);
    }
    if (decoded is! Map<String, dynamic>) {
      throw ApiClientException(fallbackMessage);
    }
    final body = decoded;
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw ApiClientException(body['message']?.toString() ?? fallbackMessage);
    }
    return body['data'];
  }
}

class ApiClientException implements Exception {
  final String message;

  const ApiClientException(this.message);

  @override
  String toString() => message;
}
