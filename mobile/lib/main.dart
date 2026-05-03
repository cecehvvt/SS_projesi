import 'package:flutter/material.dart';

import 'screens/splash/splash_ekrani.dart';
import 'screens/auth/karsilama_ekrani.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_ekrani.dart';
import 'screens/ilan/ilan_listesi_ekrani.dart';
import 'screens/ilan/ilan_detay_ekrani.dart';
import 'screens/ilan/ilan_olustur_ekrani.dart';
import 'screens/ilan/takas_ilan_ekrani.dart';
import 'screens/mesajlar/mesajlar_ekrani.dart';
import 'screens/mesajlar/sohbet_ekrani.dart';
import 'screens/profil/profil_ekrani.dart';
import 'screens/profil/ayarlar_ekrani.dart';
void main() {
  runApp(const VestaApp());
}

class VestaApp extends StatelessWidget {
  const VestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // İlk açılan ekran
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashEkrani(),
        '/welcome': (context) => const KarsilamaEkrani(),
        '/login': (context) => const GirisEkrani(),
        '/register': (context) => const KayitEkrani(),
        '/ilan_listesi': (context) => const IlanListesiEkrani(),
        '/ilan_detay': (context) => const IlanDetayEkrani(),
        '/ilan_olustur': (context) => const IlanOlusturEkrani(),
        '/takas_ilan': (context) => const TakasIlanEkrani(),
        '/mesajlar': (context) => const MesajlarEkrani(),
        '/sohbet': (context) => const SohbetEkrani(),
        '/profil': (context) => const ProfilEkrani(),
        '/ayarlar': (context) => const AyarlarEkrani(),
      },

      // Opsiyonel: bilinmeyen route koruması
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashEkrani(),
        );
      },
    );
  }
}