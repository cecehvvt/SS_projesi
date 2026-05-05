import 'package:flutter/material.dart';

class Renkler {
  Renkler._();

  // ─────────────────────────────────────────────
  // PRIMARY — Yeşil (butonlar, kategori badge, Kaydet, Talep Et)
  // ─────────────────────────────────────────────
  static const Color primary = Color(0xFF4CAF7D);
  static const Color primaryKoyu = Color(0xFF388E5E);
  static const Color primaryAcik = Color(0xFFE8F5EE);   // chip arka planı

  // ─────────────────────────────────────────────
  // SECONDARY — Mor/Lila (İhtiyaç İlanı Oluştur butonu, Kaydet mor)
  // ─────────────────────────────────────────────
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryAcik = Color(0xFFF3EEFF); // ihtiyaç kart bg

  // ─────────────────────────────────────────────
  // HEADER TEAL — Bağışlananlar / İhtiyaçlar başlık arka planı
  // ─────────────────────────────────────────────
  static const Color headerTeal = Color(0xFFB2DFDB);    // açık teal
  static const Color headerTealKoyu = Color(0xFF80CBC4);

  // ─────────────────────────────────────────────
  // ACİL BADGE — Kırmızı-turuncu
  // ─────────────────────────────────────────────
  static const Color acilBadge = Color(0xFFFF5722);
  static const Color acilBadgeAcik = Color(0xFFFFF3EE);

  // ─────────────────────────────────────────────
  // ARKA PLANLAR
  // ─────────────────────────────────────────────
  static const Color arkaplan = Color(0xFFF5F5F5);      // genel sayfa bg
  static const Color kartArkaplan = Color(0xFFFFFFFF);   // kart bg
  static const Color inputArkaplan = Color(0xFFF0F0F0);  // text field bg
  static const Color bolucuCizgi = Color(0xFFE0E0E0);

  // ─────────────────────────────────────────────
  // METİN
  // ─────────────────────────────────────────────
  static const Color metinKoyu = Color(0xFF1A1A1A);     // başlık, büyük metin
  static const Color metinOrta = Color(0xFF555555);     // normal içerik
  static const Color metinAcik = Color(0xFF9E9E9E);     // placeholder, alt bilgi
  static const Color metinBeyaz = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────
  // İKON / BADGE
  // ─────────────────────────────────────────────
  static const Color kalpIkon = Color(0xFF9E9E9E);       // favori boş
  static const Color kalpIkonDolu = Color(0xFFE53935);   // favori dolu
  static const Color uzaklikBadge = Color(0xFF424242);   // "6 km" koyu gri

  // ─────────────────────────────────────────────
  // NAVİGASYON ÇUBUĞU
  // ─────────────────────────────────────────────
  static const Color navBarArkaplan = Color(0xFFFFFFFF);
  static const Color navBarAktif = Color(0xFF4CAF7D);
  static const Color navBarPasif = Color(0xFF9E9E9E);
  static const Color navBarEkleButon = Color(0xFF4CAF7D); // orta + butonu

  // ─────────────────────────────────────────────
  // DURUM / TOGGLE
  // ─────────────────────────────────────────────
  static const Color toggleAktif = Color(0xFF4CAF7D);
  static const Color togglePasif = Color(0xFFBDBDBD);

  // ─────────────────────────────────────────────
  // KOLAY ERİŞİM — MaterialColor oluşturma
  // ─────────────────────────────────────────────
  static MaterialColor get primarySwatch => _buildSwatch(primary);

  static MaterialColor _buildSwatch(Color color) {
    final hsl = HSLColor.fromColor(color);
    return MaterialColor(color.value, {
      50: hsl.withLightness((hsl.lightness + 0.4).clamp(0.0, 1.0)).toColor(),
      100: hsl.withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0)).toColor(),
      200: hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor(),
      300: hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor(),
      400: color,
      500: color,
      600: hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor(),
      700: hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor(),
      800: hsl.withLightness((hsl.lightness - 0.3).clamp(0.0, 1.0)).toColor(),
      900: hsl.withLightness((hsl.lightness - 0.4).clamp(0.0, 1.0)).toColor(),
    });
  }

  // ─────────────────────────────────────────────
  // TEMA
  // ─────────────────────────────────────────────
  static ThemeData get tema => ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: primary,
        scaffoldBackgroundColor: arkaplan,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: kartArkaplan,
          onPrimary: metinBeyaz,
          onSecondary: metinBeyaz,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: headerTeal,
          foregroundColor: metinKoyu,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: metinKoyu,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: metinBeyaz,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: inputArkaplan,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: metinAcik, fontSize: 14),
        ),
        cardTheme: const CardThemeData(
          color: kartArkaplan,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: navBarArkaplan,
          selectedItemColor: navBarAktif,
          unselectedItemColor: navBarPasif,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );
}