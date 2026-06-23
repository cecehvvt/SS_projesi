enum MesajDurumu { gonderildi, iletildi, okundu }

class SohbetOzeti {
  final String karsiKullaniciId;
  final String karsiKullaniciAd;
  final String? karsiKullaniciAvatarUrl;
  final String? ilanId;
  final String? ilanBaslik;
  final String? ilanKonum;
  final String? ilanFotoUrl;
  final String sonMesajIcerik;
  final DateTime sonMesajZamani;
  final int okunmamisSayi;

  const SohbetOzeti({
    required this.karsiKullaniciId,
    required this.karsiKullaniciAd,
    this.karsiKullaniciAvatarUrl,
    this.ilanId,
    this.ilanBaslik,
    this.ilanKonum,
    this.ilanFotoUrl,
    required this.sonMesajIcerik,
    required this.sonMesajZamani,
    this.okunmamisSayi = 0,
  });

  bool get okunmamisVar => okunmamisSayi > 0;

  String get formatliZaman {
    final fark = DateTime.now().difference(sonMesajZamani);
    if (fark.inMinutes < 1) return 'simdi';
    if (fark.inMinutes < 60) return '${fark.inMinutes} dk';
    if (fark.inHours < 24) return '${fark.inHours} sa';
    return '${fark.inDays} g';
  }

  factory SohbetOzeti.fromJson(Map<String, dynamic> json) {
    return SohbetOzeti(
      karsiKullaniciId: json['karsiKullaniciId']?.toString() ?? '',
      karsiKullaniciAd:
          json['karsiKullaniciAd']?.toString() ?? 'Vesta kullanıcısı',
      karsiKullaniciAvatarUrl: json['karsiKullaniciAvatarUrl']?.toString(),
      ilanId: json['ilanId']?.toString(),
      ilanBaslik: json['ilanBaslik']?.toString(),
      ilanKonum: json['ilanKonum']?.toString(),
      ilanFotoUrl: json['ilanFotoUrl']?.toString(),
      sonMesajIcerik: json['sonMesajIcerik']?.toString() ?? '',
      sonMesajZamani: _date(json['sonMesajZamani']),
      okunmamisSayi: (json['okunmamisSayi'] as num?)?.toInt() ?? 0,
    );
  }
}

class MesajModel {
  final String? id;
  final String gondericId;
  final String aliciId;
  final String? ilanId;
  final String icerik;
  final DateTime gonderimZamani;
  final MesajDurumu durum;
  final bool silindiMi;

  const MesajModel({
    this.id,
    required this.gondericId,
    required this.aliciId,
    this.ilanId,
    required this.icerik,
    required this.gonderimZamani,
    this.durum = MesajDurumu.gonderildi,
    this.silindiMi = false,
  });

  bool get okundu => durum == MesajDurumu.okundu;

  String get saatFormati {
    final saat = gonderimZamani.hour.toString().padLeft(2, '0');
    final dakika = gonderimZamani.minute.toString().padLeft(2, '0');
    return '$saat:$dakika';
  }

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

  factory MesajModel.fromJson(Map<String, dynamic> json) {
    return MesajModel(
      id: json['id']?.toString(),
      gondericId: json['gondericId']?.toString() ?? '',
      aliciId: json['aliciId']?.toString() ?? '',
      ilanId: json['ilanId']?.toString(),
      icerik: json['icerik']?.toString() ?? '',
      gonderimZamani: _date(json['gonderimZamani']),
      durum: MesajDurumu.values.firstWhere(
        (durum) => durum.name == json['durum']?.toString(),
        orElse: () => MesajDurumu.gonderildi,
      ),
      silindiMi: json['silindiMi'] as bool? ?? false,
    );
  }
}

DateTime _date(dynamic value) {
  if (value == null) return DateTime.now();
  return DateTime.tryParse(value.toString()) ?? DateTime.now();
}
