import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';
import '../models/kullanici_model.dart';
import 'api_client.dart';

class KullaniciServiceException implements Exception {
  final String message;

  const KullaniciServiceException(this.message);

  @override
  String toString() => message;
}

class KullaniciService {
  const KullaniciService();

  Future<KullaniciModel> me() async {
    final response = await http.get(
      Uri.parse(ApiSabitler.kullaniciBilgi),
      headers: ApiClient.headers(),
    );
    final data = _decode(response);
    return KullaniciModel.fromJson(data as Map<String, dynamic>);
  }

  Future<KullaniciModel> updateProfile(Map<String, dynamic> payload) async {
    final response = await http.put(
      Uri.parse(ApiSabitler.kullaniciBilgiGuncelle),
      headers: ApiClient.headers(json: true),
      body: jsonEncode(payload),
    );
    final data = _decode(response);
    return KullaniciModel.fromJson(data as Map<String, dynamic>);
  }

  Future<KullaniciModel> updatePrivacy(GizlilikAyarlari privacy) async {
    final response = await http.put(
      Uri.parse(ApiSabitler.gizlilikGuncelle),
      headers: ApiClient.headers(json: true),
      body: jsonEncode(privacy.toJson()),
    );
    final data = _decode(response);
    return KullaniciModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    final response = await http.delete(
      Uri.parse(ApiSabitler.hesapSil),
      headers: ApiClient.headers(),
    );
    _decode(response);
    ApiClient.clearSession();
  }

  dynamic _decode(http.Response response) {
    try {
      return ApiClient.decode(response, 'Kullanıcı bilgisi alınamadı.');
    } on ApiClientException catch (exception) {
      throw KullaniciServiceException(exception.message);
    }
  }
}
