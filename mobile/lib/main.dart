import 'package:flutter/material.dart';

import 'screens/splash/splash_ekrani.dart';
import 'screens/auth/karsilama_ekrani.dart';
import 'screens/auth/giris_ekrani.dart';
import 'screens/auth/kayit_ekrani.dart';

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