import 'package:flutter/material.dart';

class FiltreEkrani extends StatefulWidget {
  const FiltreEkrani({super.key});

  @override
  State<FiltreEkrani> createState() => _FiltreEkraniState();
}

class _FiltreEkraniState extends State<FiltreEkrani> {
  double _mesafe = 15.0; // Varsayılan mesafe
  bool _sadeceFotografli = false;
  bool _iletisimeGecilenleriGizle = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Ekranın %90'ını kaplasın
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ÜST BAR (Sürükleme çizgisi, Geri, Başlık, Temizle)
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text("Filtrele", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text("Temizle", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 15)),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BİLGİ KUTUSU
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), shape: BoxShape.circle),
                        child: const Icon(Icons.filter_list, color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text("İhtiyaçlarınıza uygun ilanları\nkolayca bulabilirsiniz.", style: TextStyle(color: Colors.black87, fontSize: 13)),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // KATEGORİ BÖLÜMÜ
                  const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 10,
                    children: [
                      _kategoriButonu("Kadın Giyim", Icons.checkroom),
                      _kategoriButonu("Erkek Giyim", Icons.accessibility_new),
                      _kategoriButonu("Bebek&Çocuk", Icons.child_care),
                      _kategoriButonu("Elektronik", Icons.tv),
                      _kategoriButonu("Ev & Yaşam", Icons.home_outlined),
                      _kategoriButonu("Kitap&Kırtasiye", Icons.menu_book),
                      _kategoriButonu("Diğer", Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ACİLİYET BÖLÜMÜ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Aciliyet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("(Sadece ihtiyaçlar için)", style: TextStyle(fontSize: 12, color: Colors.black54)),
                      Icon(Icons.info, size: 18, color: Colors.black87)
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _aciliyetButonu("Acil", Icons.error_outline, const Color(0xFFFFEBEE), const Color(0xFFD32F2F)),
                      const SizedBox(width: 8),
                      _aciliyetButonu("Orta", Icons.access_time, const Color(0xFFFFF8E1), const Color(0xFFF57F17)),
                      const SizedBox(width: 8),
                      _aciliyetButonu("Normal", Icons.check_circle_outline, const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // MESAFE (SLIDER) BÖLÜMÜ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("0 km", style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text("${_mesafe.toInt()} km", style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 15)),
                      const Text("50 km", style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF2E7D32),
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFF2E7D32),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _mesafe,
                      min: 0,
                      max: 50,
                      onChanged: (value) => setState(() => _mesafe = value),
                    ),
                  ),
                  const Text("Seçtiğiniz konuma 15 km çevresindeki ilanlar gösterilecek.", style: TextStyle(fontSize: 11, color: Colors.black87)),
                  const SizedBox(height: 24),

                  // KONUM BÖLÜMÜ
                  const Text("Konum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.black87),
                        const SizedBox(width: 8),
                        const Expanded(child: Text("İstanbul, Türkiye", style: TextStyle(fontSize: 14))),
                        Text("Değiştir", style: TextStyle(color: const Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black87),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // DİĞER FİLTRELER BÖLÜMÜ
                  const Text("Diğer Filtreler", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _filtreSecenegi("Sadece fotoğraflı ilanları göster.", _sadeceFotografli, (val) => setState(() => _sadeceFotografli = val!)),
                  const SizedBox(height: 8),
                  _filtreSecenegi("Daha önce iletişime geçtiğim ilanları gizle.", _iletisimeGecilenleriGizle, (val) => setState(() => _iletisimeGecilenleriGizle = val!)),
                  const SizedBox(height: 30),

                  // ALT BUTONLAR
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009F3C),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.filter_list, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text("Filtreleri Uygula (3)", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFF009F3C)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("İptal", style: TextStyle(color: Color(0xFF009F3C), fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kategori Butonu Tasarımı
  Widget _kategoriButonu(String baslik, IconData ikon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(baslik, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Aciliyet Butonu Tasarımı
  Widget _aciliyetButonu(String baslik, IconData ikon, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Text(baslik, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Checkbox Tasarımı
  Widget _filtreSecenegi(String metin, bool deger, Function(bool?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.black87),
        child: CheckboxListTile(
          value: deger,
          onChanged: onChanged,
          title: Text(metin, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          activeColor: const Color(0xFF2E7D32),
        ),
      ),
    );
  }
}