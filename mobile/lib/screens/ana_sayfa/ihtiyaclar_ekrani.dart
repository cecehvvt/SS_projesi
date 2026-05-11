import 'package:flutter/material.dart';

class IhtiyaclarEkrani extends StatefulWidget {
  const IhtiyaclarEkrani({super.key});

  @override
  State<IhtiyaclarEkrani> createState() => _IhtiyaclarEkraniState();
}

class _IhtiyaclarEkraniState extends State<IhtiyaclarEkrani> {
  // Tasarımdaki üst sekmeleri takip eder (İhtiyaçlar aktif)
  bool isIhtiyaclarSecili = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      
      // 1. ÜST BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD6C4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "İhtiyaçlar",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 2. ARAMA VE FİLTRE ÇUBUĞU
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Ara(ürün,başlık,kategori,konum)",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.filter_alt_outlined, color: Colors.green),
                      SizedBox(width: 6),
                      Text("Filtrele", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. İHTİYAÇLAR / BAĞIŞLANANLAR SEKMELERİ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isIhtiyaclarSecili = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isIhtiyaclarSecili ? const Color(0xFFDFF0E6) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "İhtiyaçlar",
                            style: TextStyle(
                              color: isIhtiyaclarSecili ? Colors.green.shade700 : Colors.grey,
                              fontWeight: isIhtiyaclarSecili ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isIhtiyaclarSecili = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isIhtiyaclarSecili ? const Color(0xFFDFF0E6) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Bağışlananlar",
                            style: TextStyle(
                              color: !isIhtiyaclarSecili ? Colors.green.shade700 : Colors.grey,
                              fontWeight: !isIhtiyaclarSecili ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. İHTİYAÇ LİSTESİ
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ihtiyacKarti("Bebek & Çocuk", "Bebek Bezi", "Yeni doğan bebeğim için 2 numara bebek bezine ihtiyacım var.", "Mehmet Ş.", "Üsküdar, İstanbul", "5 saat önce", "4 km", isAcil: true),
                const SizedBox(height: 16),
                _ihtiyacKarti("Ev & Yaşam", "Elektrikli Isıtıcı", "Kış ayları için ısınma ihtiyacımız var. Çalışır durumda olsa çok seviniriz.", "Arda B.", "Beyoğlu, İstanbul", "4 saat önce", "6 km", isAcil: true),
                const SizedBox(height: 16),
                _ihtiyacKarti("Elektronik", "İkinci El Telefon", "Sağlamdır, ihtiyaç sahibi birine vermek istiyorum.", "Yusuf E.", "Beyoğlu, İstanbul", "2 saat önce", "6 km", isAcil: false),
                const SizedBox(height: 20), 
              ],
            ),
          )
        ],
      ),
      
      // ALT MENÜ (Bottom Navigation Bar)
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
            _altMenuElemani(Icons.add_circle_outline, "İlan Oluştur", ikonBoyutu: 28),
            _altMenuElemani(Icons.favorite_border, "Favoriler"),
            _altMenuElemani(Icons.shopping_bag_outlined, "Sepetim"),
            _altMenuElemani(Icons.person_outline, "Profilim"),
          ],
        ),
      ),
    );
  }

  // Alt Menü Yardımcı Widget
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

  // İhtiyaç İlan Kartı Tasarımı
  Widget _ihtiyacKarti(String kategori, String baslik, String detay, String kisi, String konum, String sure, String mesafe, {bool isAcil = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim Alanı ve Acil Etiketi
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
                ),
                if (isAcil)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade800, borderRadius: BorderRadius.circular(6)),
                      child: const Text("ACİL", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(mesafe, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 12),
            // Detaylar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDFF0E6), borderRadius: BorderRadius.circular(6)),
                        child: Text(kategori, style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.favorite_border, size: 20, color: Colors.black87),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(baslik, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(detay, style: const TextStyle(fontSize: 12, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(kisi, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(konum, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(sure, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 28),
                          backgroundColor: const Color(0xFF2E7D32), // Yardım Et Butonu Yeşil
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text("Yardım Et", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}