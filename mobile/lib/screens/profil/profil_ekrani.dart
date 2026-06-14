import 'package:flutter/material.dart';
// DİKKAT: Alttaki import satırı kırmızı çizilirse üzerine tıklayıp 
// ampulden doğru dosya yolunu seç veya dosya adının tam doğru olduğundan emin ol.
import 'profil_duzenle_ekrani.dart'; 

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profilim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Ayarlar butonuna basınca da düzenleme sayfasına gitsin
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilDuzenleEkrani()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profil Başlık Alanı
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ayşe Demir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.verified_user, color: Colors.green, size: 14),
                            SizedBox(width: 4),
                            Text('Güvenli Kullanıcı', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                            SizedBox(width: 4),
                            Text('Üsküdar, İstanbul', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // İŞTE BURASI! Butona basınca bizim sayfaya ışınlıyoruz
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilDuzenleEkrani()),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 14, color: Colors.green),
                    label: const Text('Profili Düzenle', style: TextStyle(color: Colors.green, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              
              // Motivasyon Kartı
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.eco, color: Colors.green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Paylaşarak daha güzel bir dünya için katkı sağlıyorsun!\nBugüne kadar 12 ürün bağışladın.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // İstatistikler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIstatistik(ikon: Icons.card_giftcard, sayi: '12', baslik: 'Bağışladıklarım', renk: Colors.green),
                  _buildIstatistik(ikon: Icons.favorite_border, sayi: '5', baslik: 'İhtiyaç Taleplerim', renk: Colors.purple),
                  _buildIstatistik(ikon: Icons.swap_horiz, sayi: '3', baslik: 'Takas İlanlarım', renk: Colors.blue),
                  _buildIstatistik(ikon: Icons.bookmark_border, sayi: '18', baslik: 'Kaydedilenlerim', renk: Colors.orange),
                ],
              ),
              const SizedBox(height: 24),
              
              // Sekmeler
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TabBaslik(ikon: Icons.inventory_2_outlined, metin: 'İlanlarım', secili: true),
                    _TabBaslik(ikon: Icons.clean_hands_outlined, metin: 'Taleplerim', secili: false),
                    _TabBaslik(ikon: Icons.swap_horiz, metin: 'Takaslarım', secili: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Mini İlan Listesi
              _buildMiniIlanKarti('Koltuk Takımı', 'Ev & Yaşam', 'Aktif', Colors.green),
              _buildMiniIlanKarti('Kadın Kışlık Kaban', 'Giyim & Ayakkabı', 'Beklemede', Colors.blue),
              _buildMiniIlanKarti('Kitap - Küçük Prens', 'Kitap & Kırtasiye', 'Tamamlandı', Colors.grey),
              
              TextButton(
                onPressed: () {},
                child: const Text('Tüm İlanlarımı Görüntüle >', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              
              // Alt Menü Seçenekleri
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildMenuSatiri(Icons.chat_bubble_outline, 'Mesajlarım', hasBadge: true),
                    const Divider(height: 1),
                    _buildMenuSatiri(Icons.bookmark_border, 'Sepetim'),
                    const Divider(height: 1),
                    _buildMenuSatiri(Icons.star_border, 'Değerlendirmelerim'),
                    const Divider(height: 1),
                    _buildMenuSatiri(Icons.help_outline, 'Yardım & Destek'),
                    const Divider(height: 1),
                    _buildMenuSatiri(Icons.info_outline, 'Hakkımızda'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIstatistik({required IconData ikon, required String sayi, required String baslik, required Color renk}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: renk.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(ikon, color: renk, size: 24),
        ),
        const SizedBox(height: 8),
        Text(sayi, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: renk)),
        const SizedBox(height: 4),
        Text(baslik, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }

  Widget _buildMiniIlanKarti(String baslik, String kategori, String durum, Color durumRengi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(kategori, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: durumRengi.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(durum, style: TextStyle(color: durumRengi, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMenuSatiri(IconData ikon, String baslik, {bool hasBadge = false}) {
    return ListTile(
      leading: Icon(ikon, color: Colors.black87),
      title: Text(baslik, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasBadge)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}

// Sekme başlıkları için yardımcı küçük widget
class _TabBaslik extends StatelessWidget {
  final IconData ikon;
  final String metin;
  final bool secili;
  const _TabBaslik({required this.ikon, required this.metin, required this.secili});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: secili ? Colors.green : Colors.transparent, width: 2)),
      ),
      child: Row(
        children: [
          Icon(ikon, size: 16, color: secili ? Colors.green : Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(metin, style: TextStyle(fontWeight: secili ? FontWeight.bold : FontWeight.w500, color: secili ? Colors.green : Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }
}