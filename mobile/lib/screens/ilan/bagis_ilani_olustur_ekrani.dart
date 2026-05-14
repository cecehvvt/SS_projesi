import 'package:flutter/material.dart';
import '../../widgets/alt_menu.dart'; // Alt menüyü çağırdık

class BagisIlaniOlusturEkrani extends StatefulWidget {
  const BagisIlaniOlusturEkrani({super.key});

  @override
  State<BagisIlaniOlusturEkrani> createState() => _BagisIlaniOlusturEkraniState();
}

class _BagisIlaniOlusturEkraniState extends State<BagisIlaniOlusturEkrani> {
  int adet = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Bağış İlanı Oluştur", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTOĞRAF ALANI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ürün Fotoğrafları *", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                  child: const Text("Fotoğraf İpuçları", style: TextStyle(color: Color(0xFF2E7D32), fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 4),
            const Text("En az bir fotoğraf ekleyin", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                _fotoKutusu("assets/images/ilanlar/bez.png", true), // Örnek dolu kutu
                const SizedBox(width: 8),
                _fotoKutusu("", false), // Örnek boş kutu
                const SizedBox(width: 8),
                _fotografEkleKutusu(),
              ],
            ),
            const SizedBox(height: 4),
            const Text("Maksimum 5 fotoğraf ekleyebilirsiniz.", style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 20),

            // BAŞLIK VE AÇIKLAMA
            const Text("Başlık *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _metinKutusu("Bebek Bezi (2 Numara)"),
            const Align(alignment: Alignment.centerRight, child: Text("21/60", style: TextStyle(color: Colors.grey, fontSize: 10))),
            const SizedBox(height: 12),

            const Text("Açıklama *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _metinKutusu("Yeni doğan bebeğim için 2 numara bebek bezine ihtiyacım var. Elimde şuan hiç bez kalmadı. Yardımcı olabilecek olanlar ulaşabilir.", satir: 4),
            const Align(alignment: Alignment.centerRight, child: Text("111/500", style: TextStyle(color: Colors.grey, fontSize: 10))),
            const SizedBox(height: 16),

            // KATEGORİ VE DURUM
            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Kategori *", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _secimKutusu(Icons.child_care, "Bebek & Çocuk", Colors.orange.shade100),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Ürün Durumu *", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _secimKutusu(Icons.verified_outlined, "Yeni / Açılmamış", Colors.grey.shade200),
                ])),
              ],
            ),
            const SizedBox(height: 16),

            // ADET
            const Text("Adet *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (adet > 1) adet--; })),
                      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Text("$adet", style: const TextStyle(fontWeight: FontWeight.bold))),
                      IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { adet++; })),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text("1 paket (80 adet)", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),

            // KONUM VE GÜVENLİ PAYLAŞIM
            const Text("Konum *", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
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
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined, color: Color(0xFF2E7D32), size: 30),
                  SizedBox(width: 12),
                  Expanded(child: Text("Güvenli Paylaşım\nKişisel bilgilerinizi koruyoruz. İletişim uygulama içi mesajlaşma üzerinden güvenli şekilde sağlanır.", style: TextStyle(fontSize: 10))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // KAYDET BUTONU
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009F3C), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Kaydet", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const VestaAltMenu(),
    );
  }

  Widget _metinKutusu(String metin, {int satir = 1}) {
    return TextField(
      maxLines: satir,
      controller: TextEditingController(text: metin),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _secimKutusu(IconData ikon, String metin, Color ikonBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: ikonBg, shape: BoxShape.circle), child: Icon(ikon, size: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(metin, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _fotoKutusu(String yol, bool dolu) {
    return Container(
      width: 70, height: 70,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12), color: Colors.grey.shade100),
      child: dolu ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(yol, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image))) : null,
    );
  }

  Widget _fotografEkleKutusu() {
    return Container(
      width: 70, height: 70,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.camera_alt_outlined, color: Color(0xFF2E7D32)),
          SizedBox(height: 4),
          Text("Fotoğraf Ekle", style: TextStyle(fontSize: 8, color: Color(0xFF2E7D32))),
        ],
      ),
    );
  }
}