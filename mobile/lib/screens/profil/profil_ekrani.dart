import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../services/ilan_service.dart';
import '../../utils/listing_taxonomy.dart';
import '../../widgets/listing_image.dart';
import '../ilan/ilan_detay_ekrani.dart';
import 'profil_duzenle_ekrani.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final _service = const IlanService();
  late Future<List<AppListing>> _future = _loadMine();

  Future<List<AppListing>> _loadMine() async {
    final listings = await _service.getListings();
    return listings.where((listing) => listing.ownerId == 'user-1').toList();
  }

  void _reload() {
    setState(() {
      _future = _loadMine();
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
          'Profilim',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Profili duzenle',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilDuzenleEkrani(),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<AppListing>>(
          future: _future,
          builder: (context, snapshot) {
            final listings = snapshot.data ?? const <AppListing>[];
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const _ProfileHeader(),
                const SizedBox(height: 20),
                _Stats(listings: listings),
                const SizedBox(height: 24),
                const Text(
                  'Ilanlarim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.hasError)
                  _StateCard(
                    icon: Icons.error_outline,
                    text: 'Ilanlarin yuklenemedi.',
                    actionLabel: 'Tekrar dene',
                    onAction: _reload,
                  )
                else if (listings.isEmpty)
                  _StateCard(
                    icon: Icons.inventory_2_outlined,
                    text: 'Henuz olusturdugun ilan yok.',
                    actionLabel: 'Ilan olustur',
                    onAction: () =>
                        Navigator.pushNamed(context, '/ilan_olustur'),
                  )
                else
                  ...listings.map(
                    (listing) => _MiniListingCard(
                      listing: listing,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              IlanDetayEkrani(listingId: listing.id),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _ProfileMenu(
                  onMessagesTap: () =>
                      Navigator.pushNamed(context, '/mesajlar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFE8F5EE),
            child: Icon(
              Icons.person_outline,
              size: 36,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ayse Demir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Uskudar, Istanbul',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilDuzenleEkrani(),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Duzenle'),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final List<AppListing> listings;

  const _Stats({required this.listings});

  @override
  Widget build(BuildContext context) {
    final bagis = listings
        .where((listing) => listing.listingType == 'bagis')
        .length;
    final ihtiyac = listings
        .where((listing) => listing.listingType == 'ihtiyac')
        .length;
    final takas = listings
        .where((listing) => listing.listingType == 'takas')
        .length;
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Bagis',
            count: bagis,
            icon: Icons.card_giftcard,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            label: 'Ihtiyac',
            count: ihtiyac,
            icon: Icons.volunteer_activism_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            label: 'Takas',
            count: takas,
            icon: Icons.swap_horiz,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 6),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _MiniListingCard extends StatelessWidget {
  final AppListing listing;
  final VoidCallback onTap;

  const _MiniListingCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(10),
        leading: ListingImage(
          source: listing.firstImage,
          width: 52,
          height: 52,
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          listing.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${ListingTaxonomy.typeLabel(listing.listingType)} - ${listing.category}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  const _StateCard({
    required this.icon,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: Colors.grey),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final VoidCallback onMessagesTap;

  const _ProfileMenu({required this.onMessagesTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('Mesajlarim'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onMessagesTap,
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Yardim & Destek'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
