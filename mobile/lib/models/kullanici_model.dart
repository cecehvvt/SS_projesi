// ─────────────────────────────────────────────
// Gizlilik Ayarları (Profili Düzenle ekranı)
// ─────────────────────────────────────────────
class GizlilikAyarlari {
  final bool profilBaskalarinaGorunsun; // "Profil başkalarının görmesine izin ver"
  final bool mesajAlabilir;             // "Mesaj almayı etkinleştir"
  final bool konumuIlanlardaGoster;     // "Konumu ilanlarda göster"

  const GizlilikAyarlari({
    this.profilBaskalarinaGorunsun = true,
    this.mesajAlabilir = true,
    this.konumuIlanlardaGoster = false,
  });

  GizlilikAyarlari copyWith({
    bool? profilBaskalarinaGorunsun,
    bool? mesajAlabilir,
    bool? konumuIlanlardaGoster,
  }) =>
      GizlilikAyarlari(
        profilBaskalarinaGorunsun:
            profilBaskalarinaGorunsun ?? this.profilBaskalarinaGorunsun,
        mesajAlabilir: mesajAlabilir ?? this.mesajAlabilir,
        konumuIlanlardaGoster:
            konumuIlanlardaGoster ?? this.konumuIlanlardaGoster,
      );

  Map<String, dynamic> toJson() => {
        'profilBaskalarinaGorunsun': profilBaskalarinaGorunsun,
        'mesajAlabilir': mesajAlabilir,
        'konumuIlanlardaGoster': konumuIlanlardaGoster,
      };

  factory GizlilikAyarlari.fromJson(Map<String, dynamic> json) =>
      GizlilikAyarlari(
        profilBaskalarinaGorunsun:
            json['profilBaskalarinaGorunsun'] as bool? ?? true,
        mesajAlabilir: json['mesajAlabilir'] as bool? ?? true,
        konumuIlanlardaGoster: json['konumuIlanlardaGoster'] as bool? ?? false,
      );
}

// ─────────────────────────────────────────────
// Ana Kullanıcı Modeli
// ─────────────────────────────────────────────
class KullaniciModel {
  // Kayıt Ol ekranı (sayfa 4) alanları
  final String? id;
  final String ad;
  final String soyad;
  final String tcKimlikNo;
  final String adres;
  final String epostaVeyaTelefon;

  // Profili Düzenle ekranı ek alanları
  final String? kullaniciAdi;       // @aysedemir34
  final String? hakkinda;           // 150 karakter
  final String? konum;              // "Üsküdar, İstanbul"
  final String? telefonNumarasi;    // +90 5XX XXX XX XX
  final String? eposta;             // ayrı alan olarak
  final String? profilFotoUrl;

  // Gizlilik
  final GizlilikAyarlari gizlilikAyarlari;

  // Meta
  final DateTime? kayitTarihi;
  final bool aktif;

  KullaniciModel({
    this.id,
    required this.ad,
    required this.soyad,
    required this.tcKimlikNo,
    required this.adres,
    required this.epostaVeyaTelefon,
    this.kullaniciAdi,
    this.hakkinda,
    this.konum,
    this.telefonNumarasi,
    this.eposta,
    this.profilFotoUrl,
    GizlilikAyarlari? gizlilikAyarlari,
    DateTime? kayitTarihi,
    this.aktif = true,
  })  : gizlilikAyarlari = gizlilikAyarlari ?? const GizlilikAyarlari(),
        kayitTarihi = kayitTarihi ?? DateTime.now();

  // ── Hesaplanan alanlar ──────────────────────

  String get tamAd => '$ad $soyad';

  /// Profil sayfasında gösterilecek ad soyadın kısaltması: "Zeynep Ş."
  String get kisaAd {
    if (soyad.isEmpty) return ad;
    return '$ad ${soyad[0]}.';
  }

  bool get epostaIle => epostaVeyaTelefon.contains('@');

  // ── copyWith ────────────────────────────────

  KullaniciModel copyWith({
    String? id,
    String? ad,
    String? soyad,
    String? tcKimlikNo,
    String? adres,
    String? epostaVeyaTelefon,
    String? kullaniciAdi,
    String? hakkinda,
    String? konum,
    String? telefonNumarasi,
    String? eposta,
    String? profilFotoUrl,
    GizlilikAyarlari? gizlilikAyarlari,
    DateTime? kayitTarihi,
    bool? aktif,
  }) =>
      KullaniciModel(
        id: id ?? this.id,
        ad: ad ?? this.ad,
        soyad: soyad ?? this.soyad,
        tcKimlikNo: tcKimlikNo ?? this.tcKimlikNo,
        adres: adres ?? this.adres,
        epostaVeyaTelefon: epostaVeyaTelefon ?? this.epostaVeyaTelefon,
        kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi,
        hakkinda: hakkinda ?? this.hakkinda,
        konum: konum ?? this.konum,
        telefonNumarasi: telefonNumarasi ?? this.telefonNumarasi,
        eposta: eposta ?? this.eposta,
        profilFotoUrl: profilFotoUrl ?? this.profilFotoUrl,
        gizlilikAyarlari: gizlilikAyarlari ?? this.gizlilikAyarlari,
        kayitTarihi: kayitTarihi ?? this.kayitTarihi,
        aktif: aktif ?? this.aktif,
      );

  // ── JSON ────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'ad': ad,
        'soyad': soyad,
        'tcKimlikNo': tcKimlikNo,
        'adres': adres,
        'epostaVeyaTelefon': epostaVeyaTelefon,
        'kullaniciAdi': kullaniciAdi,
        'hakkinda': hakkinda,
        'konum': konum,
        'telefonNumarasi': telefonNumarasi,
        'eposta': eposta,
        'profilFotoUrl': profilFotoUrl,
        'gizlilikAyarlari': gizlilikAyarlari.toJson(),
        'kayitTarihi': kayitTarihi?.toIso8601String(),
        'aktif': aktif,
      };

  factory KullaniciModel.fromJson(Map<String, dynamic> json) => KullaniciModel(
        id: json['id'] as String?,
        ad: json['ad'] as String,
        soyad: json['soyad'] as String,
        tcKimlikNo: json['tcKimlikNo'] as String,
        adres: json['adres'] as String,
        epostaVeyaTelefon: json['epostaVeyaTelefon'] as String,
        kullaniciAdi: json['kullaniciAdi'] as String?,
        hakkinda: json['hakkinda'] as String?,
        konum: json['konum'] as String?,
        telefonNumarasi: json['telefonNumarasi'] as String?,
        eposta: json['eposta'] as String?,
        profilFotoUrl: json['profilFotoUrl'] as String?,
        gizlilikAyarlari: json['gizlilikAyarlari'] != null
            ? GizlilikAyarlari.fromJson(
                json['gizlilikAyarlari'] as Map<String, dynamic>)
            : const GizlilikAyarlari(),
        kayitTarihi: json['kayitTarihi'] != null
            ? DateTime.parse(json['kayitTarihi'] as String)
            : null,
        aktif: json['aktif'] as bool? ?? true,
      );
}