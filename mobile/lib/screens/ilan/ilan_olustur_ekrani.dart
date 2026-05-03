import 'package:flutter/material.dart';

class IlanOlusturEkrani extends StatelessWidget {
  const IlanOlusturEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            // Geri dönme işlemi
          },
        ),
        title: const Text(
          'İlan Oluştur',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lütfen ilan türünü seçin.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 32),
            
            // Bağış İlanı Oluştur Kartı
            _buildSecimKarti(
              context: context,
              baslik: 'Bağış İlanı Oluştur',
              aciklama: 'Kullanmadığınız eşyaları\nbaşkalarıyla paylaşın',
              ikon: Icons.volunteer_activism,
              arkaPlanRengi: const Color(0xFFE8F5E9), // Açık yeşil tonu
              ikonRengi: const Color(0xFF2E7D32),
            ),
            
            const SizedBox(height: 24),
            
            // İhtiyaç İlanı Oluştur Kartı
            _buildSecimKarti(
              context: context,
              baslik: 'İhtiyaç İlanı Oluştur',
              aciklama: 'İhtiyacınız olan eşyaları\ntalep edin.',
              ikon: Icons.clean_hands_outlined, // Figma'daki ikona benzer bir ikon
              arkaPlanRengi: const Color(0xFFF3E5F5), // Açık mor/pembe tonu
              ikonRengi: const Color(0xFF8E24AA),
            ),
          ],
        ),
      ),
    );
  }

  // Tıklanabilir Seçim Kartı Şablonu
  Widget _buildSecimKarti({
    required BuildContext context,
    required String baslik,
    required String aciklama,
    required IconData ikon,
    required Color arkaPlanRengi,
    required Color ikonRengi,
  }) {
    return GestureDetector(
      onTap: () {
        // Tıklanınca ilgili form sayfasına gidecek (İleride eklenecek)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$baslik seçildi!')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: arkaPlanRengi,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(ikon, size: 40, color: ikonRengi),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    aciklama,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Ücretsiz',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}