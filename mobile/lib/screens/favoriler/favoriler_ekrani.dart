import 'package:flutter/material.dart';

class FavorilerEkrani extends StatelessWidget {
  const FavorilerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFD6C4), 
        elevation: 0,
        title: const Text(
          'Favorilerim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // 1. İlan: Bebek Bezi (Yerel resim kullanıldı)
          FavoriteProductCard(
            title: 'Bebek Bezi (2 Numara)',
            category: 'Bebek & Çocuk',
            description: 'Yeni doğan bebeğim için almıştım, paket açılmadı.',
            user: 'Merve C.',
            location: 'Üsküdar, İstanbul',
            time: '2 saat önce',
            imageUrl: 'assets/images/ilanlar/bez.png', 
          ),
          SizedBox(height: 16),
          // 2. İlan: Elektrikli Isıtıcı (Yerel resim kullanıldı)
          FavoriteProductCard(
            title: 'Elektrikli Isıtıcı',
            category: 'Ev & Yaşam',
            description: 'Az kullanılmış, sorunsuz çalışıyor.',
            user: 'Ali K.',
            location: 'Beyoğlu, İstanbul',
            time: '5 saat önce',
            imageUrl: 'assets/images/ilanlar/isitici.png',
          ),
          SizedBox(height: 24),
          // Bilgi Kutusu
          InfoBox(),
        ],
      ),
      // ALT MENÜ EKLENDİ
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
}

class FavoriteProductCard extends StatelessWidget {
  final String title, category, description, user, location, time, imageUrl;

  const FavoriteProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.user,
    required this.location,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün Görseli (Image.network yerine Image.asset yapıldı)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80, height: 100, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Ürün Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFDFF0E6), borderRadius: BorderRadius.circular(4)),
                      child: Text(category, style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(Icons.favorite, color: Colors.black87, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(user, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(60, 26),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('İncele', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
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

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 28, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Favoriye aldığınız ilanlar yayından kaldırıldığında listeden otomatik olarak silinir.',
              style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

