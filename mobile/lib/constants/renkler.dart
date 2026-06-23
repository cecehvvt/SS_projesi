import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Renkler {
  Renkler._();

  static const Color cream = Color(0xFFFFFBF5);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color terracotta = Color(0xFFD96C4A);
  static const Color terracottaDark = Color(0xFFB6502F);
  static const Color olive = Color(0xFF5C6B4F);
  static const Color oliveLight = Color(0xFF7C8A6C);
  static const Color ink = Color(0xFF2B2622);
  static const Color inkSoft = Color(0xFF6B635B);
  static const Color line = Color(0xFFEAE2D6);
  static const Color authBackground = Color(0xFFF9F3F3);

  // Mevcut ekranların kullandığı adlar yeni Vesta paletine bağlanır.
  static const Color primary = terracotta;
  static const Color primaryKoyu = terracottaDark;
  static const Color primaryAcik = Color(0xFFFFEEE8);
  static const Color secondary = olive;
  static const Color secondaryAcik = Color(0xFFF0F2ED);
  static const Color headerTeal = cream;
  static const Color headerTealKoyu = line;
  static const Color acilBadge = terracotta;
  static const Color acilBadgeAcik = Color(0xFFFFEEE8);
  static const Color arkaplan = cream;
  static const Color kartArkaplan = paper;
  static const Color inputArkaplan = paper;
  static const Color bolucuCizgi = line;
  static const Color metinKoyu = ink;
  static const Color metinOrta = inkSoft;
  static const Color metinAcik = inkSoft;
  static const Color metinBeyaz = paper;
  static const Color kalpIkon = inkSoft;
  static const Color kalpIkonDolu = terracotta;
  static const Color uzaklikBadge = ink;
  static const Color navBarArkaplan = paper;
  static const Color navBarAktif = terracottaDark;
  static const Color navBarPasif = inkSoft;
  static const Color navBarEkleButon = terracotta;
  static const Color toggleAktif = terracotta;
  static const Color togglePasif = line;

  static TextStyle baslik({
    double size = 24,
    FontWeight weight = FontWeight.w600,
    Color color = ink,
  }) => GoogleFonts.fraunces(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.15,
  );

  static ThemeData get tema {
    final base = ThemeData(useMaterial3: true);
    final inter = GoogleFonts.interTextTheme(
      base.textTheme,
    ).apply(bodyColor: ink, displayColor: ink);
    return base.copyWith(
      scaffoldBackgroundColor: cream,
      colorScheme: const ColorScheme.light(
        primary: terracotta,
        onPrimary: paper,
        secondary: olive,
        onSecondary: paper,
        surface: paper,
        onSurface: ink,
        outline: line,
        error: terracottaDark,
      ),
      textTheme: inter.copyWith(
        headlineLarge: GoogleFonts.fraunces(
          textStyle: inter.headlineLarge,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.fraunces(
          textStyle: inter.headlineMedium,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.fraunces(
          textStyle: inter.headlineSmall,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.fraunces(
          textStyle: inter.titleLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baslik(size: 21),
      ),
      cardTheme: const CardThemeData(
        color: paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: paper,
        labelStyle: TextStyle(color: inkSoft),
        hintStyle: TextStyle(color: inkSoft, fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: terracotta, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: paper,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: paper,
          elevation: 0,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: terracottaDark,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: paper,
        selectedColor: primaryAcik,
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerTheme: const DividerThemeData(color: line),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: paper,
        selectedItemColor: terracottaDark,
        unselectedItemColor: inkSoft,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
