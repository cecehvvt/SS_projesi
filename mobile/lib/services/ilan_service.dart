import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_sabitler.dart';
import '../models/app_listing.dart';

class IlanServiceException implements Exception {
  final String message;

  const IlanServiceException(this.message);

  @override
  String toString() => message;
}

class IlanService {
  const IlanService();

  Future<List<AppListing>> getListings({
    String? listingType,
    String? category,
    String? query,
  }) async {
    final uri = Uri.parse(ApiSabitler.ilanlar).replace(
      queryParameters: {
        if (listingType != null && listingType.isNotEmpty) 'tur': listingType,
        if (category != null && category.isNotEmpty) 'kategori': category,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );

    final data = await _get(uri);
    final list = data as List<dynamic>;
    return list
        .map((item) => AppListing.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AppListing> getListing(String id) async {
    final data = await _get(Uri.parse(ApiSabitler.ilanDetay(id)));
    return AppListing.fromJson(data as Map<String, dynamic>);
  }

  Future<AppListing> createListing(AppListing listing) async {
    final response = await http.post(
      Uri.parse(ApiSabitler.ilanOlustur),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(listing.toJson()),
    );
    final data = _decode(response);
    return AppListing.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteListing(String id) async {
    final response = await http.delete(Uri.parse(ApiSabitler.ilanSil(id)));
    _decode(response);
  }

  Future<AppListing> addFavorite(String id) async {
    final response = await http.post(Uri.parse(ApiSabitler.favoriEkle(id)));
    final data = _decode(response);
    return AppListing.fromJson(data as Map<String, dynamic>);
  }

  Future<void> removeFavorite(String id) async {
    final response = await http.delete(Uri.parse(ApiSabitler.favoriKaldir(id)));
    _decode(response);
  }

  Future<List<AppListing>> getFavorites() async {
    final data = await _get(Uri.parse(ApiSabitler.favoriler));
    final rows = data as List<dynamic>;
    return rows.map((row) {
      final map = row as Map<String, dynamic>;
      final listing = map['ilan'] ?? map['listing'];
      return AppListing.fromJson(listing as Map<String, dynamic>);
    }).toList();
  }

  Future<dynamic> _get(Uri uri) async {
    try {
      final response = await http.get(uri);
      return _decode(response);
    } catch (_) {
      throw const IlanServiceException(
        'Sunucuya ulasilamadi. Lutfen uygulamayi yeniden deneyin.',
      );
    }
  }

  dynamic _decode(http.Response response) {
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw IlanServiceException(
        body['message']?.toString() ?? 'Islem tamamlanamadi.',
      );
    }
    return body['data'];
  }
}
