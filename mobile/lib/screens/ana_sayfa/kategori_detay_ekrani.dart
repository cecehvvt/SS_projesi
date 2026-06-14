import 'package:flutter/material.dart';
import 'filtre_ekrani.dart';

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

  // 6 KATEGORİNİN EKSİKSİZ 4'ER ÜRÜNLÜ TAM LİSTESİ
  List<Map<String, String>> _verileriGetir() {
    switch (widget.baslik) {
      case "Kadın Giyim":
        return [
          {
            "baslik": "Kışlık Kaban",
            "detay": "M Beden",
            "kisi": "Zeynep A.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/kaban.png",
          },
          {
            "baslik": "Triko Kazak",
            "detay": "S Beden",
            "kisi": "Cemre F.",
            "sure": "3 saat önce",
            "resim": "assets/images/ilanlar/kazak.png",
          },
          {
            "baslik": "Kot Pantolon",
            "detay": "S Beden",
            "kisi": "Elif A.",
            "sure": "3 saat önce",
            "resim": "assets/images/ilanlar/kadin_kot.png",
          },
          {
            "baslik": "Elbise",
            "detay": "S Beden",
            "kisi": "Sibel A.",
            "sure": "3 saat önce",
            "resim": "assets/images/ilanlar/elbise.png",
          },
        ];
      case "Erkek Giyim":
        return [
          {
            "baslik": "Kışlık Mont",
            "detay": "L Beden",
            "kisi": "Ahmet A.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/erkek_mont.png",
          },
          {
            "baslik": "Kot Pantolon",
            "detay": "38 Beden",
            "kisi": "Taha A.",
            "sure": "7 saat önce",
            "resim": "assets/images/ilanlar/erkek_kot.png",
          },
          {
            "baslik": "Gömlek",
            "detay": "M Beden",
            "kisi": "Yılmaz A.",
            "sure": "2 gün önce",
            "resim": "assets/images/ilanlar/gomlek.png",
          },
          {
            "baslik": "Sweatshirt",
            "detay": "XXL Beden",
            "kisi": "Mehmet T.",
            "sure": "1 saat önce",
            "resim": "assets/images/ilanlar/sweatshirt.png",
          },
        ];
      case "Çocuk & Bebek":
        return [
          {
            "baslik": "Bebek Arabası",
            "detay": "0-3 yaş",
            "kisi": "Seda A.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/bebek_arabasi.png",
          },
          {
            "baslik": "Bebek Kıyafet Takımı",
            "detay": "0-6 ay",
            "kisi": "Taha A.",
            "sure": "7 saat önce",
            "resim": "assets/images/ilanlar/bebek_takim.png",
          },
          {
            "baslik": "Oyuncak",
            "detay": "2-5 yaş",
            "kisi": "Selda A.",
            "sure": "5 saat önce",
            "resim": "assets/images/ilanlar/oyuncak.png",
          },
          {
            "baslik": "Mama Sandalyesi",
            "detay": "6-36 ay",
            "kisi": "Ayça T.",
            "sure": "1 gün önce",
            "resim": "assets/images/ilanlar/mama_sandalyesi.png",
          },
        ];
      case "Elektronik":
        return [
          {
            "baslik": "Dizüstü Bilgisayar",
            "detay": "MSI Gaming",
            "kisi": "Seda A.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/laptop.png",
          },
          {
            "baslik": "Akıllı Telefon",
            "detay": "iPhone 13",
            "kisi": "Kemal A.",
            "sure": "7 saat önce",
            "resim": "assets/images/ilanlar/telefon.png",
          },
          {
            "baslik": "Kulaklık",
            "detay": "JBL Tune",
            "kisi": "Can A.",
            "sure": "5 saat önce",
            "resim": "assets/images/ilanlar/kulaklik.png",
          },
          {
            "baslik": "Tablet",
            "detay": "iPad Air",
            "kisi": "Eda T.",
            "sure": "1 gün önce",
            "resim": "assets/images/ilanlar/tablet.png",
          },
        ];
      case "Ev & Yaşam":
        return [
          {
            "baslik": "Çalışma Masası",
            "detay": "Beyaz Ahşap",
            "kisi": "Murat A.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/masa.png",
          },
          {
            "baslik": "Koltuk Takımı",
            "detay": "3+2+1",
            "kisi": "Arda A.",
            "sure": "7 saat önce",
            "resim": "assets/images/ilanlar/koltuk.png",
          },
          {
            "baslik": "Halı",
            "detay": "Yün Halı",
            "kisi": "Ceylin A.",
            "sure": "5 saat önce",
            "resim": "assets/images/ilanlar/hali.png",
          },
          {
            "baslik": "Kitaplık",
            "detay": "5 Raflı",
            "kisi": "Tarık T.",
            "sure": "1 gün önce",
            "resim": "assets/images/ilanlar/kitaplik.png",
          },
        ];
      case "Kırtasiye & Diğer":
        return [
          {
            "baslik": "Okul Çantası",
            "detay": "Pembe Sırt Çantası",
            "kisi": "Samet T.",
            "sure": "2 saat önce",
            "resim": "assets/images/ilanlar/canta.png",
          },
          {
            "baslik": "Defter",
            "detay": "A4 Kareli",
            "kisi": "Esma B.",
            "sure": "7 saat önce",
            "resim": "assets/images/ilanlar/defter.png",
          },
          {
            "baslik": "Kalem Seti",
            "detay": "24 Renk",
            "kisi": "Ekin Z.",
            "sure": "5 saat önce",
            "resim": "assets/images/ilanlar/kalem.png",
          },
          {
            "baslik": "Bisiklet",
            "detay": "26 Jant",
            "kisi": "Alev D.",
            "sure": "1 gün önce",
            "resim": "assets/images/ilanlar/bisiklet.png",
          },
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
            Text(
              widget.baslik,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            // ARAMA VE FİLTRE
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "${widget.baslik} içinde ara...",
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FiltreEkrani(),
                      );
                    },
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // SEKMELER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: ["Tümü", "Bağışlananlar", "İhtiyaçlar"].map((tab) {
                    bool secili = seciliSekme == tab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => seciliSekme = tab),
                        child: Container(
                          decoration: BoxDecoration(
                            color: secili
                                ? widget.sekmeRenk
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: secili
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // LİSTE (GERÇEK RESİMLİ)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ilanlar.length,
                itemBuilder: (context, index) =>
                    _kategoriIlanKarti(ilanlar[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kategoriIlanKarti(Map<String, String> ilan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          // GERÇEK RESİM BURADA!
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              ilan["resim"]!,
              width: 85,
              height: 105,
              fit: BoxFit.cover,
              // Resim klasörde yoksa veya isim yanlışsa gri kutu göstersin diye koruma
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 85,
                  height: 105,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
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
                    Text(
                      ilan["baslik"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ],
                ),
                Text(
                  ilan["detay"]!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 12),
                    const SizedBox(width: 4),
                    Text(ilan["kisi"]!, style: const TextStyle(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          ilan["sure"]!,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        minimumSize: const Size(60, 26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Takip Et",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
