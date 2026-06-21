import 'package:flutter/material.dart';

import '../../models/app_listing.dart';
import '../../models/kullanici_model.dart';
import '../../services/auth_service.dart';
import '../../services/ilan_service.dart';
import '../../services/kullanici_service.dart';
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
  final _ilanService = const IlanService();
  final _kullaniciService = const KullaniciService();
  late Future<_ProfileData> _future = _loadProfile();

  Future<_ProfileData> _loadProfile() async {
    final results = await Future.wait([
      _kullaniciService.me(),
      _ilanService.getMine(),
    ]);
    return _ProfileData(
      user: results[0] as KullaniciModel,
      listings: results[1] as List<AppListing>,
    );
  }

  void _reload() {
    setState(() {
      _future = _loadProfile();
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
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilDuzenleEkrani(),
                ),
              );
              if (changed == true) _reload();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<_ProfileData>(
          future: _future,
          builder: (context, snapshot) {
            final user = snapshot.data?.user;
            final listings = snapshot.data?.listings ?? const <AppListing>[];
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _ProfileHeader(user: user, onChanged: _reload),
                const SizedBox(height: 12),
                _ProfileInfo(user: user),
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
                  onLogoutTap: () async {
                    await const AuthService().logout();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final KullaniciModel? user;

  const _ProfileInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    final about = user?.hakkinda?.trim();
    final username = user?.kullaniciAdi?.trim();
    final phone = user?.telefonNumarasi?.trim();
    final email = user?.eposta?.trim();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil Bilgileri',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(
            about == null || about.isEmpty
                ? 'Hakkinda bilgisi eklenmedi.'
                : about,
            style: const TextStyle(color: Colors.black87, height: 1.35),
          ),
          const SizedBox(height: 12),
          if (username != null && username.isNotEmpty)
            _InfoLine(icon: Icons.alternate_email, text: username),
          if (phone != null && phone.isNotEmpty)
            _InfoLine(icon: Icons.phone_outlined, text: phone),
          if (email != null && email.isNotEmpty)
            _InfoLine(icon: Icons.mail_outline, text: email),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

class _ProfileData {
  final KullaniciModel user;
  final List<AppListing> listings;

  const _ProfileData({required this.user, required this.listings});
}

class _ProfileHeader extends StatelessWidget {
  final KullaniciModel? user;
  final VoidCallback onChanged;

  const _ProfileHeader({required this.user, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final displayName = user == null || user!.tamAd.trim().isEmpty
        ? 'Vesta Kullanici'
        : user!.tamAd;
    final location = user?.konum?.isNotEmpty == true
        ? user!.konum!
        : user?.adres.isNotEmpty == true
        ? user!.adres
        : 'Konum eklenmedi';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFE8F5EE),
            backgroundImage:
                user?.profilFotoUrl?.isNotEmpty == true
                    ? NetworkImage(user!.profilFotoUrl!)
                    : null,
            child: user?.profilFotoUrl?.isNotEmpty == true
                ? null
                : const Icon(
                    Icons.person_outline,
                    size: 36,
                    color: Color(0xFF2E7D32),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilDuzenleEkrani(),
                ),
              );
              if (changed == true) onChanged();
            },
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
  final VoidCallback onLogoutTap;

  const _ProfileMenu({
    required this.onMessagesTap,
    required this.onLogoutTap,
  });

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
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cikis Yap',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}
