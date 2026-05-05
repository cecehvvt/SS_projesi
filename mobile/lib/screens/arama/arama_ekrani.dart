import 'package:flutter/material.dart';
import '../../constants/renkler.dart';
import '../../models/ilan_model.dart';

class AramaEkrani extends StatefulWidget {
  final IlanTuru baslangicTuru;

  const AramaEkrani({
    super.key,
    this.baslangicTuru = IlanTuru.bagis,
  });

  @override
  State<AramaEkrani> createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  late IlanTuru _aktifTur;
  final TextEditingController _aramaController = TextEditingController();
  bool _sadeceBagisladiklarim = false;

  final List<IlanModel> _ilanlar = _ornekIlanlar();

  @override
  void initState() {
    super.initState();
    _aktifTur = widget.baslangicTuru;
  }

  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  List<IlanModel> get _filtrelenmisIlanlar {
    return _ilanlar.where((ilan) {
      if (ilan.ilanTuru != _aktifTur) return false;
      final sorgu = _aramaController.text.toLowerCase();
      if (sorgu.isNotEmpty) {
        return ilan.baslik.toLowerCase().contains(sorgu) ||
            ilan.kategori.ad.toLowerCase().contains(sorgu) ||
            ilan.konum.toLowerCase().contains(sorgu);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.arkaplan,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildAramaVeFiltre(),
          _buildTabBar(),
          Expanded(
            child: _filtrelenmisIlanlar.isEmpty
                ? _buildBosHal()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _filtrelenmisIlanlar.length,
                    itemBuilder: (context, index) {
                      return _IlanKarti(
                        ilan: _filtrelenmisIlanlar[index],
                        onTalepYardimEt: () =>
                            _talepYardimEt(_filtrelenmisIlanlar[index]),
                        onFavoriToggle: () =>
                            _favoriToggle(_filtrelenmisIlanlar[index]),
                        onKartTap: () =>
                            _ilanDetayAc(_filtrelenmisIlanlar[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Renkler.headerTeal,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Renkler.metinKoyu),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        _aktifTur == IlanTuru.bagis ? 'Bağışlananlar' : 'İhtiyaçlar',
        style: const TextStyle(
          color: Renkler.metinKoyu,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAramaVeFiltre() {
    return Container(
      color: Renkler.headerTeal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _aramaController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Ara(ürün,başlık,kategori,konum)',
                  hintStyle: TextStyle(
                    color: Renkler.metinAcik,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: Renkler.metinAcik, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _filtreAc,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune, size: 18, color: Renkler.metinOrta),
                  SizedBox(width: 4),
                  Text(
                    'Filtrele',
                    style: TextStyle(
                      fontSize: 13,
                      color: Renkler.metinOrta,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    if (_aktifTur == IlanTuru.bagis) {
      return _buildBagisTablari();
    } else {
      return _buildIhtiyacTablari();
    }
  }

  Widget _buildBagisTablari() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _TabButon(
            etiket: 'Tümü',
            ikon: Icons.grid_view,
            aktif: !_sadeceBagisladiklarim,
            onTap: () => setState(() => _sadeceBagisladiklarim = false),
          ),
          const SizedBox(width: 8),
          _TabButon(
            etiket: 'Bağışladıklarım',
            ikon: Icons.favorite_border,
            aktif: _sadeceBagisladiklarim,
            onTap: () => setState(() => _sadeceBagisladiklarim = true),
          ),
        ],
      ),
    );
  }

  Widget _buildIhtiyacTablari() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _TabButonGenis(
              etiket: 'İhtiyaçlar',
              aktif: _aktifTur == IlanTuru.ihtiyac,
              onTap: () => setState(() => _aktifTur = IlanTuru.ihtiyac),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabButonGenis(
              etiket: 'Bağışlananlar',
              aktif: _aktifTur == IlanTuru.bagis,
              onTap: () => setState(() => _aktifTur = IlanTuru.bagis),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBosHal() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Renkler.metinAcik),
          SizedBox(height: 12),
          Text(
            'Sonuç bulunamadı',
            style: TextStyle(color: Renkler.metinAcik, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _filtreAc() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _FiltreBottomSheet(),
    );
  }

  void _talepYardimEt(IlanModel ilan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ilan.ilanTuru == IlanTuru.bagis
              ? '"${ilan.baslik}" için talep gönderildi.'
              : '"${ilan.baslik}" için yardım teklifi gönderildi.',
        ),
        backgroundColor: Renkler.primary,
      ),
    );
  }

  void _favoriToggle(IlanModel ilan) {
    setState(() {
      final index = _ilanlar.indexWhere((i) => i.id == ilan.id);
      if (index != -1) {
        _ilanlar[index] =
            _ilanlar[index].copyWith(favorilendi: !ilan.favorilendi);
      }
    });
  }

  void _ilanDetayAc(IlanModel ilan) {
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (_) => IlanDetayEkrani(ilanId: ilan.id!),
    // ));
  }
}

// ── İlan Kartı ───────────────────────────────

class _IlanKarti extends StatelessWidget {
  final IlanModel ilan;
  final VoidCallback onTalepYardimEt;
  final VoidCallback onFavoriToggle;
  final VoidCallback onKartTap;

  const _IlanKarti({
    required this.ilan,
    required this.onTalepYardimEt,
    required this.onFavoriToggle,
    required this.onKartTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onKartTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Renkler.kartArkaplan,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FotoAlani(ilan: ilan),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _KategoriChip(kategori: ilan.kategori),
                        GestureDetector(
                          onTap: onFavoriToggle,
                          child: Icon(
                            ilan.favorilendi
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: ilan.favorilendi
                                ? Renkler.kalpIkonDolu
                                : Renkler.kalpIkon,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ilan.baslik,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Renkler.metinKoyu,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ilan.aciklama,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Renkler.metinOrta,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 13, color: Renkler.metinAcik),
                        const SizedBox(width: 3),
                        Text(
                          ilan.ilanSahibiAdSoyad,
                          style: const TextStyle(
                              fontSize: 11, color: Renkler.metinAcik),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Renkler.metinAcik),
                        const SizedBox(width: 3),
                        Text(
                          ilan.konum,
                          style: const TextStyle(
                              fontSize: 11, color: Renkler.metinAcik),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 13, color: Renkler.metinAcik),
                            const SizedBox(width: 3),
                            Text(
                              ilan.zamanOnce,
                              style: const TextStyle(
                                  fontSize: 11, color: Renkler.metinAcik),
                            ),
                          ],
                        ),
                        _TalepButonu(
                          tur: ilan.ilanTuru,
                          onTap: onTalepYardimEt,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fotoğraf Alanı ───────────────────────────

class _FotoAlani extends StatelessWidget {
  final IlanModel ilan;
  const _FotoAlani({required this.ilan});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 130,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: ilan.kapakFoto != null
                ? Image.network(
                    ilan.kapakFoto!,
                    width: 110,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _FotoPlaceholder(),
                  )
                : _FotoPlaceholder(),
          ),
          if (ilan.acilMi)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Renkler.acilBadge,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ACİL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 8,
            left: 6,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Renkler.uzaklikBadge.withOpacity(0.75),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '6 km',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 130,
      color: Renkler.inputArkaplan,
      child: const Icon(Icons.image_outlined, size: 36, color: Renkler.metinAcik),
    );
  }
}

// ── Kategori Chip ────────────────────────────

class _KategoriChip extends StatelessWidget {
  final IlanKategori kategori;
  const _KategoriChip({required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Renkler.primaryAcik,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        kategori.ad,
        style: const TextStyle(
          color: Renkler.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Talep / Yardım Butonu ────────────────────

class _TalepButonu extends StatelessWidget {
  final IlanTuru tur;
  final VoidCallback onTap;

  const _TalepButonu({required this.tur, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Renkler.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tur == IlanTuru.bagis ? 'Talep Et' : 'Yardım Et',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Tab Butonları ────────────────────────────

class _TabButon extends StatelessWidget {
  final String etiket;
  final IconData ikon;
  final bool aktif;
  final VoidCallback onTap;

  const _TabButon({
    required this.etiket,
    required this.ikon,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: aktif ? Renkler.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: aktif ? null : Border.all(color: Renkler.bolucuCizgi),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon,
                size: 16, color: aktif ? Colors.white : Renkler.metinOrta),
            const SizedBox(width: 4),
            Text(
              etiket,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: aktif ? Colors.white : Renkler.metinOrta,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButonGenis extends StatelessWidget {
  final String etiket;
  final bool aktif;
  final VoidCallback onTap;

  const _TabButonGenis({
    required this.etiket,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: aktif ? Renkler.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: aktif ? null : Border.all(color: Renkler.bolucuCizgi),
        ),
        child: Center(
          child: Text(
            etiket,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : Renkler.metinOrta,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Filtre Bottom Sheet ──────────────────────

class _FiltreBottomSheet extends StatefulWidget {
  const _FiltreBottomSheet();

  @override
  State<_FiltreBottomSheet> createState() => _FiltreBottomSheetState();
}

class _FiltreBottomSheetState extends State<_FiltreBottomSheet> {
  IlanKategori? _seciliKategori;
  bool _sadaceAcil = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrele',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Renkler.metinKoyu,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Kategori',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Renkler.metinOrta)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IlanKategori.values
                .where((k) => k != IlanKategori.tumu)
                .map((k) => ChoiceChip(
                      label: Text(k.ad),
                      selected: _seciliKategori == k,
                      selectedColor: Renkler.primaryAcik,
                      labelStyle: TextStyle(
                        color: _seciliKategori == k
                            ? Renkler.primary
                            : Renkler.metinOrta,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() =>
                          _seciliKategori =
                              _seciliKategori == k ? null : k),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sadece Acil İlanlar',
                  style: TextStyle(
                      fontSize: 14, color: Renkler.metinOrta)),
              Switch(
                value: _sadaceAcil,
                onChanged: (v) => setState(() => _sadaceAcil = v),
                activeThumbColor: Renkler.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Renkler.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Uygula',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Örnek Veriler ────────────────────────────

List<IlanModel> _ornekIlanlar() => [
      IlanModel(
        id: '1',
        ilanSahibiId: 'u1',
        ilanSahibiAdSoyad: 'Zeynep Ş.',
        ilanTuru: IlanTuru.bagis,
        baslik: 'Bebek Arabası',
        aciklama: 'Az kullanılmış, temizdir. İhtiyacı olan bir aileye vermek istiyorum.',
        kategori: IlanKategori.bebekCocuk,
        urunDurumu: UrunDurumu.azKullanilmis,
        adet: 1,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 7)),
        konum: 'Üsküdar, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      IlanModel(
        id: '2',
        ilanSahibiId: 'u2',
        ilanSahibiAdSoyad: 'Ali B.',
        ilanTuru: IlanTuru.bagis,
        baslik: 'Çalışma Masası',
        aciklama: 'Temiz ve sağlamdır. İhtiyacı sahibine vermek istiyorum.',
        kategori: IlanKategori.evYasam,
        adet: 1,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 5)),
        konum: 'Beyoğlu, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      IlanModel(
        id: '3',
        ilanSahibiId: 'u3',
        ilanSahibiAdSoyad: 'Yusuf E.',
        ilanTuru: IlanTuru.bagis,
        baslik: 'Kışlık Mont',
        aciklama: 'Kışlık mont ihtiyacım var. Bedeni M veya L olabilir.',
        kategori: IlanKategori.giyimAyakkabi,
        adet: 1,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 3)),
        konum: 'Beyoğlu, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      IlanModel(
        id: '4',
        ilanSahibiId: 'u4',
        ilanSahibiAdSoyad: 'Mehmet Ş.',
        ilanTuru: IlanTuru.ihtiyac,
        baslik: 'Bebek Bezi',
        aciklama: 'Yeni doğan bebeğim için 2 numara bebek bezine ihtiyacım var.',
        kategori: IlanKategori.bebekCocuk,
        adet: 3,
        acilMi: true,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 1)),
        konum: 'Üsküdar, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      IlanModel(
        id: '5',
        ilanSahibiId: 'u5',
        ilanSahibiAdSoyad: 'Arda B.',
        ilanTuru: IlanTuru.ihtiyac,
        baslik: 'Elektrikli Isıtıcı',
        aciklama: 'Kış ayları için ısınma ihtiyacım var. Çalışır durumda olursa çok sevinirim.',
        kategori: IlanKategori.evYasam,
        adet: 1,
        acilMi: true,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 2)),
        konum: 'Beyoğlu, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      IlanModel(
        id: '6',
        ilanSahibiId: 'u6',
        ilanSahibiAdSoyad: 'Yusuf E.',
        ilanTuru: IlanTuru.ihtiyac,
        baslik: 'İkinci El Telefon',
        aciklama: 'Sağlamdır. İhtiyacı sahibine vermek istiyorum.',
        kategori: IlanKategori.elektronik,
        adet: 1,
        acilBitisTarihi: DateTime.now().add(const Duration(days: 4)),
        konum: 'Beyoğlu, İstanbul',
        olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];