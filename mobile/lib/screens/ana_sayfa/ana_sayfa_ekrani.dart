import 'package:flutter/material.dart';

import '../../constants/renkler.dart';
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
  String _selectedType = 'bagis';
  ListingFilters _filters = const ListingFilters();
  late Future<List<AppListing>> _future = _loadListings();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.cream,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Renkler.cream,
              border: Border(bottom: BorderSide(color: Renkler.line)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vesta', style: Renkler.baslik(size: 30)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _reload(),
                        decoration: InputDecoration(
                          hintText: 'Ürün, kategori veya konum ara',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Renkler.paper,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Renkler.line),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Renkler.terracotta,
                        foregroundColor: Renkler.paper,
                      ),
                      onPressed: () async {
                        final filters =
                            await showModalBottomSheet<ListingFilters>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => FiltreEkrani(
                                tur: _selectedType == 'ihtiyac'
                                    ? FiltreTuru.ihtiyac
                                    : FiltreTuru.bagis,
                                initialFilters: _filters,
                              ),
                            );
                        if (filters == null || !mounted) return;
                        setState(() {
                          _filters = filters;
                          _future = _loadListings();
                        });
                      },
                      icon: Icon(
                        _filters.active
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        color: Renkler.paper,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'bagis',
                      icon: Icon(Icons.card_giftcard),
                      label: Text('Bağışlananlar'),
                    ),
                    ButtonSegment(
                      value: 'ihtiyac',
                      icon: Icon(Icons.volunteer_activism_outlined),
                      label: Text('İhtiyaçlar'),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (value) {
                    setState(() {
                      _selectedType = value.first;
                      _filters = const ListingFilters();
                      _future = _loadListings();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Renkler.terracotta
                          : Renkler.paper,
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Renkler.paper
                          : Renkler.ink,
                    ),
                    iconColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Renkler.paper
                          : Renkler.olive,
                    ),
                  ),
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
                  Text('Kategoriler', style: Renkler.baslik(size: 21)),
                  const SizedBox(height: 12),
                  _categoryGrid(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedType == 'bagis'
                            ? 'Bağışlanan Ürünler'
                            : 'İhtiyaç İlanları',
                        style: Renkler.baslik(size: 21),
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
                          title: 'İlanlar yüklenemedi',
                          message:
                              'Sunucuya ulaşılamadı. Lütfen tekrar deneyin.',
                          onRetry: _reload,
                        );
                      }
                      final listings = snapshot.data ?? const [];
                      if (listings.isEmpty) {
                        return _StateMessage(
                          icon: Icons.inventory_2_outlined,
                          title: 'Henüz ilan yok',
                          message: 'İlk ilanı oluşturarak başlayabilirsin.',
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
                baslik: ListingTaxonomy.categoryLabel(category.name),
                ikon: Icons.category_outlined,
                anaRenk: Renkler.oliveLight,
                sekmeRenk: Renkler.cream,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Renkler.paper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Renkler.line),
            ),
            child: Text(
              ListingTaxonomy.categoryLabel(category.name),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Renkler.ink,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  void _reload() {
    setState(() {
      _future = _loadListings();
    });
  }

  Future<List<AppListing>> _loadListings() => _service.getListings(
    listingType: _selectedType,
    category: _filters.category,
    condition: _filters.condition,
    urgent: _selectedType == 'ihtiyac' ? _filters.urgent : null,
    query: _searchController.text.trim(),
  );

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
        const SnackBar(content: Text('Favori işlemi tamamlanamadı.')),
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
          const SizedBox(height: 4),
          Icon(icon, size: 42, color: Renkler.oliveLight),
          const SizedBox(height: 12),
          Text(title, style: Renkler.baslik(size: 19)),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Renkler.inkSoft),
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
