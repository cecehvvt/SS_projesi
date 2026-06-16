import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../widgets/listing_card.dart';
import '../ilan/ilan_detay_ekrani.dart';

class FavorilerEkrani extends StatefulWidget {
  final bool altMenuGoster;

  const FavorilerEkrani({super.key, this.altMenuGoster = true});

  @override
  State<FavorilerEkrani> createState() => _FavorilerEkraniState();
}

class _FavorilerEkraniState extends State<FavorilerEkrani> {
  final _service = const IlanService();
  late Future<List<AppListing>> _future = _service.getFavorites();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Favorilerim'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<AppListing>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final listings = snapshot.data ?? const [];
            if (listings.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Henuz favori ilanin yok',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Begendigin ilanlari favorilere ekleyerek burada takip edebilirsin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final listing = listings[index];
                return ListingCard(
                  listing: listing,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IlanDetayEkrani(listingId: listing.id),
                    ),
                  ),
                  onFavoriteTap: () async {
                    await _service.removeFavorite(listing.id);
                    _reload();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _reload() {
    setState(() {
      _future = _service.getFavorites();
    });
  }
}
