import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';
import 'api_client.dart';

class AuthService {
  const AuthService();

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiSabitler.girisYap),
      headers: ApiClient.headers(json: true),
      body: jsonEncode({'epostaVeyaTelefon': identifier, 'password': password}),
    );
    final data = ApiClient.decode(response, 'Giriş yapılamadı.');
    await ApiClient.setSession(Map<String, dynamic>.from(data as Map));
  }

  Future<void> register({
    required String ad,
    required String soyad,
    required String adres,
    required String epostaVeyaTelefon,
    required String password,
    String? kullaniciAdi,
    String? hakkinda,
    String? konum,
    String? telefonNumarasi,
  }) async {
    final response = await http.post(
      Uri.parse(ApiSabitler.kayitOl),
      headers: ApiClient.headers(json: true),
      body: jsonEncode({
        'ad': ad,
        'soyad': soyad,
        'adres': adres,
        'epostaVeyaTelefon': epostaVeyaTelefon,
        'password': password,
        'kullaniciAdi': kullaniciAdi,
        'hakkinda': hakkinda,
        'konum': konum,
        'telefonNumarasi': telefonNumarasi,
      }),
    );
    final data = ApiClient.decode(response, 'Kayıt tamamlanamadı.');
    await ApiClient.setSession(Map<String, dynamic>.from(data as Map));
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse(ApiSabitler.cikisYap),
        headers: ApiClient.headers(),
      );
    } finally {
      await ApiClient.clearSession();
    }
  }
}
