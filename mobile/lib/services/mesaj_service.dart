import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';
import '../models/mesaj_model.dart';
import 'api_client.dart';

class MesajServiceException implements Exception {
  final String message;

  const MesajServiceException(this.message);

  @override
  String toString() => message;
}

class MesajService {
  const MesajService();

  Future<List<SohbetOzeti>> getSohbetler() async {
    final response = await http.get(
      Uri.parse(ApiSabitler.sohbetler),
      headers: ApiClient.headers(),
    );
    final body = _decode(response);
    final rows = body['data'] as List<dynamic>? ?? const [];
    return rows
        .map((row) => SohbetOzeti.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<MesajModel>> getMesajlar({
    required String karsiKullaniciId,
    String? ilanId,
  }) async {
    final uri = Uri.parse(
      ApiSabitler.sohbetMesajlari(karsiKullaniciId),
    ).replace(queryParameters: ilanId == null ? null : {'ilanId': ilanId});
    final response = await http.get(uri, headers: ApiClient.headers());
    final body = _decode(response);
    final rows = body['data'] as List<dynamic>? ?? const [];
    return rows
        .map((row) => MesajModel.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<MesajModel> mesajGonder({
    required String aliciId,
    required String icerik,
    String? ilanId,
  }) async {
    final response = await http.post(
      Uri.parse(ApiSabitler.mesajGonder),
      headers: ApiClient.headers(json: true),
      body: jsonEncode({
        'aliciId': aliciId,
        'ilanId': ilanId,
        'icerik': icerik,
      }),
    );
    final body = _decode(response);
    return MesajModel.fromJson(Map<String, dynamic>.from(body['data']));
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final data = ApiClient.decode(response, 'Mesaj işlemi tamamlanamadı.');
      return {'data': data};
    } on ApiClientException catch (exception) {
      throw MesajServiceException(exception.message);
    }
  }
}
