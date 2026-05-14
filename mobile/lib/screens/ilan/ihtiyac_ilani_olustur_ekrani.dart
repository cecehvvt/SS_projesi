import 'package:flutter/material.dart';
import '../../widgets/alt_menu.dart';

class IhtiyacIlaniOlusturEkrani extends StatefulWidget {
  const IhtiyacIlaniOlusturEkrani({super.key});

  @override
  State<IhtiyacIlaniOlusturEkrani> createState() => _IhtiyacIlaniOlusturEkraniState();
}

class _IhtiyacIlaniOlusturEkraniState extends State<IhtiyacIlaniOlusturEkrani> {
  int adet = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("İhtiyaç İlanı Oluştur", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KATEGORİ SEÇİMİ
            const Text("Kategori Seçin *", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _kategoriDairesi(Icons.child_care, "Bebek & Çocuk", true),
                _kategoriDairesi(Icons.checkroom, "Giyim & Ayakkabı", false),
                _kategoriDairesi(Icons.phone_iphone, "Elektronik", false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _kategoriDairesi(Icons.chair_outlined, "Ev & Yaşam", false),
                _kategoriDairesi(Icons.edit, "Kitap & Kırtasiye", false),
                _kategoriDairesi(Icons.grid_view, "Tümü", false),
              ],
            ),
            const SizedBox(height: 24),

            // FORM ALANLARI
            const Text("İhtiyacım Olan Ürün *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _bosMetinKutusu("Örn: Bebek Bezi (2 Numara)"),
            const Align(alignment: Alignment.centerRight, child: Text("0/60", style: TextStyle(color: Colors.grey, fontSize: 10))),
            const SizedBox(height: 12),

            const Text("Açıklama *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _bosMetinKutusu("İhtiyacınızı daha detaylı anlatabilirsiniz...", satir: 4),
            const Align(alignment: Alignment.centerRight, child: Text("0/500", style: TextStyle(color: Colors.grey, fontSize: 10))),
            const SizedBox(height: 16),

            // ADET VE ACİLİYET
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Adet *", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (adet > 1) adet--; })),
                        Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text("$adet", style: const TextStyle(fontWeight: FontWeight.bold))),
                        IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { adet++; })),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("1 paket (80 adet)", style: TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
                ])),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Aciliyet Durumu *", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _aciliyetKutusu("Acil", Icons.alarm, const Color(0xFFFFCDD2), Colors.red),
                      const SizedBox(width: 4),
                      _aciliyetKutusu("Orta", Icons.access_time, Colors.transparent, Colors.black87),
                      const SizedBox(width: 4),
                      _aciliyetKutusu("Normal", Icons.calendar_today, Colors.transparent, Colors.black87),
                    ],
                  )
                ])),
              ],
            ),
            const SizedBox(height: 16),

            // KONUM VE BİLGİ (MOR)
            const Text("Konum *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.black87),
                  const SizedBox(width: 8),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text("Üsküdar, İstanbul", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Yaklaşık 1.2 km uzakta", style: TextStyle(color: Colors.green, fontSize: 10)),
                  ])),
                  const Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)), // Mor arka plan
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined, color: Colors.purple, size: 30),
                  SizedBox(width: 12),
                  Expanded(child: Text("Güvenli Paylaşım\nKişisel bilgilerinizi koruyoruz. İletişim uygulama içi mesajlaşma üzerinden güvenli şekilde sağlanır.", style: TextStyle(fontSize: 10))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // MOR KAYDET BUTONU
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Kaydet", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const VestaAltMenu(),
    );
  }

  Widget _kategoriDairesi(IconData ikon, String baslik, bool secili) {
    return Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: secili ? Colors.purple : Colors.grey.shade300, width: secili ? 2 : 1),
            color: secili ? const Color(0xFFF3E5F5) : Colors.white,
          ),
          child: Icon(ikon, color: secili ? Colors.purple : Colors.black87, size: 28),
        ),
        const SizedBox(height: 8),
        Text(baslik, style: TextStyle(fontSize: 10, color: secili ? Colors.purple : Colors.black87, fontWeight: secili ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _bosMetinKutusu(String hint, {int satir = 1}) {
    return TextField(
      maxLines: satir,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _aciliyetKutusu(String yazi, IconData ikon, Color bg, Color textKolor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: bg, border: Border.all(color: textKolor.withOpacity(0.5)), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(ikon, size: 14, color: textKolor),
          const SizedBox(width: 4),
          Text(yazi, style: TextStyle(fontSize: 10, color: textKolor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}