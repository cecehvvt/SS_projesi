import 'package:flutter/material.dart';

class AyarlarEkrani extends StatelessWidget {
  const AyarlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            // Geri dönme işlemi
          },
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
                  color: const Color(0xFFE8F5E9), // Hafif yeşil
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
              _buildMenuElemani('Profilimi Düzenle'),
              _buildMenuElemani('Şifre Değiştir'),
              _buildMenuElemani('Telefon Numaram'),
              _buildMenuElemani('E-posta Adresim'),
              const Divider(height: 32),

              // Gizlilik Ayarları Bölümü
              _buildBolumBasligi(Icons.lock_outline, 'Gizlilik Ayarları'),
              _buildSwitchElemani('Profil başkalarının görmesine izin ver', true),
              _buildSwitchElemani('Mesaj almayı etkinleştir', true),
              _buildSwitchElemani('Konumu ilanlarda göster', false),
              const Divider(height: 32),

              // Şikayet ve Destek Bölümü
              _buildBolumBasligi(Icons.headset_mic_outlined, 'Şikayet ve Destek'),
              _buildMenuElemani('Kullanıcıyı Şikayet Et'),
              _buildMenuElemani('Yardım & Destek'),
              _buildMenuElemani('Kullanım Koşulları'),
              const Divider(height: 32),

              // Uygulama Tercihleri Bölümü
              _buildBolumBasligi(Icons.settings_outlined, 'Uygulama Tercihleri'),
              _buildSwitchElemani('Karanlık Mod', false),
              _buildSwitchElemani('Bildirimler', true),
              _buildMenuElemani('Dil Seçimi', sagTarafYazisi: 'Türkçe'),
              
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

  // Normal Menü Satırları (Sağında ok veya yazı olanlar)
  Widget _buildMenuElemani(String baslik, {String? sagTarafYazisi}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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
    );
  }

  // Aç-Kapat (Switch) Menü Satırları
  Widget _buildSwitchElemani(String baslik, bool acikMi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(baslik, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500))),
          Switch(
            value: acikMi,
            onChanged: (bool value) {},
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