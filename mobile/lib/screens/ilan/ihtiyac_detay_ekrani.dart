import 'package:flutter/material.dart';

class IhtiyacDetayEkrani extends StatelessWidget {
  const IhtiyacDetayEkrani({super.key});

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
                    'assets/images/ilanlar/bez.png', // Senin klasöründeki bez resmi
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
                  // ETİKETLER (Bebek & Çocuk, Acil)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Bebek & Çocuk', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: const [
                            Icon(Icons.alarm, size: 12, color: Colors.red),
                            SizedBox(width: 4),
                            Text('Acil', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // BAŞLIK VE AÇIKLAMA
                  const Text('Bebek Bezi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Yeni doğan bebeğim için 2 numara bebek bezine ihtiyacım var. Elimde şu an hiç bez kalmadı. Yardımcı olabilecek olanlar ulaşabilir.',
                    style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  
                  // BİLGİ SATIRI (Konum, Saat)
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.black87),
                      SizedBox(width: 6),
                      Text('Üsküdar, İstanbul', style: TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 16, color: Colors.black87),
                      SizedBox(width: 6),
                      Text('3 saat önce', style: TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // KULLANICI BİLGİ SATIRI (Rabia C. ve İhtiyaç Sahibi Rozeti)
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.black87),
                      const SizedBox(width: 6),
                      const Text('Rabia C.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          border: Border.all(color: const Color(0xFF2E7D32)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Text('İhtiyaç Sahibi ', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.bold)),
                            Icon(Icons.check_circle, size: 12, color: Color(0xFF2E7D32)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // KONUM HARİTASI
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50, 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: [
                        const Center(child: Icon(Icons.map_outlined, size: 40, color: Colors.blue)),
                        Positioned(
                          top: 12, right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)]),
                            child: Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Konum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                    Text('Üsküdar, İstanbul', style: TextStyle(fontSize: 9, color: Colors.black87)),
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
                  const SizedBox(height: 16),

                  // GÜVENLİK İPUÇLARI
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FAF6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB2D3C2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.shield_outlined, color: Color(0xFF2E7D32), size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Güvenlik İpuçları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2E7D32))),
                              SizedBox(height: 4),
                              Text(
                                'Lütfen teslimat öncesi ve sırasında dikkatli olunuz. Kişisel bilgilerinizi paylaşmayınız.',
                                style: TextStyle(fontSize: 11, color: Colors.black87),
                              ),
                            ],
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
      
      // ALTTAKİ SABİT BUTONLAR (Yardım Et & Mesaj Gönder)
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Yardım etme işlemi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009F3C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.volunteer_activism, color: Colors.white, size: 18),
                label: const Text('Yardım Et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Sohbet Ekranına Gidecek
                  Navigator.pushNamed(context, '/sohbet');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.black87),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 18),
                label: const Text('Mesaj Gönder', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}