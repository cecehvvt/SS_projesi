import 'package:flutter/material.dart';

class KategoriModel {
  final String ad;
  final IconData ikon;
  final Color anaRenk;
  final Color sekmeRenk;

  KategoriModel({
    required this.ad,
    required this.ikon,
    required this.anaRenk,
    required this.sekmeRenk,
  });
}

// Uygulamanın her yerinden erişebileceğin kategori listesi
List<KategoriModel> vestaKategorileri = [
  KategoriModel(ad: "Kadın Giyim", ikon: Icons.checkroom, anaRenk: const Color(0xFFAFD6C4), sekmeRenk: const Color(0xFFDFF0E6)),
  KategoriModel(ad: "Erkek Giyim", ikon: Icons.accessibility_new, anaRenk: const Color(0xFFAFD6C4), sekmeRenk: const Color(0xFFDFF0E6)),
  KategoriModel(ad: "Çocuk & Bebek", ikon: Icons.child_care, anaRenk: const Color(0xFFF4D8CD), sekmeRenk: const Color(0xFFF9E8E1)),
  KategoriModel(ad: "Elektronik", ikon: Icons.tv, anaRenk: const Color(0xFFD1C4E9), sekmeRenk: const Color(0xFFEDE7F6)),
  KategoriModel(ad: "Ev & Yaşam", ikon: Icons.home_outlined, anaRenk: const Color(0xFFC8E6C9), sekmeRenk: const Color(0xFFE8F5E9)),
  KategoriModel(ad: "Kırtasiye & Diğer", ikon: Icons.edit, anaRenk: const Color(0xFFB3E5FC), sekmeRenk: const Color(0xFFE1F5FE)),
];