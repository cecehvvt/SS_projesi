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
            // ÜST RESİM VE İKONLAR (Geri ve Favori)
            Stack(
              children: [
                // Ürün Resmi
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.asset(
                    'assets/images/ilanlar/mont2.png', // Anasayfadaki mont resmi
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                // Geri Butonu
                Positioned(
                  top: 50,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
                    ),
                  ),
                ),
                // Favori Butonu
                Positioned(
                  top: 50,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, size: 20, color: Colors.black87),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ETİKETLER (Bağışlanan Ürün, Kadın Giyim)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Bağışlanan Ürün', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: const [
                            Icon(Icons.checkroom, size: 14, color: Colors.black87),
                            SizedBox(width: 4),
                            Text('Kadın Giyim', style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // BAŞLIK VE AÇIKLAMA
                  const Text('Kışlık Mont', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Kahverengi kışlık mont. Çok az kullanıldı, temiz ve sorunsuzdur. Bedeni M uyumludur.',
                    style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  
                  // BİLGİ SATIRI (Konum, Saat, Görüntülenme)
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('Üsküdar, İstanbul', style: TextStyle(fontSize: 11, color: Colors.black54)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('3 saat önce', style: TextStyle(fontSize: 11, color: Colors.black54)),
                      const SizedBox(width: 12),
                      const Icon(Icons.visibility_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text('56 görüntüleme', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // KULLANICI BİLGİ KARTI
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bağışlayan Kişi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(radius: 20, backgroundColor: Color(0xFFF0F0F0), child: Icon(Icons.person, color: Colors.grey)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Ahmet Y.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: const [
                                      Icon(Icons.calendar_today, size: 10, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text('Üyelik tarihi: Şubat 2026', style: TextStyle(fontSize: 10, color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: const [
                                      Icon(Icons.volunteer_activism, size: 10, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text('Bağışlanan ürün sayısı: 5', style: TextStyle(fontSize: 10, color: Colors.black54)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // GÜVENLİK ROZETLERİ
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFF3F0E6), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: const [
                              Icon(Icons.card_giftcard, size: 20, color: Colors.black87),
                              SizedBox(width: 8),
                              Expanded(child: Text("Ücretsiz Bağış\nBu ürün tamamen ücretsizdir.", style: TextStyle(fontSize: 9))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: const [
                              Icon(Icons.shield_outlined, size: 20, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(child: Text("Güvenli Teslimat\nKişisel bilgilerinizi koruyun.", style: TextStyle(fontSize: 9))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // KONUM HARİTASI
                  const Text('Konum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50, // Harita resmi yoksa mavi bir arka plan
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: [
                        // Eğer elinde harita.png varsa buraya Image.asset ekleyebilirsin
                        const Center(child: Icon(Icons.map_outlined, size: 40, color: Colors.blue)),
                        Positioned(
                          bottom: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                            child: Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Üsküdar, İstanbul', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                    Text('(Yaklaşık 1.2 km)', style: TextStyle(fontSize: 9, color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Butonlar için alttan boşluk
                ],
              ),
            ),
          ],
        ),
      ),
      
      // ALTTAKİ SABİT BUTONLAR (Mesaj Gönder & Sepete Ekle)
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(Icons.info_outline, size: 14, color: Colors.green),
                SizedBox(width: 4),
                Text('İlgileniyorsanız bağışlayan kişiyle mesajlaşarak iletişime geçebilirsiniz.', style: TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Buradan Sohbet Ekranına Gidecek
                      Navigator.pushNamed(context, '/sohbet');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009F3C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                    label: const Text('Mesaj Gönder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.bookmark_border, color: Colors.black87, size: 18),
                    label: const Text('Sepete Ekle', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}