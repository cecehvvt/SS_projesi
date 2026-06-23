import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../widgets/alt_menu.dart';
import '../../widgets/listing_image.dart';
import '../ilan/ilan_detay_ekrani.dart';

class SepetimEkrani extends StatefulWidget {
  final bool altMenuGoster;

  const SepetimEkrani({super.key, this.altMenuGoster = true});

  @override
  State<SepetimEkrani> createState() => _SepetimEkraniState();
}

class _SepetimEkraniState extends State<SepetimEkrani> {
  final _service = const IlanService();
  late Future<List<AppListing>> _future = _service.getRequestedListings();

  void _reload() {
    setState(() {
      _future = _service.getRequestedListings();
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
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
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
                title: 'Talepler yüklenemedi',
                message: 'Sunucuya ulaşılamadı. Lütfen tekrar deneyin.',
                actionLabel: 'Tekrar dene',
                onAction: _reload,
              );
            }
            final listings = snapshot.data ?? const [];
            if (listings.isEmpty) {
              return _StateMessage(
                icon: Icons.shopping_bag_outlined,
                title: 'Sepetin bos',
                message:
                    'Talep ettiğin veya yardım etmek istediğin ilanlar burada görünecek.',
                actionLabel: 'İlanlara bak',
                onAction: () => Navigator.pushNamed(context, '/ana_sayfa'),
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final listing = listings[index];
                return _RequestTile(
                  listing: listing,
                  onOpen: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IlanDetayEkrani(listingId: listing.id),
                    ),
                  ),
                  onCancel: () => _cancel(listing),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: widget.altMenuGoster
          ? const VestaAltMenu(seciliIndex: 4)
          : null,
    );
  }

  Future<void> _cancel(AppListing listing) async {
    try {
      await _service.cancelRequest(listing.id);
      _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Talep iptal edildi.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Talep iptal edilemedi.')));
    }
  }
}

class _RequestTile extends StatelessWidget {
  final AppListing listing;
  final VoidCallback onOpen;
  final VoidCallback onCancel;

  const _RequestTile({
    required this.listing,
    required this.onOpen,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ListingImage(
              source: listing.firstImage,
              width: 74,
              height: 74,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${listing.ownerName} - ${listing.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: onOpen,
                        child: const Text('Detay'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('İptal et'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 110),
        Icon(icon, size: 56, color: Colors.grey),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        Center(
          child: FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.search),
            label: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}
