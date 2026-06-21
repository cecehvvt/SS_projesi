import 'package:flutter/material.dart';

import 'constants/renkler.dart';

import 'screens/splash/splash_ekrani.dart';
import 'screens/auth/karsilama_ekrani.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_ekrani.dart';
import 'screens/auth/sifremi_unuttum_ekrani.dart';
import 'screens/ilan/ilan_listesi_ekrani.dart';
import 'screens/ilan/ilan_detay_ekrani.dart';
import 'screens/ilan/bagis_ilani_olustur_ekrani.dart';
import 'screens/ilan/ihtiyac_ilani_olustur_ekrani.dart';
import 'screens/ilan/takas_ilan_ekrani.dart';
import 'screens/arama/arama_ekrani.dart';
import 'screens/mesajlar/sohbet_ekrani.dart';
import 'screens/profil/profil_duzenle_ekrani.dart';
import 'screens/profil/ayarlar_ekrani.dart';
import 'screens/profil/sikayet_destek_ekrani.dart';
import 'models/ilan_model.dart';
import 'screens/ana_sayfa_yonetici.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const VestaApp());
}

class VestaApp extends StatelessWidget {
  const VestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vesta',

      theme: Renkler.tema,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashEkrani(),
        '/welcome': (context) => const KarsilamaEkrani(),
        '/login': (context) => const GirisEkrani(),
        '/register': (context) => const KayitEkrani(),
        '/sifremi_unuttum': (context) => const SifremiUnuttumEkrani(),
        '/ilan_listesi': (context) => const IlanListesiEkrani(),
        '/ilan_detay': (context) => const IlanDetayEkrani(),
        '/ihtiyac_detay': (context) => const IlanDetayEkrani(),
        '/ilan_olustur': (context) => const AnaSayfaYonetici(initialIndex: 2),
        '/bagis_ilani_olustur': (context) => const BagisIlaniOlusturEkrani(),
        '/ihtiyac_ilani_olustur': (context) =>
            const IhtiyacIlaniOlusturEkrani(),
        '/takas_ilani_olustur': (context) => const TakasIlanEkrani(),
        '/arama': (context) => const AramaEkrani(baslangicTuru: IlanTuru.bagis),
        '/arama_ihtiyac': (context) =>
            const AramaEkrani(baslangicTuru: IlanTuru.ihtiyac),
        '/mesajlar': (context) => const AnaSayfaYonetici(initialIndex: 1),
        '/sohbet': (context) => const SohbetEkrani(),
        '/profil': (context) => const AnaSayfaYonetici(initialIndex: 5),
        '/profil_duzenle': (context) => const ProfilDuzenleEkrani(),
        '/ayarlar': (context) => const AyarlarEkrani(),
        '/sikayet_destek': (context) => const SikayetDestekEkrani(),
        '/ana_sayfa': (context) => const AnaSayfaYonetici(),
        '/favoriler': (context) => const AnaSayfaYonetici(initialIndex: 3),
        '/sepetim': (context) => const AnaSayfaYonetici(initialIndex: 4),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const SplashEkrani());
      },
    );
  }
}
