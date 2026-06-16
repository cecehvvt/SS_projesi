import 'package:flutter/material.dart';

import '../../widgets/alt_menu.dart';
import 'bagis_ilani_olustur_ekrani.dart';
import 'ihtiyac_ilani_olustur_ekrani.dart';
import 'takas_ilan_ekrani.dart';

class IlanOlusturEkrani extends StatelessWidget {
  final bool altMenuGoster;

  const IlanOlusturEkrani({super.key, this.altMenuGoster = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Ilan Olustur'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Ne tur bir ilan olusturmak istiyorsun?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 18),
          _ListingTypeCard(
            title: 'Bagis Ilani',
            description: 'Kullanmadigin esyalari ihtiyaci olanlarla paylas.',
            icon: Icons.volunteer_activism,
            color: Color(0xFF2E7D32),
            page: BagisIlaniOlusturEkrani(),
          ),
          SizedBox(height: 12),
          _ListingTypeCard(
            title: 'Ihtiyac Ilani',
            description: 'Ihtiyacin olan urun icin topluluktan destek iste.',
            icon: Icons.clean_hands_outlined,
            color: Color(0xFF8E24AA),
            page: IhtiyacIlaniOlusturEkrani(),
          ),
          SizedBox(height: 12),
          _ListingTypeCard(
            title: 'Takas Ilani',
            description:
                'Elindeki urunu baska bir urunle degistirmek icin ilan ac.',
            icon: Icons.swap_horiz,
            color: Color(0xFF1565C0),
            page: TakasIlanEkrani(),
          ),
        ],
      ),
      bottomNavigationBar: altMenuGoster
          ? const VestaAltMenu(seciliIndex: 2)
          : null,
    );
  }
}

class _ListingTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget page;

  const _ListingTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
