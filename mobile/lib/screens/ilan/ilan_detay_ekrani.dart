import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../utils/listing_taxonomy.dart';
import '../../widgets/listing_image.dart';
import '../mesajlar/sohbet_ekrani.dart';

class IlanDetayEkrani extends StatefulWidget {
  final String? listingId;

  const IlanDetayEkrani({super.key, this.listingId});

  @override
  State<IlanDetayEkrani> createState() => _IlanDetayEkraniState();
}

class _IlanDetayEkraniState extends State<IlanDetayEkrani> {
  final _service = const IlanService();
  late final Future<AppListing>? _future = widget.listingId == null
      ? null
      : _service.getListing(widget.listingId!);

  @override
  Widget build(BuildContext context) {
    if (_future == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Goruntulenecek ilan secilmedi.')),
      );
    }
    return FutureBuilder<AppListing>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Ilan detayi yuklenemedi.')),
          );
        }
        return _DetailContent(
          listing: snapshot.data!,
          onDelete: _deleteListing,
        );
      },
    );
  }

  Future<void> _deleteListing(AppListing listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ilani sil'),
        content: const Text('Bu ilani silmek istediginize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _service.deleteListing(listing.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ilan silindi.')));
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ilan silinemedi. Lutfen tekrar deneyin.'),
        ),
      );
    }
  }
}

class _DetailContent extends StatefulWidget {
  final AppListing listing;
  final ValueChanged<AppListing> onDelete;

  const _DetailContent({required this.listing, required this.onDelete});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  final _service = const IlanService();
  int _imageIndex = 0;
  bool _requesting = false;

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final isOwner = listing.ownerId == 'user-1';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ilan Detayi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 320,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: listing.imageUrls.isEmpty
                      ? 1
                      : listing.imageUrls.length,
                  onPageChanged: (index) => setState(() => _imageIndex = index),
                  itemBuilder: (context, index) => ListingImage(
                    source: listing.imageUrls.isEmpty
                        ? ''
                        : listing.imageUrls[index],
                    width: double.infinity,
                    height: 320,
                  ),
                ),
                if (listing.imageUrls.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_imageIndex + 1}/${listing.imageUrls.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(text: ListingTaxonomy.typeLabel(listing.listingType)),
                    _Chip(text: '${listing.category} / ${listing.subCategory}'),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  listing.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      listing.location,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _InfoRow(label: 'Urun durumu', value: listing.condition),
                _InfoRow(
                  label: 'Teslim yontemi',
                  value: listing.deliveryMethod,
                ),
                _InfoRow(label: 'Iletisim', value: listing.contactPreference),
                if (listing.listingType == 'takas' &&
                    listing.desiredSwapItem != null)
                  _InfoRow(
                    label: 'Istenen takas urunu',
                    value: listing.desiredSwapItem!,
                  ),
                const SizedBox(height: 18),
                const Text(
                  'Aciklama',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(listing.description, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 18),
                _OwnerCard(listing: listing),
                const SizedBox(height: 24),
                if (isOwner)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Duzenleme ekrani sonraki adimda baglanacak.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Duzenle'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => widget.onDelete(listing),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Sil'),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _requesting
                              ? null
                              : () => _requestListing(listing),
                          icon: _requesting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.shopping_bag_outlined),
                          label: Text(
                            _requesting
                                ? 'Ekleniyor...'
                                : listing.listingType == 'ihtiyac'
                                ? 'Yardim Et'
                                : 'Talep Et',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SohbetEkrani(
                                karsiKullaniciId: listing.ownerId,
                                karsiKullaniciAd: listing.ownerName,
                                ilanId: listing.id,
                                ilanBaslik: listing.title,
                                ilanKonum: listing.location,
                                ilanFotoUrl: listing.firstImage,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Mesaj'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestListing(AppListing listing) async {
    setState(() => _requesting = true);
    try {
      await _service.requestListing(listing.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Talep Sepetim bolumune eklendi.')),
      );
    } on IlanServiceException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Talep olusturulamadi.')));
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: const Color(0xFFE8F5EE),
      labelStyle: const TextStyle(
        color: Color(0xFF2E7D32),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  final AppListing listing;

  const _OwnerCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person_outline)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.ownerName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Iletisim uygulama ici mesajlasma ile yurutulur.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
