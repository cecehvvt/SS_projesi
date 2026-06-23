import 'package:flutter/material.dart';

import '../../constants/renkler.dart';
import '../../models/app_listing.dart';
import '../../models/mesaj_model.dart';
import '../../services/ilan_service.dart';
import '../../services/mesaj_service.dart';
import '../../widgets/alt_menu.dart';
import '../../widgets/listing_image.dart';
import 'sohbet_ekrani.dart';
import 'notifications_panel.dart';

class MesajlarEkrani extends StatefulWidget {
  final bool altMenuGoster;

  const MesajlarEkrani({super.key, this.altMenuGoster = true});

  @override
  State<MesajlarEkrani> createState() => _MesajlarEkraniState();
}

class _MesajlarEkraniState extends State<MesajlarEkrani> {
  final _mesajService = const MesajService();
  final _ilanService = const IlanService();
  late Future<List<SohbetOzeti>> _future = _mesajService.getSohbetler();

  void _reload() {
    setState(() {
      _future = _mesajService.getSohbetler();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Renkler.cream,
        appBar: AppBar(
          title: const Text('Mesajlar'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'İlandan sohbet başlat',
              icon: const Icon(Icons.add_comment_outlined),
              onPressed: _showListingPicker,
            ),
          ],
          bottom: const TabBar(
            labelColor: Renkler.terracottaDark,
            unselectedLabelColor: Renkler.inkSoft,
            indicatorColor: Renkler.terracotta,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Mesajlar'),
              Tab(text: 'Bildirimler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: () async => _reload(),
              child: FutureBuilder<List<SohbetOzeti>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _StateMessage(
                      icon: Icons.error_outline,
                      title: 'Sohbetler yüklenemedi',
                      message: 'Lütfen biraz sonra tekrar dene.',
                      actionLabel: 'Tekrar dene',
                      onAction: _reload,
                    );
                  }
                  final sohbetler = snapshot.data ?? const [];
                  if (sohbetler.isEmpty) {
                    return _StateMessage(
                      icon: Icons.chat_bubble_outline,
                      title: 'Henüz sohbet yok',
                      message:
                          'Mesaj atmak istediğin ilanı seçerek yeni bir sohbet başlatabilirsin.',
                      actionLabel: 'İlan seç',
                      onAction: _showListingPicker,
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sohbetler.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final sohbet = sohbetler[index];
                      return _ConversationTile(
                        sohbet: sohbet,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SohbetEkrani.fromSummary(sohbet),
                            ),
                          );
                          if (mounted) _reload();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const NotificationsPanel(),
          ],
        ),
        bottomNavigationBar: widget.altMenuGoster
            ? const VestaAltMenu(seciliIndex: 1)
            : null,
      ),
    );
  }

  Future<void> _showListingPicker() async {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return FutureBuilder<List<AppListing>>(
          future: _ilanService.getListings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return const _PickerMessage(
                icon: Icons.error_outline,
                text: 'İlanlar yüklenemedi.',
              );
            }
            final listings = (snapshot.data ?? const [])
                .where((listing) => listing.ownerId != 'user-1')
                .toList();
            if (listings.isEmpty) {
              return const _PickerMessage(
                icon: Icons.inventory_2_outlined,
                text: 'Mesaj atabileceğin aktif ilan yok.',
              );
            }
            return SafeArea(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: listings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    leading: ListingImage(
                      source: listing.firstImage,
                      width: 56,
                      height: 56,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      '${listing.ownerName} - ${listing.location}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(context);
                      _openChatForListing(listing);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openChatForListing(AppListing listing) async {
    await Navigator.push(
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
    );
    if (mounted) _reload();
  }
}

class _ConversationTile extends StatelessWidget {
  final SohbetOzeti sohbet;
  final VoidCallback onTap;

  const _ConversationTile({required this.sohbet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: CircleAvatar(
        backgroundColor: Renkler.oliveLight,
        child: Text(
          sohbet.karsiKullaniciAd.isEmpty
              ? 'V'
              : sohbet.karsiKullaniciAd.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Renkler.paper,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              sohbet.karsiKullaniciAd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            sohbet.formatliZaman,
            style: const TextStyle(fontSize: 12, color: Renkler.inkSoft),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            sohbet.sonMesajIcerik,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: sohbet.okunmamisVar ? Renkler.ink : Renkler.inkSoft,
              fontWeight: sohbet.okunmamisVar
                  ? FontWeight.w700
                  : FontWeight.normal,
            ),
          ),
          if (sohbet.ilanBaslik != null) ...[
            const SizedBox(height: 4),
            Text(
              sohbet.ilanBaslik!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Renkler.olive),
            ),
          ],
        ],
      ),
      trailing: sohbet.ilanFotoUrl == null
          ? null
          : ListingImage(
              source: sohbet.ilanFotoUrl!,
              width: 46,
              height: 46,
              borderRadius: BorderRadius.circular(8),
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
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_comment_outlined),
            label: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}

class _PickerMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PickerMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: Colors.grey),
            const SizedBox(height: 12),
            Text(text, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
