import 'package:flutter/material.dart';

class IlanDetayEkrani extends StatelessWidget {
  const IlanDetayEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim Alanı ve Üst Butonlar
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  // Gerçek resimler gelene kadar burası gri kutu olarak kalacak
                  child: const Icon(Icons.image_outlined, size: 60, color: Colors.grey),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                            onPressed: () {
                              // Geri dönme işlemi
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.black, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori Etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4EAE2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Bebek & Çocuk', 
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Başlık ve Aciliyet Etiketi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Bebek Bezi', 
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.alarm, color: Colors.red, size: 14),
                            SizedBox(width: 4),
                            Text('Acil', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // İlan Açıklaması
                  const Text(
                    'Yeni doğan bebeğim için 2 numara bebek bezine ihtiyacım var. Elimde şu an hiç bez kalmadı. Yardımcı olabilecek olanlar ulaşabilir.',
                    style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  
                  // Konum ve Zaman Bilgisi
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                      SizedBox(width: 4),
                      Text('Üsküdar, İstanbul', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 18, color: Colors.black54),
                      SizedBox(width: 4),
                      Text('3 saat önce', style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                  
                  const Divider(height: 32),
                  
                  // Kullanıcı Profili Kartı
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFD4EAE2),
                          child: Icon(Icons.person, color: Colors.teal),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('İhtiyaç Sahibi', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text('Rabia C.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                        const Icon(Icons.verified_user, color: Colors.green),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Temsili Harita Kutusu
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.map, color: Colors.blue, size: 30),
                        SizedBox(height: 8),
                        Text('Harita Konumu (Temsili)', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Ekranın Altında Sabit Kalan Butonlar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651), // VESTA yeşili
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
                  label: const Text('Yardım Et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 20),
                  label: const Text('Mesaj Gönder', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}