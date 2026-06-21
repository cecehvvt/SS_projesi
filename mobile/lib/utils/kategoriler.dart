import 'package:flutter/material.dart';

import 'listing_taxonomy.dart';

class KategoriModel {
  final String ad;
  final IconData ikon;
  final Color anaRenk;
  final Color sekmeRenk;

  const KategoriModel({
    required this.ad,
    required this.ikon,
    required this.anaRenk,
    required this.sekmeRenk,
  });
}

// Backward-compatible view of the canonical ListingTaxonomy category list.
final List<KategoriModel> vestaKategorileri = ListingTaxonomy.categories
    .map(
      (category) => KategoriModel(
        ad: category.name,
        ikon: _iconFor(category.name),
        anaRenk: _mainColorFor(category.name),
        sekmeRenk: _tabColorFor(category.name),
      ),
    )
    .toList(growable: false);

IconData _iconFor(String category) {
  switch (category) {
    case 'Kadin':
      return Icons.checkroom;
    case 'Erkek':
      return Icons.man;
    case 'Cocuk & Bebek':
      return Icons.child_care;
    case 'Elektronik':
      return Icons.devices;
    case 'Ev & Yasam':
      return Icons.home_outlined;
    case 'Kitap & Kirtasiye':
      return Icons.menu_book;
    default:
      return Icons.category_outlined;
  }
}

Color _mainColorFor(String category) {
  switch (category) {
    case 'Cocuk & Bebek':
      return const Color(0xFFF4D8CD);
    case 'Elektronik':
      return const Color(0xFFD1C4E9);
    case 'Kitap & Kirtasiye':
      return const Color(0xFFB3E5FC);
    default:
      return const Color(0xFFAFD6C4);
  }
}

Color _tabColorFor(String category) {
  switch (category) {
    case 'Cocuk & Bebek':
      return const Color(0xFFF9E8E1);
    case 'Elektronik':
      return const Color(0xFFEDE7F6);
    case 'Kitap & Kirtasiye':
      return const Color(0xFFE1F5FE);
    default:
      return const Color(0xFFDFF0E6);
  }
}
