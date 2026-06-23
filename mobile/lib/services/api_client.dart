import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_sabitler.dart';

class ApiClient {
  ApiClient._();

  static String? accessToken;
  static String? refreshToken;
  static String? kullaniciId;

  static Map<String, String> headers({bool json = false}) {
    return {
      if (json)
        ApiSabitler.headerContentType: ApiSabitler.headerContentTypeJson,
      if (accessToken != null && accessToken!.isNotEmpty)
        ApiSabitler.headerAuthorization: 'Bearer $accessToken',
    };
  }

  static Future<void> setSession(Map<String, dynamic> data) async {
    accessToken = data['accessToken']?.toString();
    refreshToken = data['refreshToken']?.toString();
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      kullaniciId = user['id']?.toString();
    }

    final preferences = await SharedPreferences.getInstance();
    await _saveOrRemove(preferences, ApiSabitler.tokenAnahtari, accessToken);
    await _saveOrRemove(
      preferences,
      ApiSabitler.refreshTokenAnahtari,
      refreshToken,
    );
    await _saveOrRemove(
      preferences,
      ApiSabitler.kullaniciIdAnahtari,
      kullaniciId,
    );
  }

  static Future<bool> restoreSession() async {
    final preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString(ApiSabitler.tokenAnahtari);
    refreshToken = preferences.getString(ApiSabitler.refreshTokenAnahtari);
    kullaniciId = preferences.getString(ApiSabitler.kullaniciIdAnahtari);
    return accessToken != null && accessToken!.isNotEmpty;
  }

  static Future<void> clearSession() async {
    accessToken = null;
    refreshToken = null;
    kullaniciId = null;

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(ApiSabitler.tokenAnahtari);
    await preferences.remove(ApiSabitler.refreshTokenAnahtari);
    await preferences.remove(ApiSabitler.kullaniciIdAnahtari);
  }

  static Future<void> _saveOrRemove(
    SharedPreferences preferences,
    String key,
    String? value,
  ) async {
    if (value == null || value.isEmpty) {
      await preferences.remove(key);
      return;
    }
    await preferences.setString(key, value);
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
