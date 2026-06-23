class ApiSabitler {
  ApiSabitler._();

  // ─────────────────────────────────────────────
  // BASE URL
  // ─────────────────────────────────────────────
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8081/api',
  );

  // ─────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────
  static const String girisYap = '$baseUrl/auth/login';
  static const String kayitOl = '$baseUrl/auth/register';
  static const String sifremiUnuttum = '$baseUrl/auth/forgot-password';
  static const String sifreDegistir = '$baseUrl/auth/change-password';
  static const String cikisYap = '$baseUrl/auth/logout';
  static const String tokenYenile = '$baseUrl/auth/refresh-token';

  // ─────────────────────────────────────────────
  // KULLANICI
  // ─────────────────────────────────────────────
  static const String kullaniciBilgi = '$baseUrl/users/me';
  static const String kullaniciBilgiGuncelle = '$baseUrl/users/me';
  static const String hesapSil = '$baseUrl/users/me';
  static const String profilFotoyukle = '$baseUrl/users/me/avatar';
  static const String gizlilikGuncelle = '$baseUrl/users/me/privacy';

  /// Belirli kullanıcının profili: GET /users/{id}
  static String kullaniciProfil(String id) => '$baseUrl/users/$id';

  // ─────────────────────────────────────────────
  // İLANLAR
  // ─────────────────────────────────────────────

  /// Tüm ilanlar (filtre query param'larıyla): GET /ilanlar
  /// Query: tur, kategori, konum, acil, sayfa, limit, q (arama)
  static const String ilanlar = '$baseUrl/ilanlar';

  /// Bağış ilanları: GET /ilanlar?tur=bagis
  static const String bagisIlanlari = '$baseUrl/ilanlar?tur=bagis';

  /// İhtiyaç ilanları: GET /ilanlar?tur=ihtiyac
  static const String ihtiyacIlanlari = '$baseUrl/ilanlar?tur=ihtiyac';

  /// Tek ilan detayı: GET /ilanlar/{id}
  static String ilanDetay(String id) => '$baseUrl/ilanlar/$id';

  /// İlan oluştur: POST /ilanlar
  static const String ilanOlustur = '$baseUrl/ilanlar';

  /// İlan güncelle: PUT /ilanlar/{id}
  static String ilanGuncelle(String id) => '$baseUrl/ilanlar/$id';

  /// İlan sil: DELETE /ilanlar/{id}
  static String ilanSil(String id) => '$baseUrl/ilanlar/$id';

  /// Fotoğraf yükle: POST /ilanlar/{id}/fotograflar
  static String ilanFotoyukle(String id) => '$baseUrl/ilanlar/$id/fotograflar';

  /// Kullanıcının kendi ilanları: GET /ilanlar/benim
  static const String benimIlanlarim = '$baseUrl/ilanlar/benim';

  /// Arama: GET /ilanlar/ara?q={sorgu}&tur=&kategori=&konum=
  static const String ilanAra = '$baseUrl/ilanlar/ara';

  // ─────────────────────────────────────────────
  // FAVORİLER
  // ─────────────────────────────────────────────

  /// Favori ilanlar listesi: GET /favoriler
  static const String favoriler = '$baseUrl/favoriler';

  /// Favori ekle: POST /favoriler/{ilanId}
  static String favoriEkle(String ilanId) => '$baseUrl/favoriler/$ilanId';

  /// Favori kaldır: DELETE /favoriler/{ilanId}
  static String favoriKaldir(String ilanId) => '$baseUrl/favoriler/$ilanId';

  // ─────────────────────────────────────────────
  // TALEP / YARDIM
  // ─────────────────────────────────────────────

  /// Talep Et / Yardım Et butonuna basıldığında
  /// POST /ilanlar/{ilanId}/talep
  static String talepEt(String ilanId) => '$baseUrl/ilanlar/$ilanId/talep';

  /// Kullanıcının aktif talepleri: GET /taleplerim
  static const String taleplerim = '$baseUrl/taleplerim';

  /// Talebi iptal et: DELETE /ilanlar/{ilanId}/talep
  static String talepIptal(String ilanId) => '$baseUrl/ilanlar/$ilanId/talep';

  // ─────────────────────────────────────────────
  // MESAJLAR
  // ─────────────────────────────────────────────

  /// Sohbet listesi: GET /mesajlar/sohbetler
  static const String sohbetler = '$baseUrl/mesajlar/sohbetler';

  /// Belirli sohbetin mesajları: GET /mesajlar/{karsiKullaniciId}
  static String sohbetMesajlari(String karsiKullaniciId) =>
      '$baseUrl/mesajlar/$karsiKullaniciId';

  /// Mesaj gönder: POST /mesajlar
  static const String mesajGonder = '$baseUrl/mesajlar';

  /// Mesajı okundu işaretle: PATCH /mesajlar/{id}/okundu
  static String mesajOkundu(String mesajId) =>
      '$baseUrl/mesajlar/$mesajId/okundu';

  // ─────────────────────────────────────────────
  // KONUM
  // ─────────────────────────────────────────────

  /// Şehir/ilçe arama (konum seçimi): GET /konum/ara?q=Üsküdar
  static const String konumAra = '$baseUrl/konum/ara';

  // BILDIRIMLER / TAKAS
  static const String bildirimler = '$baseUrl/bildirimler';
  static const String gelenTakasIstekleri = '$baseUrl/takas-istekleri/gelen';
  static String takasIstegiOlustur(String ilanId) =>
      '$baseUrl/takas-istekleri/ilan/$ilanId';
  static String takasIstegiYanitla(String istekId) =>
      '$baseUrl/takas-istekleri/$istekId';

  // ─────────────────────────────────────────────
  // HTTP HEADER ANAHTARLARI
  // ─────────────────────────────────────────────
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerContentTypeJson = 'application/json';

  // ─────────────────────────────────────────────
  // TIMEOUT SÜRELERİ
  // ─────────────────────────────────────────────
  static const Duration baglantiTimeout = Duration(seconds: 15);
  static const Duration yanitTimeout = Duration(seconds: 30);

  // ─────────────────────────────────────────────
  // SAYFALAMA
  // ─────────────────────────────────────────────
  static const int sayfaBasiIlan = 10; // liste ekranında bir sayfada kaç ilan
  static const int maksimumFoto = 5; // ilan başına max fotoğraf (sayfa 20)
  static const int maksHakkindaKarakter =
      150; // profil hakkında alanı (sayfa profil)

  // ─────────────────────────────────────────────
  // LOCAL STORAGE ANAHTARLARI
  // ─────────────────────────────────────────────
  static const String tokenAnahtari = 'access_token';
  static const String refreshTokenAnahtari = 'refresh_token';
  static const String kullaniciIdAnahtari = 'kullanici_id';
}
