import 'package:flutter/material.dart';
import 'arama/arama_ekrani.dart';
import 'favoriler/favoriler_ekrani.dart';
import 'sepet/sepetim_ekrani.dart';

class AnaSayfaYonetici extends StatefulWidget {
  const AnaSayfaYonetici({super.key});

  @override
  State<AnaSayfaYonetici> createState() => _AnaSayfaYoneticiState();
}

class _AnaSayfaYoneticiState extends State<AnaSayfaYonetici> {
  int _seciliSayfa = 3;

  final List<Widget> _sayfalar = [
    AramaEkrani(),
    Center(child: Text("Mesajlar")),
    Center(child: Text("İlan Oluştur")),
    FavorilerEkrani(),
    SepetimEkrani(),
    Center(child: Text("Profilim")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliSayfa],
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
    );
  }
}
