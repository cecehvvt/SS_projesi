import 'package:flutter/material.dart';

import '../../models/kullanici_model.dart';
import '../../services/auth_service.dart';
import '../../services/kullanici_service.dart';
import '../../widgets/alt_menu.dart';
import 'profil_duzenle_ekrani.dart';
import 'sikayet_destek_ekrani.dart';

class AyarlarEkrani extends StatefulWidget {
  const AyarlarEkrani({super.key});

  @override
  State<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  final _service = const KullaniciService();
  late Future<KullaniciModel> _future = _service.me();
  bool karanlikMod = false;
  bool bildirimler = true;

  void _reload() {
    setState(() {
      _future = _service.me();
    });
  }

  Future<void> _updatePrivacy(KullaniciModel user, GizlilikAyarlari privacy) async {
    await _service.updatePrivacy(privacy);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<KullaniciModel>(
        future: _future,
        builder: (context, snapshot) {
          final user = snapshot.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AccountHeader(user: user),
                const SizedBox(height: 24),
                _sectionTitle(Icons.person_outline, 'Hesap Ayarlari'),
                _menuItem(
                  'Profilimi Duzenle',
                  onTap: () async {
                    final changed = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilDuzenleEkrani(),
                      ),
                    );
                    if (changed == true) _reload();
                  },
                ),
                _menuItem('Telefon Numaram', value: user?.telefonNumarasi),
                _menuItem('E-posta Adresim', value: user?.eposta),
                const Divider(height: 32),
                _sectionTitle(Icons.lock_outline, 'Gizlilik Ayarlari'),
                _privacySwitch(
                  'Profil baskalarina gorunsun',
                  user?.gizlilikAyarlari.profilBaskalarinaGorunsun ?? true,
                  user,
                  (current, value) => current.copyWith(
                    profilBaskalarinaGorunsun: value,
                  ),
                ),
                _privacySwitch(
                  'Mesaj almayi etkinlestir',
                  user?.gizlilikAyarlari.mesajAlabilir ?? true,
                  user,
                  (current, value) => current.copyWith(mesajAlabilir: value),
                ),
                _privacySwitch(
                  'Konumu ilanlarda goster',
                  user?.gizlilikAyarlari.konumuIlanlardaGoster ?? false,
                  user,
                  (current, value) => current.copyWith(
                    konumuIlanlardaGoster: value,
                  ),
                ),
                const Divider(height: 32),
                _sectionTitle(Icons.headset_mic_outlined, 'Sikayet ve Destek'),
                _menuItem(
                  'Yardim & Destek',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SikayetDestekEkrani(),
                    ),
                  ),
                ),
                const Divider(height: 32),
                _sectionTitle(Icons.settings_outlined, 'Uygulama Tercihleri'),
                _localSwitch(
                  'Karanlik Mod',
                  karanlikMod,
                  (value) => setState(() => karanlikMod = value),
                ),
                _localSwitch(
                  'Bildirimler',
                  bildirimler,
                  (value) => setState(() => bildirimler = value),
                ),
                _menuItem('Dil Secimi', value: 'Turkce'),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await const AuthService().logout();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade100),
                      ),
                    ),
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text(
                      'Cikis Yap',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const VestaAltMenu(),
    );
  }

  Widget _privacySwitch(
    String title,
    bool value,
    KullaniciModel? user,
    GizlilikAyarlari Function(GizlilikAyarlari current, bool value) next,
  ) {
    return _localSwitch(
      title,
      value,
      user == null
          ? null
          : (newValue) => _updatePrivacy(
                user,
                next(user.gizlilikAyarlari, newValue),
              ),
    );
  }

  Widget _localSwitch(String title, bool value, ValueChanged<bool>? onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, {String? value, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null && value.isNotEmpty)
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  final KullaniciModel? user;

  const _AccountHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.tamAd.trim().isNotEmpty == true
        ? user!.tamAd
        : 'Kullanici';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: user?.profilFotoUrl?.isNotEmpty == true
                ? NetworkImage(user!.profilFotoUrl!)
                : null,
            child: user?.profilFotoUrl?.isNotEmpty == true
                ? null
                : const Icon(Icons.person, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  user?.kullaniciAdi?.isNotEmpty == true
                      ? user!.kullaniciAdi!
                      : 'Hesabini ve tercihlerini duzenle.',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_user, color: Colors.green),
        ],
      ),
    );
  }
}
