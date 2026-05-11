import 'package:flutter/material.dart';

// 1. Yeni oluşturduğumuz ana sayfa tasarımını içeri alıyoruz
import 'ana_sayfa/ana_sayfa_ekrani.dart';

// 2. Diğer ekranların importları (Bunların klasör yapına göre doğruluğundan emin ol)
import 'favoriler/favoriler_ekrani.dart';
import 'sepet/sepetim_ekrani.dart';
import 'mesajlar/mesajlar_ekrani.dart'; 
import 'ilan/ilan_olustur_ekrani.dart';
import 'profil/profil_ekrani.dart';

class AnaSayfaYonetici extends StatefulWidget {
  const AnaSayfaYonetici({super.key});

  @override
  State<AnaSayfaYonetici> createState() => _AnaSayfaYoneticiState();
}

class _AnaSayfaYoneticiState extends State<AnaSayfaYonetici> {
  // Uygulama ilk açıldığında hangi sayfanın (indeksin) seçili geleceğini belirler
  int _seciliSayfa = 0; 

  // Alt menüdeki butonlara tıklandığında hangi widget'ın açılacağını tutan liste
  final List<Widget> _sayfalar = [
    const AnaSayfaEkrani(), // 0. İndeks: Senin en son attığın o şık tasarım
    const MesajlarEkrani(),   // 1. İndeks
    const IlanOlusturEkrani(),// 2. İndeks
    const FavorilerEkrani(),  // 3. İndeks
    const SepetimEkrani(),    // 4. İndeks
    const ProfilEkrani(),     // 5. İndeks
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Seçili olan sayfayı listeden çekip ekrana basar
      body: _sayfalar[_seciliSayfa],
      
      // Alt Navigasyon Çubuğu
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 4'ten fazla item olduğu için bu şart
        backgroundColor: const Color(0xFFB2D3C2), // Tasarımdaki mint yeşili
        currentIndex: _seciliSayfa,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          // Butona tıklandığında ekrana o sayfayı getirir
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