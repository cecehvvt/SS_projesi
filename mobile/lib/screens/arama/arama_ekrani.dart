import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../models/ilan_model.dart';
import '../../services/ilan_service.dart';
import '../../widgets/listing_card.dart';
import '../ilan/ilan_detay_ekrani.dart';

class AramaEkrani extends StatefulWidget {
  final IlanTuru baslangicTuru;

  const AramaEkrani({super.key, required this.baslangicTuru});

  @override
  State<AramaEkrani> createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  final _service = const IlanService();
  final _controller = TextEditingController();
  late IlanTuru _selectedType = widget.baslangicTuru;
  late Future<List<AppListing>> _future = _search();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<AppListing>> _search() {
    return _service.getListings(
      listingType: _selectedType.name,
      query: _controller.text.trim(),
    );
  }

  void _reload() {
    setState(() {
      _future = _search();
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
        title: const Text('Arama'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _reload(),
              decoration: InputDecoration(
                hintText: 'Ilan ara',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _reload,
                  icon: const Icon(Icons.arrow_forward),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<IlanTuru>(
              segments: const [
                ButtonSegment(
                  value: IlanTuru.bagis,
                  icon: Icon(Icons.card_giftcard),
                  label: Text('Bagis'),
                ),
                ButtonSegment(
                  value: IlanTuru.ihtiyac,
                  icon: Icon(Icons.volunteer_activism_outlined),
                  label: Text('Ihtiyac'),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (value) {
                setState(() {
                  _selectedType = value.first;
                  _future = _search();
                });
              },
            ),
          ),
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
                      icon: Icons.error_outline,
                      title: 'Arama yapilamadi',
                      message: 'Lutfen tekrar dene.',
                      onRetry: _reload,
                    );
                  }
                  final listings = snapshot.data ?? const [];
                  if (listings.isEmpty) {
                    return _StateMessage(
                      icon: Icons.search_off,
                      title: 'Sonuc bulunamadi',
                      message: 'Bu arama icin henuz ilan yok.',
                      onRetry: _reload,
                    );
                  }
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
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
