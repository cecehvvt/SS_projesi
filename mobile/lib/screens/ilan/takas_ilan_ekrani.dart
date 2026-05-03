import 'package:flutter/material.dart';

class TakasIlanEkrani extends StatelessWidget {
  const TakasIlanEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
          'Takas (Değiş-Tokuş)',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama Çubuğu
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Ne ile takas yapmak istiyorsun ?',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Takas İlanları Listesi
            Expanded(
              child: ListView(
                children: [
                  _buildTakasKarti(
                    urunAdi: 'Bebek Bezi (2 Numara)',
                    istenenUrun: 'Kitap / Temizlik',
                    konum: 'Üsküdar, İstanbul',
                    durum: 'Aktif',
                  ),
                  const SizedBox(height: 12),
                  _buildTakasKarti(
                    urunAdi: 'Kız Çocuk Mont',
                    istenenUrun: 'Ayakkabı / Spor Çanta',
                    konum: 'Beyoğlu, İstanbul',
                    durum: 'Aktif',
                  ),
                  const SizedBox(height: 12),
                  _buildTakasKarti(
                    urunAdi: 'Hikaye Kitapları',
                    istenenUrun: 'Masa Lambası / Dekorasyon',
                    konum: 'Kadıköy, İstanbul',
                    durum: 'Aktif',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Güvenli Takas Bilgi Kutusu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.green, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Güvenli Takas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                        SizedBox(height: 4),
                        Text(
                          'Kişisel bilgilerinizi koruyunuz. İletişim, uygulama içi mesajlaşma üzerinden güvenli şekilde sağlanır.',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Takas Kartı Tasarım Şablonu
  Widget _buildTakasKarti({
    required String urunAdi,
    required String istenenUrun,
    required String konum,
    required String durum,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Sol taraf resim (Placeholder)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Sağ taraf içerik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        urunAdi,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4EAE2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        durum,
                        style: const TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.swap_horiz, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    const Text('İstediği Ürün: ', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    Expanded(
                      child: Text(
                        istenenUrun,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Colors.black54),
                        const SizedBox(width: 2),
                        Text(konum, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 26),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Teklif Gönder', style: TextStyle(fontSize: 10, color: Colors.black87)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}