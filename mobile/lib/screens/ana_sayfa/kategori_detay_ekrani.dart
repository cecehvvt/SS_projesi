import 'package:flutter/material.dart';

class KategoriDetayEkrani extends StatefulWidget {
  final String baslik;
  final IconData ikon;
  final Color anaRenk;
  final Color sekmeRenk;

  const KategoriDetayEkrani({
    super.key,
    required this.baslik,
    required this.ikon,
    required this.anaRenk,
    required this.sekmeRenk,
  });

  @override
  State<KategoriDetayEkrani> createState() => _KategoriDetayEkraniState();
}

class _KategoriDetayEkraniState extends State<KategoriDetayEkrani> {
  String seciliSekme = "Tümü";

  // Tasarımdaki her kategoriye özel sahte veriler
 List<Map<String, String>> _verileriGetir() {
  switch (widget.baslik) {
    case "Kadın Giyim":
      return [
        {"baslik": "Kışlık Kaban", "detay": "M Beden", "kisi": "Zeynep A.", "sure": "2 saat önce"},
        {"baslik": "Triko Kazak", "detay": "S Beden", "kisi": "Cemre F.", "sure": "3 saat önce"},
        {"baslik": "Kot Pantolon", "detay": "S Beden", "kisi": "Elif A.", "sure": "3 saat önce"},
        {"baslik": "Elbise", "detay": "S Beden", "kisi": "Sibel A.", "sure": "3 saat önce"},
      ];
    case "Erkek Giyim":
      return [
        {"baslik": "Kışlık Mont", "detay": "L Beden", "kisi": "Ahmet A.", "sure": "2 saat önce"},
        {"baslik": "Kot Pantolon", "detay": "38 Beden", "kisi": "Taha A.", "sure": "7 saat önce"},
        {"baslik": "Gömlek", "detay": "M Beden", "kisi": "Yılmaz A.", "sure": "2 gün önce"},
        {"baslik": "Sweatshirt", "detay": "XXL Beden", "kisi": "Mehmet T.", "sure": "1 saat önce"},
      ];
    case "Çocuk & Bebek":
      return [
        {"baslik": "Bebek Arabası", "detay": "0-3 yaş", "kisi": "Seda A.", "sure": "2 saat önce"},
        {"baslik": "Bebek Kıyafet Takımı", "detay": "0-6 ay", "kisi": "Taha A.", "sure": "7 saat önce"},
        {"baslik": "Oyuncak", "detay": "2-5 yaş", "kisi": "Selda A.", "sure": "5 saat önce"},
        {"baslik": "Mama Sandalyesi", "detay": "6-36 ay", "kisi": "Ayça T.", "sure": "1 gün önce"},
      ];
    case "Elektronik":
      return [
        {"baslik": "Dizüstü Bilgisayar", "detay": "MSI Gaming", "kisi": "Seda A.", "sure": "2 saat önce"},
        {"baslik": "Akıllı Telefon", "detay": "iPhone 13", "kisi": "Kemal A.", "sure": "7 saat önce"},
        {"baslik": "Kulaklık", "detay": "JBL Tune", "kisi": "Can A.", "sure": "5 saat önce"},
        {"baslik": "Tablet", "detay": "iPad Air", "kisi": "Eda T.", "sure": "1 gün önce"},
      ];
    case "Ev & Yaşam":
      return [
        {"baslik": "Çalışma Masası", "detay": "Beyaz Ahşap", "kisi": "Murat A.", "sure": "2 saat önce"},
        {"baslik": "Koltuk Takımı", "detay": "3+2+1", "kisi": "Arda A.", "sure": "7 saat önce"},
        {"baslik": "Halı", "detay": "Yün Halı", "kisi": "Ceylin A.", "sure": "5 saat önce"},
        {"baslik": "Kitaplık", "detay": "5 Raflı", "kisi": "Tarık T.", "sure": "1 gün önce"},
      ];
    case "Kırtasiye & Diğer":
      return [
        {"baslik": "Okul Çantası", "detay": "Pembe Sırt Çantası", "kisi": "Samet T.", "sure": "2 saat önce"},
        {"baslik": "Defter", "detay": "A4 Kareli", "kisi": "Esma B.", "sure": "7 saat önce"},
        {"baslik": "Kalem Seti", "detay": "24 Renk", "kisi": "Ekin Z.", "sure": "5 saat önce"},
        {"baslik": "Bisiklet", "detay": "26 Jant", "kisi": "Alev D.", "sure": "1 gün önce"},
      ];
    default:
      return [];
  }
}

  @override
  Widget build(BuildContext context) {
    final ilanlar = _verileriGetir();

    return Scaffold(
      backgroundColor: widget.anaRenk,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.ikon, color: Colors.black87),
            const SizedBox(width: 8),
            Text(widget.baslik, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // ARAMA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "${widget.baslik} içinde ara...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_alt_outlined),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            // SEKMELER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ["Tümü", "Bağışlananlar", "İhtiyaçlar"].map((tab) {
                  bool secili = seciliSekme == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => seciliSekme = tab),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: secili ? widget.sekmeRenk : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(tab, style: TextStyle(fontSize: 12, fontWeight: secili ? FontWeight.bold : FontWeight.normal)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // LİSTE
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ilanlar.length,
                itemBuilder: (context, index) {
                  return _kartTasarimi(ilanlar[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: widget.anaRenk,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.home_outlined),
            Icon(Icons.chat_bubble_outline),
            Icon(Icons.shopping_bag_outlined),
            Icon(Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _kartTasarimi(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(width: 80, height: 100, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.image, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["baslik"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(data["detay"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.person, size: 14), Text(" ${data["kisi"]!}", style: const TextStyle(fontSize: 11))]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(data["sure"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(60, 25), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Takip Et", style: TextStyle(fontSize: 10, color: Colors.white)),
                  )
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}