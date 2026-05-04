enum IlanTuru {
  bagis,
  ihtiyac,
}

extension IlanTuruExtension on IlanTuru {
  String get ad {
    switch (this) {
      case IlanTuru.bagis:
        return 'Bağış İlanı';
      case IlanTuru.ihtiyac:
        return 'İhtiyaç İlanı';
    }
  }
}

// ─────────────────────────────────────────────
// Kategori (sayfa 21 – kategori seçim grid'i)
// ─────────────────────────────────────────────
enum IlanKategori {
  bebekCocuk,
  giyimAyakkabi,
  elektronik,
  evYasam,
  kitapKirtasiye,
  tumu,
}

extension IlanKategoriExtension on IlanKategori {
  String get ad {
    switch (this) {
      case IlanKategori.bebekCocuk:
        return 'Bebek & Çocuk';
      case IlanKategori.giyimAyakkabi:
        return 'Giyim & Ayakkabı';
      case IlanKategori.elektronik:
        return 'Elektronik';
      case IlanKategori.evYasam:
        return 'Ev & Yaşam';
      case IlanKategori.kitapKirtasiye:
        return 'Kitap & Kırtasiye';
      case IlanKategori.tumu:
        return 'Tümü';
    }
  }

  String get ikonYolu {
    switch (this) {
      case IlanKategori.bebekCocuk:
        return 'assets/icons/bebek_cocuk.png';
      case IlanKategori.giyimAyakkabi:
        return 'assets/icons/giyim_ayakkabi.png';
      case IlanKategori.elektronik:
        return 'assets/icons/elektronik.png';
      case IlanKategori.evYasam:
        return 'assets/icons/ev_yasam.png';
      case IlanKategori.kitapKirtasiye:
        return 'assets/icons/kitap_kirtasiye.png';
      case IlanKategori.tumu:
        return 'assets/icons/tumu.png';
    }
  }
}

// ─────────────────────────────────────────────
// Ürün Durumu (sayfa 20 – dropdown)
// ─────────────────────────────────────────────
enum UrunDurumu {
  yeniAcilmamis,
  azKullanilmis,
  ikinciEl,
}

extension UrunDurumuExtension on UrunDurumu {
  String get ad {
    switch (this) {
      case UrunDurumu.yeniAcilmamis:
        return 'Yeni / Açılmamış';
      case UrunDurumu.azKullanilmis:
        return 'Az Kullanılmış';
      case UrunDurumu.ikinciEl:
        return 'İkinci El';
    }
  }
}

// ─────────────────────────────────────────────
// Ana model
// ─────────────────────────────────────────────
class IlanModel {
  final String? id;
  final String ilanSahibiId;
  final String ilanSahibiAdSoyad; // liste kartlarında gösterilir (Zeynep Ş.)

  // Sayfa 19: Tür seçimi
  final IlanTuru ilanTuru;

  // Sayfa 20-21: Form
  final List<String> fotografUrls; // maks 5 fotoğraf
  final String baslik;
  final String aciklama;
  final IlanKategori kategori;
  final UrunDurumu? urunDurumu; // yalnızca bağış ilanında
  final int adet;
  final DateTime acilBitisTarihi;
  final String konum; // "Üsküdar, İstanbul"
  final bool gizliPaylasim;

  // Sayfa 14-15: Liste
  final bool acilMi; // ACİL badge
  final bool favorilendi; // kalp ikonu
  final DateTime olusturmaTarihi;
  final bool aktif;

  IlanModel({
    this.id,
    required this.ilanSahibiId,
    required this.ilanSahibiAdSoyad,
    required this.ilanTuru,
    this.fotografUrls = const [],
    required this.baslik,
    required this.aciklama,
    required this.kategori,
    this.urunDurumu,
    required this.adet,
    required this.acilBitisTarihi,
    required this.konum,
    this.gizliPaylasim = false,
    this.acilMi = false,
    this.favorilendi = false,
    DateTime? olusturmaTarihi,
    this.aktif = true,
  }) : olusturmaTarihi = olusturmaTarihi ?? DateTime.now();

  // ── Hesaplanan alanlar ──────────────────────

  /// "5 saat önce" formatında zaman
  String get zamanOnce {
    final fark = DateTime.now().difference(olusturmaTarihi);
    if (fark.inMinutes < 60) return '${fark.inMinutes} dakika önce';
    if (fark.inHours < 24) return '${fark.inHours} saat önce';
    return '${fark.inDays} gün önce';
  }

  /// İlk fotoğraf (liste kartı kapağı)
  String? get kapakFoto => fotografUrls.isNotEmpty ? fotografUrls.first : null;

  // ── copyWith ────────────────────────────────

  IlanModel copyWith({
    String? id,
    String? ilanSahibiId,
    String? ilanSahibiAdSoyad,
    IlanTuru? ilanTuru,
    List<String>? fotografUrls,
    String? baslik,
    String? aciklama,
    IlanKategori? kategori,
    UrunDurumu? urunDurumu,
    int? adet,
    DateTime? acilBitisTarihi,
    String? konum,
    bool? gizliPaylasim,
    bool? acilMi,
    bool? favorilendi,
    DateTime? olusturmaTarihi,
    bool? aktif,
  }) =>
      IlanModel(
        id: id ?? this.id,
        ilanSahibiId: ilanSahibiId ?? this.ilanSahibiId,
        ilanSahibiAdSoyad: ilanSahibiAdSoyad ?? this.ilanSahibiAdSoyad,
        ilanTuru: ilanTuru ?? this.ilanTuru,
        fotografUrls: fotografUrls ?? this.fotografUrls,
        baslik: baslik ?? this.baslik,
        aciklama: aciklama ?? this.aciklama,
        kategori: kategori ?? this.kategori,
        urunDurumu: urunDurumu ?? this.urunDurumu,
        adet: adet ?? this.adet,
        acilBitisTarihi: acilBitisTarihi ?? this.acilBitisTarihi,
        konum: konum ?? this.konum,
        gizliPaylasim: gizliPaylasim ?? this.gizliPaylasim,
        acilMi: acilMi ?? this.acilMi,
        favorilendi: favorilendi ?? this.favorilendi,
        olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
        aktif: aktif ?? this.aktif,
      );

  // ── JSON ────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'ilanSahibiId': ilanSahibiId,
        'ilanSahibiAdSoyad': ilanSahibiAdSoyad,
        'ilanTuru': ilanTuru.name,
        'fotografUrls': fotografUrls,
        'baslik': baslik,
        'aciklama': aciklama,
        'kategori': kategori.name,
        'urunDurumu': urunDurumu?.name,
        'adet': adet,
        'acilBitisTarihi': acilBitisTarihi.toIso8601String(),
        'konum': konum,
        'gizliPaylasim': gizliPaylasim,
        'acilMi': acilMi,
        'favorilendi': favorilendi,
        'olusturmaTarihi': olusturmaTarihi.toIso8601String(),
        'aktif': aktif,
      };

  factory IlanModel.fromJson(Map<String, dynamic> json) => IlanModel(
        id: json['id'] as String?,
        ilanSahibiId: json['ilanSahibiId'] as String,
        ilanSahibiAdSoyad: json['ilanSahibiAdSoyad'] as String,
        ilanTuru: IlanTuru.values.firstWhere(
          (t) => t.name == json['ilanTuru'],
          orElse: () => IlanTuru.bagis,
        ),
        fotografUrls: List<String>.from(json['fotografUrls'] ?? []),
        baslik: json['baslik'] as String,
        aciklama: json['aciklama'] as String,
        kategori: IlanKategori.values.firstWhere(
          (k) => k.name == json['kategori'],
          orElse: () => IlanKategori.tumu,
        ),
        urunDurumu: json['urunDurumu'] != null
            ? UrunDurumu.values.firstWhere(
                (u) => u.name == json['urunDurumu'],
                orElse: () => UrunDurumu.ikinciEl,
              )
            : null,
        adet: json['adet'] as int,
        acilBitisTarihi: DateTime.parse(json['acilBitisTarihi'] as String),
        konum: json['konum'] as String,
        gizliPaylasim: json['gizliPaylasim'] as bool? ?? false,
        acilMi: json['acilMi'] as bool? ?? false,
        favorilendi: json['favorilendi'] as bool? ?? false,
        olusturmaTarihi: DateTime.parse(json['olusturmaTarihi'] as String),
        aktif: json['aktif'] as bool? ?? true,
      );
}