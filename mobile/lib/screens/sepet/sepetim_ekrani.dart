import 'package:flutter/material.dart';

class SepetimEkrani extends StatelessWidget {
  const SepetimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // ÜST BAR (Mint Yeşili)
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD6C4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sepetim",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. ÜRÜN: BEBEK BEZİ
                _sepetKarti(
                  baslik: "Bebek Bezi",
                  konum: "Üsküdar, İstanbul",
                  kisi: "Mehmet Ş.",
                  tarih: "10 Mayıs 2026",
                  resimYolu: "assets/images/ilanlar/bez.png",
                ),
                const SizedBox(height: 16),
                
                // 2. ÜRÜN: KIŞLIK MONT
                _sepetKarti(
                  baslik: "Kışlık Mont",
                  konum: "Üsküdar, İstanbul",
                  kisi: "Mehmet Ş.",
                  tarih: "10 Mayıs 2026",
                  resimYolu: "assets/images/ilanlar/mont2.png",
                ),
                const SizedBox(height: 24),

                // BİLGİ KUTUSU
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FAF6), // Çok açık mint/beyaz
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.black, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Takip ettiğiniz ilanlarınız sadece\nsizin tarafınızdan görüntülenebilir.",
                          style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ALT MENÜ (Tasarıma birebir uygun 6'lı menü)
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFAFD6C4),
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _altMenuElemani(Icons.home_outlined, "Anasayfa"),
            _altMenuElemani(Icons.chat_bubble_outline, "Mesajlar"),
            _altMenuElemani(Icons.add_circle_outline, "İlan Oluştur", ikonBoyutu: 26),
            _altMenuElemani(Icons.favorite_border, "Favoriler"),
            _altMenuElemani(Icons.shopping_bag_outlined, "Sepetim"),
            _altMenuElemani(Icons.person_outline, "Profilim"),
          ],
        ),
      ),
    );
  }

  // Alt menü yardımcı widget'ı
  Widget _altMenuElemani(IconData ikon, String baslik, {double ikonBoyutu = 24}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(ikon, color: Colors.black87, size: ikonBoyutu),
        const SizedBox(height: 2),
        Text(baslik, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Sepet Kartı Tasarımı
  Widget _sepetKarti({
    required String baslik,
    required String konum,
    required String kisi,
    required String tarih,
    required String resimYolu,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RESİM VE KONUM İKONU KISMI
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  resimYolu,
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100, height: 120, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              // Resim üzerindeki siyah transparan konum etiketi
              Positioned(
                bottom: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.location_on, color: Colors.white, size: 14),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          
          // DETAYLAR VE BUTONLAR KISMI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Icon(Icons.favorite, color: Colors.black, size: 22),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(konum, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(kisi, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Talep Tarihi: $tarih", style: TextStyle(fontSize: 11, color: Colors.black87.withOpacity(0.8))),
                const SizedBox(height: 12),
                
                // KALDIR VE MESAJA GİT BUTONLARI
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Kaldır", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color(0xFF2E7D32), // Tasarımdaki koyu yeşil
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: const Text("Mesaja Git", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
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