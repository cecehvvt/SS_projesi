import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../widgets/listing_card.dart';
import '../ilan/ilan_detay_ekrani.dart';

class KategoriDetayEkrani extends StatefulWidget {
  final String baslik;
  final IconData ikon;
  final Color anaRenk;
  final Color sekmeRenk;

  const KategoriDetayEkrani({
    super.key,
    required this.baslik,
    required this.ikon,
    required this.anaRenk,
    required this.sekmeRenk,
  });

  @override
  State<KategoriDetayEkrani> createState() => _KategoriDetayEkraniState();
}

class _KategoriDetayEkraniState extends State<KategoriDetayEkrani> {
  final _service = const IlanService();
  late Future<List<AppListing>> _future = _service.getListings(
    category: widget.baslik,
  );

  void _reload() {
    setState(() {
      _future = _service.getListings(category: widget.baslik);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: Text(widget.baslik),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<AppListing>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _StateMessage(
                icon: Icons.error_outline,
                title: 'İlanlar yüklenemedi',
                message: 'Lütfen tekrar dene.',
                onRetry: _reload,
              );
            }
            final listings = snapshot.data ?? const [];
            if (listings.isEmpty) {
              return _StateMessage(
                icon: widget.ikon,
                title: 'Bu kategoride ilan yok',
                message: 'Yeni ilanlar eklendiğinde burada görünecek.',
                onRetry: _reload,
              );
            }
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(icon, size: 52, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),
        Center(
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Yenile'),
          ),
        ),
      ],
    );
  }
}
