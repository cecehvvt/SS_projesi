import 'package:flutter/material.dart';

class VestaAltMenu extends StatelessWidget {
  const VestaAltMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFAFD6C4), // Tasarımındaki o efsane mint yeşili
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _altMenuElemani(context, Icons.home_outlined, "Anasayfa"),
          _altMenuElemani(context, Icons.chat_bubble_outline, "Mesajlar"),
          _altMenuElemani(context, Icons.add_circle_outline, "İlan Oluştur", ikonBoyutu: 28),
          _altMenuElemani(context, Icons.favorite_border, "Favoriler"),
          _altMenuElemani(context, Icons.shopping_bag_outlined, "Sepetim"),
          _altMenuElemani(context, Icons.person_outline, "Profilim"),
        ],
      ),
    );
  }

  Widget _altMenuElemani(BuildContext context, IconData ikon, String baslik, {double ikonBoyutu = 24}) {
    return InkWell(
      onTap: () {
        // İleride sayfalar arası geçişleri buraya bağlayacağız
        print("$baslik sayfasına tıklandı"); 
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, color: Colors.black87, size: ikonBoyutu),
          const SizedBox(height: 2),
          Text(baslik, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}