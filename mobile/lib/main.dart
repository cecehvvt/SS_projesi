import 'package:flutter/material.dart';

import 'constants/renkler.dart';

import 'screens/splash/splash_ekrani.dart';
import 'screens/auth/karsilama_ekrani.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_ekrani.dart';
import 'screens/ilan/ilan_listesi_ekrani.dart';
import 'screens/ilan/ilan_detay_ekrani.dart';
import 'screens/ilan/ilan_olustur_ekrani.dart';
import 'screens/arama/arama_ekrani.dart';        // ← YENİ (sayfa 14-15)
import 'screens/mesajlar/mesajlar_ekrani.dart';
import 'screens/mesajlar/sohbet_ekrani.dart';
import 'screens/profil/profil_ekrani.dart';
import 'screens/profil/profil_duzenle_ekrani.dart';
import 'screens/profil/ayarlar_ekrani.dart';
import 'models/ilan_model.dart';                 // ← IlanTuru enum için

void main() {
  runApp(const VestaApp());
}

class VestaApp extends StatelessWidget {
  const VestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vesta',

      // ── Tema (renkler.dart'tan) ──────────────
      theme: Renkler.tema,

      // ── İlk ekran ───────────────────────────
      initialRoute: '/',

      // ── Route tablosu ───────────────────────
      routes: {
        // Splash
        '/': (context) => const SplashEkrani(),

        // Auth
        '/welcome': (context) => const KarsilamaEkrani(),
        '/login': (context) => const GirisEkrani(),
        '/register': (context) => const KayitEkrani(),

        // İlan
        '/ilan_listesi': (context) => const IlanListesiEkrani(),
        '/ilan_detay': (context) => const IlanDetayEkrani(),
        '/ilan_olustur': (context) => const IlanOlusturEkrani(),

        // Arama — varsayılan Bağışlananlar (sayfa 14)
        '/arama': (context) => const AramaEkrani(
              baslangicTuru: IlanTuru.bagis,
            ),

        // Arama — İhtiyaçlar sekmesiyle aç (sayfa 15)
        '/arama_ihtiyac': (context) => const AramaEkrani(
              baslangicTuru: IlanTuru.ihtiyac,
            ),

        // Mesajlar
        '/mesajlar': (context) => const MesajlarEkrani(),
        '/sohbet': (context) => const SohbetEkrani(),

        // Profil
        '/profil': (context) => const ProfilEkrani(),
        '/profil_duzenle': (context) =>  ProfilDuzenleEkrani(), // ← YENİ
        '/ayarlar': (context) => const AyarlarEkrani(),
      },

      // ── Bilinmeyen route koruması ────────────
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashEkrani(),
        );
      },
    );
  }
}

