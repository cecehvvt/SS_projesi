import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';
import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  const NotificationService();

  Future<List<AppNotification>> getNotifications() async {
    final response = await http.get(
      Uri.parse(ApiSabitler.bildirimler),
      headers: ApiClient.headers(),
    );
    final data = ApiClient.decode(response, 'Bildirimler alınamadı.') as List;
    return data
        .map(
          (item) => AppNotification.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<List<SwapRequest>> getIncomingSwaps() async {
    final response = await http.get(
      Uri.parse(ApiSabitler.gelenTakasIstekleri),
      headers: ApiClient.headers(),
    );
    final data =
        ApiClient.decode(response, 'Takas istekleri alınamadı.') as List;
    return data
        .map((item) => SwapRequest.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> createSwap(String listingId) async {
    final response = await http.post(
      Uri.parse(ApiSabitler.takasIstegiOlustur(listingId)),
      headers: ApiClient.headers(),
    );
    ApiClient.decode(response, 'Takas isteği gönderilemedi.');
  }

  Future<void> respond(String requestId, bool accepted) async {
    final response = await http.put(
      Uri.parse(ApiSabitler.takasIstegiYanitla(requestId)),
      headers: ApiClient.headers(json: true),
      body: jsonEncode({'status': accepted ? 'accepted' : 'rejected'}),
    );
    ApiClient.decode(response, 'Takas isteği güncellenemedi.');
  }
}
