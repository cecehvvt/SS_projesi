import 'package:flutter/material.dart';

class IlanListesiEkrani extends StatelessWidget {
  const IlanListesiEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Açık gri arka plan
      appBar: AppBar(
        backgroundColor: const Color(0xFFA5D6C1), // Tasarımdaki üst yeşil bar rengi
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Geri dönme işlemi
          },
        ),
        title: const Text(
          'Bağışlananlar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama ve Filtre Çubuğu
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Ara (ürün, başlık, kategori, konum)',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt_outlined, color: Colors.green, size: 20),
                      SizedBox(width: 4),
                      Text('Filtrele', style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // "Tümü" ve "Bağışladıklarım" Sekmeleri (Temsili)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4EAE2), // Seçili sekme rengi
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text('Tümü', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Bağışladıklarım', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // İlan Listesi (Şimdilik 2 tane temsili kart ekliyorum)
            Expanded(
              child: ListView(
                children: [
                  _buildIlanKarti(
                    kategori: 'Bebek & Çocuk',
                    baslik: 'Bebek Arabası',
                    aciklama: 'Az kullanılmış, temizdir. İhtiyacı olan bir aileye vermek istiyorum.',
                    kullanici: 'Zeynep Ş.',
                    konum: 'Üsküdar, İstanbul',
                    zaman: '5 saat önce',
                  ),
                  const SizedBox(height: 12),
                  _buildIlanKarti(
                    kategori: 'Ev & Yaşam',
                    baslik: 'Çalışma Masası',
                    aciklama: 'Temiz ve sağlamdır. İhtiyaç sahibi birine vermek istiyorum.',
                    kullanici: 'Ali B.',
                    konum: 'Beyoğlu, İstanbul',
                    zaman: '4 saat önce',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // İlan Kartını Oluşturan Yardımcı Fonksiyon (Bunu daha sonra widget klasörüne taşıyabiliriz)
  Widget _buildIlanKarti({
    required String kategori,
    required String baslik,
    required String aciklama,
    required String kullanici,
    required String konum,
    required String zaman,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol taraf resim alanı (Şimdilik gri kutu)
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Sağ taraf içerik alanı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4EAE2), // Kategori arka plan rengi
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        kategori,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ),
                    const Icon(Icons.favorite_border, color: Colors.black54, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  aciklama, 
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Kullanıcı, Konum ve Zaman bilgileri
                Row(
                  children: [
                    const Icon(Icons.person, size: 12, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(kullanici, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(konum, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(zaman, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B824B), // Koyu yeşil buton
                        minimumSize: const Size(60, 24),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      child: const Text('Talep Et', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}