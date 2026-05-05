import 'package:flutter/material.dart';

class FavorilerEkrani extends StatelessWidget {
  const FavorilerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2D3C2), // Figma'daki yeşil ton
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // Burası seni ana sayfaya veya bir önceki sayfaya götürür
            Navigator.maybePop(context);
          },
        ),
        title: const Text(
          'Favorilerim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // 1. İlan: Bebek Bezi
          FavoriteProductCard(
            title: 'Bebek Bezi (2 Numara)',
            category: 'Bebek & Çocuk',
            description: 'Yeni doğan bebeğim için almıştım, paket açılmadı.',
            user: 'Merve C.',
            location: 'Üsküdar, İstanbul',
            time: '2 saat önce',
            imageUrl:
                'https://via.placeholder.com/150', // Şimdilik yer tutucu görsel
          ),
          SizedBox(height: 16),
          // 2. İlan: Elektrikli Isıtıcı
          FavoriteProductCard(
            title: 'Elektrikli Isıtıcı',
            category: 'Ev & Yaşam',
            description: 'Az kullanılmış, sorunsuz çalışıyor.',
            user: 'Ali K.',
            location: 'Beyoğlu, İstanbul',
            time: '5 saat önce',
            imageUrl: 'https://via.placeholder.com/150',
          ),
          SizedBox(height: 24),
          // Bilgi Kutusu
          InfoBox(),
        ],
      ),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ürün Görseli
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Ürün Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          // Favori İkonu ve Buton
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  minimumSize: const Size(60, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'İncele',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FAF6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.black54),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Favoriye aldığınız ilanlar yayından kaldırıldığında listeden otomatik olarak silinir.',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
