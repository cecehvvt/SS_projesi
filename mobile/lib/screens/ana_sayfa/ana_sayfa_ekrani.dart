import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../utils/listing_taxonomy.dart';
import '../../widgets/listing_card.dart';
import '../ilan/ilan_detay_ekrani.dart';
import 'filtre_ekrani.dart';
import 'kategori_detay_ekrani.dart';

class AnaSayfaEkrani extends StatefulWidget {
  const AnaSayfaEkrani({super.key});

  @override
  State<AnaSayfaEkrani> createState() => _AnaSayfaEkraniState();
}

class _AnaSayfaEkraniState extends State<AnaSayfaEkrani> {
  final _service = const IlanService();
  final _searchController = TextEditingController();
  late Future<List<AppListing>> _future = _service.getListings();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFB2D3C2),
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _reload(),
                        decoration: InputDecoration(
                          hintText: 'Urun, kategori veya konum ara',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FiltreEkrani(),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _reload(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Kategoriler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  _categoryGrid(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Guncel Ilanlar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Yenile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<AppListing>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return _StateMessage(
                          icon: Icons.wifi_off_outlined,
                          title: 'Ilanlar yuklenemedi',
                          message:
                              'Sunucuya ulasilamadi. Lutfen tekrar deneyin.',
                          onRetry: _reload,
                        );
                      }
                      final listings = snapshot.data ?? const [];
                      if (listings.isEmpty) {
                        return _StateMessage(
                          icon: Icons.inventory_2_outlined,
                          title: 'Henuz ilan yok',
                          message: 'Ilk ilani olusturarak baslayabilirsin.',
                          onRetry: _reload,
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ListingTaxonomy.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final category = ListingTaxonomy.categories[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KategoriDetayEkrani(
                baslik: category.name,
                ikon: Icons.category_outlined,
                anaRenk: const Color(0xFFAFD6C4),
                sekmeRenk: const Color(0xFFE8F5EE),
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  void _reload() {
    setState(() {
      _future = _service.getListings(query: _searchController.text.trim());
    });
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 54),
      child: Column(
        children: [
          Icon(icon, size: 42, color: Colors.grey),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar dene'),
          ),
        ],
      ),
    );
  }
}
