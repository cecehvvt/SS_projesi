import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../widgets/listing_card.dart';
import '../ilan/ilan_detay_ekrani.dart';
import 'filtre_ekrani.dart';

class BagislananlarEkrani extends StatefulWidget {
  const BagislananlarEkrani({super.key});

  @override
  State<BagislananlarEkrani> createState() => _BagislananlarEkraniState();
}

class _BagislananlarEkraniState extends State<BagislananlarEkrani> {
  static const _currentUserId = 'user-1';

  final _service = const IlanService();
  final _searchController = TextEditingController();
  bool _mineOnly = false;
  late Future<List<AppListing>> _future = _load();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<AppListing>> _load() async {
    final listings = await _service.getListings(
      listingType: 'bagis',
      query: _searchController.text.trim(),
    );
    if (!_mineOnly) return listings;
    return listings
        .where((listing) => listing.ownerId == _currentUserId)
        .toList();
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD6C4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bagislananlar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _reload(),
                    decoration: InputDecoration(
                      hintText: 'Urun, baslik, kategori veya konum ara',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FiltreEkrani.bagis(),
                    );
                  },
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: const Text('Filtrele'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.grid_view),
                  label: Text('Tumu'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.favorite_border),
                  label: Text('Bagisladiklarim'),
                ),
              ],
              selected: {_mineOnly},
              onSelectionChanged: (selection) {
                setState(() {
                  _mineOnly = selection.first;
                  _future = _load();
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _reload(),
              child: FutureBuilder<List<AppListing>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _StateMessage(
                      icon: Icons.wifi_off_outlined,
                      title: 'Bagis ilanlari yuklenemedi',
                      message: 'Sunucuya ulasilamadi. Tekrar deneyin.',
                      onRetry: _reload,
                    );
                  }
                  final listings = snapshot.data ?? const [];
                  if (listings.isEmpty) {
                    return _StateMessage(
                      icon: Icons.inventory_2_outlined,
                      title: _mineOnly
                          ? 'Henuz bagis ilanin yok'
                          : 'Henuz bagis ilani yok',
                      message: 'Yeni bagis ilanlari burada gorunecek.',
                      onRetry: _reload,
                    );
                  }
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: listings.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            builder: (_) =>
                                IlanDetayEkrani(listingId: listing.id),
                          ),
                        ),
                        onFavoriteTap: () => _toggleFavorite(listing),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(AppListing listing) async {
    try {
      if (listing.favorite) {
        await _service.removeFavorite(listing.id);
      } else {
        await _service.addFavorite(listing.id);
      }
      _reload();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favori islemi tamamlanamadi.')),
      );
    }
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
        const SizedBox(height: 120),
        Icon(icon, size: 52, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
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
