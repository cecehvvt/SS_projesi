// ─────────────────────────────────────────────
// Mesaj Durumu
// ─────────────────────────────────────────────
enum MesajDurumu {
  gonderildi,
  iletildi,
  okundu,
}

// ─────────────────────────────────────────────
// Sohbet Özeti — mesajlar listesi ekranında
// her satırda gösterilen bilgi
// ─────────────────────────────────────────────
class SohbetOzeti {
  final String karsiKullaniciId;
  final String karsiKullaniciAd;        // "Zeynep Ş."
  final String? karsiKullaniciAvatarUrl;
  final String? ilanId;
  final String? ilanBaslik;             // hangi ilan üzerinden açıldı
  final String sonMesajIcerik;
  final DateTime sonMesajZamani;
  final int okunmamisSayi;              // badge sayısı

  SohbetOzeti({
    required this.karsiKullaniciId,
    required this.karsiKullaniciAd,
    this.karsiKullaniciAvatarUrl,
    this.ilanId,
    this.ilanBaslik,
    required this.sonMesajIcerik,
    required this.sonMesajZamani,
    this.okunmamisSayi = 0,
  });

  bool get okunmamisVar => okunmamisSayi > 0;

  /// Liste satırında gösterilecek kısa zaman: "5dk", "2s", "3g"
  String get formatliZaman {
    final fark = DateTime.now().difference(sonMesajZamani);
    if (fark.inMinutes < 60) return '${fark.inMinutes}dk';
    if (fark.inHours < 24) return '${fark.inHours}s';
    return '${fark.inDays}g';
  }
}

// ─────────────────────────────────────────────
// Mesaj Modeli
// ─────────────────────────────────────────────
class MesajModel {
  final String? id;
  final String gondericId;
  final String aliciId;
  final String? ilanId;          // hangi ilandan açılan sohbet
  final String icerik;
  final DateTime gonderimZamani;
  final MesajDurumu durum;
  final bool silindiMi;

  MesajModel({
    this.id,
    required this.gondericId,
    required this.aliciId,
    this.ilanId,
    required this.icerik,
    DateTime? gonderimZamani,
    this.durum = MesajDurumu.gonderildi,
    this.silindiMi = false,
  }) : gonderimZamani = gonderimZamani ?? DateTime.now();

  // ── Hesaplanan alanlar ──────────────────────

  bool get okundu => durum == MesajDurumu.okundu;

  /// Sohbet balonunda gösterilecek saat: "14:35"
  String get saatFormati {
    final s = gonderimZamani.hour.toString().padLeft(2, '0');
    final d = gonderimZamani.minute.toString().padLeft(2, '0');
    return '$s:$d';
  }

  // ── copyWith ────────────────────────────────

  MesajModel copyWith({
    String? id,
    String? gondericId,
    String? aliciId,
    String? ilanId,
    String? icerik,
    DateTime? gonderimZamani,
    MesajDurumu? durum,
    bool? silindiMi,
  }) =>
      MesajModel(
        id: id ?? this.id,
        gondericId: gondericId ?? this.gondericId,
        aliciId: aliciId ?? this.aliciId,
        ilanId: ilanId ?? this.ilanId,
        icerik: icerik ?? this.icerik,
        gonderimZamani: gonderimZamani ?? this.gonderimZamani,
        durum: durum ?? this.durum,
        silindiMi: silindiMi ?? this.silindiMi,
      );

  // ── JSON ────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'gondericId': gondericId,
        'aliciId': aliciId,
        'ilanId': ilanId,
        'icerik': icerik,
        'gonderimZamani': gonderimZamani.toIso8601String(),
        'durum': durum.name,
        'silindiMi': silindiMi,
      };

  factory MesajModel.fromJson(Map<String, dynamic> json) => MesajModel(
        id: json['id'] as String?,
        gondericId: json['gondericId'] as String,
        aliciId: json['aliciId'] as String,
        ilanId: json['ilanId'] as String?,
        icerik: json['icerik'] as String,
        gonderimZamani: DateTime.parse(json['gonderimZamani'] as String),
        durum: MesajDurumu.values.firstWhere(
          (d) => d.name == json['durum'],
          orElse: () => MesajDurumu.gonderildi,
        ),
        silindiMi: json['silindiMi'] as bool? ?? false,
      );
}