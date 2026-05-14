import 'package:flutter/material.dart';

import 'constants/renkler.dart';

import 'screens/splash/splash_ekrani.dart';
import 'screens/auth/karsilama_ekrani.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_ekrani.dart';
import 'screens/auth/sifremi_unuttum_ekrani.dart'; 
import 'screens/ilan/ilan_listesi_ekrani.dart';
import 'screens/ilan/ilan_detay_ekrani.dart'; // Mont Detay
import 'screens/ilan/ihtiyac_detay_ekrani.dart'; // YENİ: Bebek Bezi Detay
import 'screens/ilan/ilan_olustur_ekrani.dart';
import 'screens/ilan/bagis_ilani_olustur_ekrani.dart'; // YENİ: Yeşil Form
import 'screens/ilan/ihtiyac_ilani_olustur_ekrani.dart'; // YENİ: Mor Form
import 'screens/arama/arama_ekrani.dart'; 
import 'screens/mesajlar/mesajlar_ekrani.dart';
import 'screens/mesajlar/sohbet_ekrani.dart';
import 'screens/profil/profil_ekrani.dart';
import 'screens/profil/profil_duzenle_ekrani.dart';
import 'screens/profil/ayarlar_ekrani.dart';
import 'screens/profil/sikayet_destek_ekrani.dart'; // YENİ: Ayarlardan gidilen sayfa
import 'models/ilan_model.dart'; 
import 'screens/ana_sayfa_yonetici.dart';

void main() {
  // Motoru güvenli bir şekilde başlatır (İleride Firebase bağlamak için şart)
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

      // ── Tema (renkler.dart'tan) ──────────────
      theme: Renkler.tema,

      // ── İlk ekran ───────────────────────────
      initialRoute: '/',

      // ── Route tablosu ───────────────────────
      routes: {
        // Splash
        '/': (context) => const SplashEkrani(),

        // Auth (Giriş/Kayıt)
        '/welcome': (context) => const KarsilamaEkrani(),
        '/login': (context) => const GirisEkrani(),
        '/register': (context) => const KayitEkrani(),
        '/sifremi_unuttum': (context) => const SifremiUnuttumEkrani(),

        // İlan ve Detaylar
        '/ilan_listesi': (context) => const IlanListesiEkrani(),
        '/ilan_detay': (context) => const IlanDetayEkrani(), // Bağışlanan Mont
        '/ihtiyac_detay': (context) => const IhtiyacDetayEkrani(), // İhtiyaç Bebek Bezi

        // İlan Oluşturma Akışı
        '/ilan_olustur': (context) => const IlanOlusturEkrani(), // Seçim Ekranı
        '/bagis_ilani_olustur': (context) => const BagisIlaniOlusturEkrani(), // Yeşil Form
        '/ihtiyac_ilani_olustur': (context) => const IhtiyacIlaniOlusturEkrani(), // Mor Form

        // Arama
        '/arama': (context) => const AramaEkrani(baslangicTuru: IlanTuru.bagis),
        '/arama_ihtiyac': (context) => const AramaEkrani(baslangicTuru: IlanTuru.ihtiyac),

        // Mesajlaşma
        '/mesajlar': (context) => const MesajlarEkrani(),
        '/sohbet': (context) => const SohbetEkrani(),

        // Profil ve Ayarlar
        '/profil': (context) => const ProfilEkrani(),
        '/profil_duzenle': (context) => const ProfilDuzenleEkrani(), 
        '/ayarlar': (context) => const AyarlarEkrani(),
        '/sikayet_destek': (context) => const SikayetDestekEkrani(), // Form sayfası

        // Ana Navigasyon
        '/ana_sayfa': (context) => const AnaSayfaYonetici(),
      },

      // ── Bilinmeyen route koruması ────────────
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const SplashEkrani());
      },
    );
  }
}