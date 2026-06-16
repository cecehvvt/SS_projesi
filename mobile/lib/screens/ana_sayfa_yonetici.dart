import 'package:flutter/material.dart';

import 'ana_sayfa/ana_sayfa_ekrani.dart';
import 'favoriler/favoriler_ekrani.dart';
import 'ilan/ilan_olustur_ekrani.dart';
import 'mesajlar/mesajlar_ekrani.dart';
import 'profil/profil_ekrani.dart';
import 'sepet/sepetim_ekrani.dart';

class AnaSayfaYonetici extends StatefulWidget {
  final int initialIndex;

  const AnaSayfaYonetici({super.key, this.initialIndex = 0});

  @override
  State<AnaSayfaYonetici> createState() => _AnaSayfaYoneticiState();
}

class _AnaSayfaYoneticiState extends State<AnaSayfaYonetici> {
  late int _seciliSayfa;

  late final List<Widget> _sayfalar = [
    const AnaSayfaEkrani(),
    const MesajlarEkrani(altMenuGoster: false),
    const IlanOlusturEkrani(altMenuGoster: false),
    const FavorilerEkrani(altMenuGoster: false),
    const SepetimEkrani(altMenuGoster: false),
    const ProfilEkrani(),
  ];

  @override
  void initState() {
    super.initState();
    _seciliSayfa = widget.initialIndex.clamp(0, _sayfalar.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: IndexedStack(index: _seciliSayfa, children: _sayfalar),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFB2D3C2),
          currentIndex: _seciliSayfa,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          onTap: (index) {
            setState(() {
              _seciliSayfa = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Mesajlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'İlan Oluştur',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Sepetim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profilim',
            ),
          ],
        ),
      ),
    );
  }
}
