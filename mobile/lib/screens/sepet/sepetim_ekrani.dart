import 'package:flutter/material.dart';

import '../../widgets/alt_menu.dart';

class SepetimEkrani extends StatelessWidget {
  final bool altMenuGoster;

  const SepetimEkrani({super.key, this.altMenuGoster = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 56,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sepetin bos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kaydetmek veya takip etmek istedigin ilanlar eklendiginde burada gorunecek.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/ana_sayfa'),
                icon: const Icon(Icons.search),
                label: const Text('Ilanlara bak'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: altMenuGoster
          ? const VestaAltMenu(seciliIndex: 4)
          : null,
    );
  }
}
