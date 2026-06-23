import 'package:flutter/material.dart';

class SikayetDestekEkrani extends StatelessWidget {
  const SikayetDestekEkrani({super.key});

  static const _questions = <(String, String)>[
    (
      'Nasıl ilan oluşturabilirim?',
      'Alt menüdeki İlan Oluştur butonuna dokunun. Bağış veya ihtiyaç türünü seçip fotoğrafları ve ilan bilgilerini doldurarak kaydedin.',
    ),
    (
      'Bir ilana nasıl talep veya takas isteği gönderebilirim?',
      'İlan detayında Talep Et ya da Takas butonunu kullanın. Takas isteğiniz ilan sahibinin Bildirimler ekranına gider.',
    ),
    (
      'İlan sahibiyle nasıl iletişim kurabilirim?',
      'İlan detayındaki Mesaj butonuna dokunun. Tüm sohbetlerinize Mesajlar sekmesinden ulaşabilirsiniz.',
    ),
    (
      'Profil fotoğrafımı nasıl değiştirebilirim?',
      'Profilim ekranında Düzenle butonuna dokunun. Galeriden fotoğraf seçebilir veya kamerayla yeni bir fotoğraf çekebilirsiniz.',
    ),
    (
      'Bağış ve ihtiyaç ilanlarını nasıl ayırabilirim?',
      'Ana sayfadaki arama alanının altında bulunan Bağışlananlar ve İhtiyaçlar seçeneklerini kullanın.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Yardım ve Destek'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Sıkça Sorulan Sorular',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Merak ettiğiniz sorunun cevabını görmek için başlığa dokunun.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),
          ..._questions.map(
            (item) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(item.$2, style: const TextStyle(height: 1.45))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
