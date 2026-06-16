import 'package:flutter/material.dart';

class VestaAltMenu extends StatelessWidget {
  final int seciliIndex;

  const VestaAltMenu({super.key, this.seciliIndex = -1});

  static const List<_AltMenuItem> _items = [
    _AltMenuItem(Icons.home_outlined, 'Anasayfa', '/ana_sayfa'),
    _AltMenuItem(Icons.chat_bubble_outline, 'Mesajlar', '/mesajlar'),
    _AltMenuItem(Icons.add_circle_outline, 'İlan Oluştur', '/ilan_olustur', 28),
    _AltMenuItem(Icons.favorite_border, 'Favoriler', '/favoriler'),
    _AltMenuItem(Icons.shopping_bag_outlined, 'Sepetim', '/sepetim'),
    _AltMenuItem(Icons.person_outline, 'Profilim', '/profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFAFD6C4),
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _items.length,
          (index) => _altMenuElemani(context, _items[index], index),
        ),
      ),
    );
  }

  Widget _altMenuElemani(BuildContext context, _AltMenuItem item, int index) {
    final secili = index == seciliIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (secili) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          item.route,
          (route) => false,
        );
      },
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.ikon,
              color: secili ? const Color(0xFF1B5E20) : Colors.black87,
              size: item.ikonBoyutu,
            ),
            const SizedBox(height: 2),
            Text(
              item.baslik,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secili ? const Color(0xFF1B5E20) : Colors.black87,
                fontSize: 10,
                fontWeight: secili ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AltMenuItem {
  final IconData ikon;
  final String baslik;
  final String route;
  final double ikonBoyutu;

  const _AltMenuItem(
    this.ikon,
    this.baslik,
    this.route, [
    this.ikonBoyutu = 24,
  ]);
}
