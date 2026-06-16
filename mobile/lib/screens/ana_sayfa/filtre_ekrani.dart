import 'package:flutter/material.dart';

enum FiltreTuru { ihtiyac, bagis }

class FiltreEkrani extends StatefulWidget {
  final FiltreTuru tur;

  const FiltreEkrani({super.key, this.tur = FiltreTuru.bagis});
  const FiltreEkrani.ihtiyac({super.key}) : tur = FiltreTuru.ihtiyac;
  const FiltreEkrani.bagis({super.key}) : tur = FiltreTuru.bagis;

  @override
  State<FiltreEkrani> createState() => _FiltreEkraniState();
}

class _FiltreEkraniState extends State<FiltreEkrani> {
  double _mesafe = 15.0;
  String? _ihtiyacKategorisi;
  String? _aciliyet;
  String? _ihtiyacDurumu;
  String? _urunTuru;
  String? _kondisyon;
  String? _uygunluk;

  bool get _ihtiyacFiltresi => widget.tur == FiltreTuru.ihtiyac;

  @override
  Widget build(BuildContext context) {
    final Color vurguRengi = _ihtiyacFiltresi
        ? const Color(0xFFD46A3A)
        : const Color(0xFF2E7D32);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  _ihtiyacFiltresi ? "İhtiyaç Filtreleri" : "Bağış Filtreleri",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _temizle,
                  child: Text(
                    "Temizle",
                    style: TextStyle(
                      color: vurguRengi,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bilgiKutusu(vurguRengi),
                  const SizedBox(height: 24),
                  if (_ihtiyacFiltresi)
                    ..._ihtiyacAlanlari(vurguRengi)
                  else
                    ..._bagisAlanlari(vurguRengi),
                  const SizedBox(height: 24),
                  _konumAlani(vurguRengi),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vurguRengi,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Filtreleri Uygula",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: vurguRengi),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "İptal",
                      style: TextStyle(
                        color: vurguRengi,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  Widget _bilgiKutusu(Color renk) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.filter_list, color: Colors.black87),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _ihtiyacFiltresi
                ? "İhtiyaç ilanlarını size uygun alanlarla filtreleyin."
                : "Bağış ilanlarını ürün bilgilerine göre filtreleyin.",
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ),
      ],
    );
  }

  List<Widget> _ihtiyacAlanlari(Color renk) {
    return [
      _secimBolumu(
        baslik: "İhtiyaç Kategorisi",
        seciliDeger: _ihtiyacKategorisi,
        renk: renk,
        secenekler: const [
          "Giyim",
          "Bebek & Çocuk",
          "Elektronik",
          "Ev & Yaşam",
          "Eğitim",
          "Diğer",
        ],
        onSelected: (deger) => setState(() => _ihtiyacKategorisi = deger),
      ),
      const SizedBox(height: 24),
      _secimBolumu(
        baslik: "Aciliyet",
        seciliDeger: _aciliyet,
        renk: renk,
        secenekler: const ["Acil", "Orta", "Normal"],
        onSelected: (deger) => setState(() => _aciliyet = deger),
      ),
      const SizedBox(height: 24),
      _secimBolumu(
        baslik: "Durum",
        seciliDeger: _ihtiyacDurumu,
        renk: renk,
        secenekler: const ["Açık", "Yardım bekliyor", "Karşılandı"],
        onSelected: (deger) => setState(() => _ihtiyacDurumu = deger),
      ),
    ];
  }

  List<Widget> _bagisAlanlari(Color renk) {
    return [
      _secimBolumu(
        baslik: "Ürün Türü",
        seciliDeger: _urunTuru,
        renk: renk,
        secenekler: const [
          "Giyim",
          "Bebek & Çocuk",
          "Elektronik",
          "Mobilya",
          "Kitap & Kırtasiye",
          "Diğer",
        ],
        onSelected: (deger) => setState(() => _urunTuru = deger),
      ),
      const SizedBox(height: 24),
      _secimBolumu(
        baslik: "Kondisyon",
        seciliDeger: _kondisyon,
        renk: renk,
        secenekler: const [
          "Yeni",
          "Az kullanılmış",
          "İyi",
          "Onarım gerekebilir",
        ],
        onSelected: (deger) => setState(() => _kondisyon = deger),
      ),
      const SizedBox(height: 24),
      _secimBolumu(
        baslik: "Uygunluk",
        seciliDeger: _uygunluk,
        renk: renk,
        secenekler: const ["Uygun", "Rezerve", "Teslim edildi"],
        onSelected: (deger) => setState(() => _uygunluk = deger),
      ),
    ];
  }

  Widget _secimBolumu({
    required String baslik,
    required String? seciliDeger,
    required Color renk,
    required List<String> secenekler,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: secenekler.map((secenek) {
            final bool secili = seciliDeger == secenek;
            return ChoiceChip(
              label: Text(secenek),
              selected: secili,
              onSelected: (_) => onSelected(secenek),
              selectedColor: renk.withValues(alpha: 0.18),
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: secili ? renk : Colors.black87,
                fontSize: 12,
                fontWeight: secili ? FontWeight.bold : FontWeight.w600,
              ),
              side: BorderSide(color: secili ? renk : Colors.grey.shade300),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _konumAlani(Color renk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Konum",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "0 km",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              "${_mesafe.toInt()} km",
              style: TextStyle(
                color: renk,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Text(
              "50 km",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: renk,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: renk,
            trackHeight: 6,
          ),
          child: Slider(
            value: _mesafe,
            min: 0,
            max: 50,
            onChanged: (value) => setState(() => _mesafe = value),
          ),
        ),
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
              const Expanded(
                child: Text(
                  "İstanbul, Türkiye",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Text(
                "Değiştir",
                style: TextStyle(
                  color: renk,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _temizle() {
    setState(() {
      _mesafe = 15.0;
      _ihtiyacKategorisi = null;
      _aciliyet = null;
      _ihtiyacDurumu = null;
      _urunTuru = null;
      _kondisyon = null;
      _uygunluk = null;
    });
  }
}
