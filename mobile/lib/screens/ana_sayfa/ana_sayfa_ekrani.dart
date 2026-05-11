import 'package:flutter/material.dart';
import 'bagislananlar_ekrani.dart';
import 'ihtiyaclar_ekrani.dart';
import 'kategori_detay_ekrani.dart'; // Yeni akıllı sayfamız

class AnaSayfaEkrani extends StatelessWidget {
  const AnaSayfaEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. ÜST KISIM (Mint Yeşili Arka Plan ve Ana Butonlar)
          Container(
            color: const Color(0xFFB2D3C2),
            padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            // BAĞIŞLANANLAR BUTONU
                            _anaMenuButonu(context, "Bağışlananlar", const BagislananlarEkrani()),
                            // İHTİYAÇLAR BUTONU
                            _anaMenuButonu(context, "İhtiyaçlar", const IhtiyaclarEkrani()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.filter_alt_outlined, color: Colors.black87, size: 28),
                  ],
                ),
                const SizedBox(height: 15),
                // Arama Çubuğu
                TextField(
                  decoration: InputDecoration(
                    hintText: "İhtiyacın olan eşyayı ara...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),

          // 2. ALT KISIM (Kaydırılabilir İçerik)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kategoriler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // 6 KATEGORİ - HEPSİ AKILLI SAYFAYA BAĞLI
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _kategoriKutusu(context, "Kadın\nGiyim", "Kadın Giyim", Icons.checkroom, Colors.blue.shade50, const Color(0xFFAFD6C4), const Color(0xFFDFF0E6)),
                      _kategoriKutusu(context, "Erkek\nGiyim", "Erkek Giyim", Icons.accessibility_new, Colors.blue.shade100, const Color(0xFFAFD6C4), const Color(0xFFDFF0E6)),
                      _kategoriKutusu(context, "Çocuk &\nBebek", "Çocuk & Bebek", Icons.child_care, Colors.blue.shade50, const Color(0xFFF4D8CD), const Color(0xFFF9E8E1)),
                      _kategoriKutusu(context, "Elektronik", "Elektronik", Icons.tv, Colors.blue.shade100, const Color(0xFFD1C4E9), const Color(0xFFEDE7F6)),
                      _kategoriKutusu(context, "Ev &\nYaşam", "Ev & Yaşam", Icons.home_outlined, Colors.blue.shade50, const Color(0xFFC8E6C9), const Color(0xFFE8F5E9)),
                      _kategoriKutusu(context, "Kırtasiye &\nDiğer", "Kırtasiye & Diğer", Icons.edit, Colors.blue.shade100, const Color(0xFFB3E5FC), const Color(0xFFE1F5FE)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text("Öne Çıkan İlanlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      _ilanKarti("Kışlık Mont", "İstanbul, Beyoğlu . 2 km", "Ahmet Y.", "Bağış", "Talep et", const Color(0xFFA5D6A7)),
                      _ilanKarti("Bebek Beşiği", "İstanbul, Beyoğlu . 2 km", "Zeynep A.", "Bağış", "Talep et", const Color(0xFFA5D6A7)),
                      _ilanKarti("Atkı", "İstanbul, Kadıköy . 5 km", "Merve K.", "İhtiyaç", "Yardım et", Colors.red.shade300),
                      _ilanKarti("Çalışma Masası", "İstanbul, Beyoğlu . 2 km", "Mehmet T.", "İhtiyaç", "Yardım et", Colors.red.shade300),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Üstteki Bağışlananlar/İhtiyaçlar butonları için yardımcı widget
  Widget _anaMenuButonu(BuildContext context, String baslik, Widget sayfa) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          splashColor: const Color(0xFF1B4D3E).withOpacity(0.4),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => sayfa)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(baslik, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  // 6 Kategori kutusu için akıllı yardımcı widget
  Widget _kategoriKutusu(BuildContext context, String ekrandakiAd, String gercekAd, IconData ikon, Color kutuRenk, Color sayfaRenk, Color sekmeRenk) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KategoriDetayEkrani(
            baslik: gercekAd,
            ikon: ikon,
            anaRenk: sayfaRenk,
            sekmeRenk: sekmeRenk,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: kutuRenk, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 20),
            const SizedBox(width: 4),
            Text(ekrandakiAd, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _ilanKarti(String baslik, String konum, String kisi, String tip, String butonYazisi, Color butonRengi) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              width: double.infinity,
              child: const Icon(Icons.image, color: Colors.white54, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.black54),
                    Expanded(child: Text(konum, style: const TextStyle(fontSize: 10, color: Colors.black54), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 26,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: butonRengi, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text(butonYazisi, style: const TextStyle(color: Colors.black87, fontSize: 11)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}