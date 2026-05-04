import 'package:flutter/material.dart';
import '../../constants/renkler.dart';

class SepetimEkrani extends StatelessWidget {
  const SepetimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.arkaplan,
      appBar: AppBar(
        title: const Text("Sepetim"),
        backgroundColor: Renkler.headerTeal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _urunKarti(
            "Bebek Bezi",
            "4 paket kaldı",
            "Mesaj Git",
          ),
          _urunKarti(
            "Kışlık Mont",
            "2 adet mevcut",
            "Mesaj Git",
          ),
        ],
      ),
    );
  }

  Widget _urunKarti(String isim, String detay, String butonText) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(isim),
        subtitle: Text(detay),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text(butonText),
        ),
      ),
    );
  }
}