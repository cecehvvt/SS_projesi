import 'package:flutter/material.dart';

class BagislananlarEkrani extends StatefulWidget {
  const BagislananlarEkrani({super.key});

  @override
  State<BagislananlarEkrani> createState() => _BagislananlarEkraniState();
}

class _BagislananlarEkraniState extends State<BagislananlarEkrani> {
  bool isTumuSecili = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD6C4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bağışlananlar",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // ARAMA VE FİLTRE ÇUBUĞU
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

          // TÜMÜ / BAĞIŞLADIKLARIM SEKMELERİ
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
                      onTap: () {
                        setState(() { isTumuSecili = true; });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isTumuSecili ? const Color(0xFFDFF0E6) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grid_view, color: isTumuSecili ? Colors.green.shade700 : Colors.grey, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              "Tümü",
                              style: TextStyle(
                                color: isTumuSecili ? Colors.green.shade700 : Colors.grey,
                                fontWeight: isTumuSecili ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() { isTumuSecili = false; });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isTumuSecili ? const Color(0xFFDFF0E6) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, color: !isTumuSecili ? Colors.green.shade700 : Colors.grey, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              "Bağışladıklarım",
                              style: TextStyle(
                                color: !isTumuSecili ? Colors.green.shade700 : Colors.grey,
                                fontWeight: !isTumuSecili ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // İLAN LİSTESİ
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _detayliIlanKarti("Bebek & Çocuk", "Bebek Arabası", "Az kullanılmış, temizdir. İhtiyacı olan bir aileye vermek istiyorum.", "Zeynep Ş.", "Üsküdar, İstanbul", "5 saat önce", "4 km"),
                const SizedBox(height: 16),
                _detayliIlanKarti("Ev & Yaşam", "Çalışma Masası", "Temiz ve sağlamdır. İhtiyaç sahibi birine vermek istiyorum.", "Ali B.", "Beyoğlu, İstanbul", "4 saat önce", "6 km"),
                const SizedBox(height: 16),
                _detayliIlanKarti("Kadın Giyim", "Kışlık Mont", "Kışlık mont ihtiyacım var. Bedeni M veya L olabilir", "Yusuf E.", "Beyoğlu, İstanbul", "2 saat önce", "6 km"),
                const SizedBox(height: 20), 
              ],
            ),
          )
        ],
      ),
      
      // ALT MENÜ (Bottom Navigation Bar) - YENİ EKLENEN KISIM
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFAFD6C4), // Tasarımdaki üst/alt menü rengi
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _altMenuElemani(Icons.home_outlined, "Anasayfa"),
            _altMenuElemani(Icons.chat_bubble_outline, "Mesajlar"),
            _altMenuElemani(Icons.add_circle_outline, "İlan Oluştur", ikonBoyutu: 28), // İlan oluştur ikonu biraz daha büyük
            _altMenuElemani(Icons.favorite_border, "Favoriler"),
            _altMenuElemani(Icons.shopping_bag_outlined, "Sepetim"),
            _altMenuElemani(Icons.person_outline, "Profilim"),
          ],
        ),
      ),
    );
  }

  // Alt Menü Elemanı Yardımcı Widget'ı
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

  // İlan Kartı Widget'ı
  Widget _detayliIlanKarti(String kategori, String baslik, String detay, String kisi, String konum, String sure, String mesafe) {
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
                          minimumSize: const Size(70, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text("Talep Et", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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