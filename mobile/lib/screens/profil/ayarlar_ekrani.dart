import 'package:flutter/material.dart';
import '../../widgets/alt_menu.dart'; // Alt menüyü import ettik
import 'sikayet_destek_ekrani.dart'; // YENİ: Geçiş yapılacak sayfa

class AyarlarEkrani extends StatefulWidget {
  const AyarlarEkrani({super.key});

  @override
  State<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  // Switch'lerin durumlarını tutmak için değişkenler
  bool profilGorumumu = true;
  bool mesajAlma = true;
  bool konumGosterimi = false;
  bool karanlikMod = false;
  bool bildirimler = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üstteki Kullanıcı Bilgi Kartı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.green),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ayşe Demir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Hesabını yönetin ve tercihlerinizi düzenleyin.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Icon(Icons.verified_user, color: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Hesap Ayarları Bölümü
              _buildBolumBasligi(Icons.person_outline, 'Hesap Ayarları'),
              _buildMenuElemani(context, 'Profilimi Düzenle'),
              _buildMenuElemani(context, 'Şifre Değiştir'),
              _buildMenuElemani(context, 'Telefon Numaram'),
              _buildMenuElemani(context, 'E-posta Adresim'),
              const Divider(height: 32),

              // Gizlilik Ayarları Bölümü
              _buildBolumBasligi(Icons.lock_outline, 'Gizlilik Ayarları'),
              _buildSwitchElemani('Profil başkalarının görmesine izin ver', profilGorumumu, (val) => setState(() => profilGorumumu = val)),
              _buildSwitchElemani('Mesaj almayı etkinleştir', mesajAlma, (val) => setState(() => mesajAlma = val)),
              _buildSwitchElemani('Konumu ilanlarda göster', konumGosterimi, (val) => setState(() => konumGosterimi = val)),
              const Divider(height: 32),

              // Şikayet ve Destek Bölümü
              _buildBolumBasligi(Icons.headset_mic_outlined, 'Şikayet ve Destek'),
              _buildMenuElemani(context, 'Kullanıcıyı Şikayet Et'),
              
              // YENİ: Rota bağlanan Yardım & Destek butonu
              _buildMenuElemani(
                context, 
                'Yardım & Destek',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SikayetDestekEkrani()),
                  );
                }
              ),
              
              _buildMenuElemani(context, 'Kullanım Koşulları'),
              const Divider(height: 32),

              // Uygulama Tercihleri Bölümü
              _buildBolumBasligi(Icons.settings_outlined, 'Uygulama Tercihleri'),
              _buildSwitchElemani('Karanlık Mod', karanlikMod, (val) => setState(() => karanlikMod = val)),
              _buildSwitchElemani('Bildirimler', bildirimler, (val) => setState(() => bildirimler = val)),
              _buildMenuElemani(context, 'Dil Seçimi', sagTarafYazisi: 'Türkçe'),
              
              const SizedBox(height: 32),

              // Çıkış Yap Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
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
                  label: const Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Alt menüyü ekliyoruz
      bottomNavigationBar: const VestaAltMenu(),
    );
  }

  // Bölüm Başlıklarını Oluşturan Yardımcı Widget
  Widget _buildBolumBasligi(IconData ikon, String baslik) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(ikon, size: 20, color: Colors.black87),
          const SizedBox(width: 8),
          Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }

  // YENİ: Tıklanabilir (InkWell) Menü Satırları
  Widget _buildMenuElemani(BuildContext context, String baslik, {String? sagTarafYazisi, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(baslik, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
            Row(
              children: [
                if (sagTarafYazisi != null) ...[
                  Text(sagTarafYazisi, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  const SizedBox(width: 8),
                ],
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // YENİ: Çalışan (Stateful) Switch Elemanı
  Widget _buildSwitchElemani(String baslik, bool acikMi, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(baslik, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500))),
          Switch(
            value: acikMi,
            onChanged: onChanged, // Artık tıklanınca açılıp kapanıyor
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}