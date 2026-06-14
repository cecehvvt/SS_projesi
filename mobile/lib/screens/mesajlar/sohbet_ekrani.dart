import 'package:flutter/material.dart';

class SohbetEkrani extends StatelessWidget {
  const SohbetEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Hafif gri arka plan
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, // Altına hafif bir çizgi/gölge atsın
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merve C.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Güvenli Sohbet',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_comment_outlined,
              color: Colors.black,
            ), // YENİ: Tasarıma uygun ikon
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Üstteki Konuşulan Ürün Bilgi Kartı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                // YENİ: Gerçek Ürün Resmi Eklendi
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/ilanlar/bez.png', // Bebek bezi resmimiz
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bebek Bezi (2 Numara)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 2),
                          Text(
                            'Üsküdar, İstanbul',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'İlanı Görüntüle >',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mesajlaşma Alanı
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Tarih Ayracı
                Center(
                  child: Text(
                    'Bugün',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Karşı Tarafın Mesajı
                _buildMesajBalonu(
                  mesaj:
                      'Merhaba, ilanınızı gördüm. Bebek bezine ihtiyacım var. Hala uygun mu?',
                  saat: '10:35',
                  benimMesajimMi: false,
                ),

                // Benim Mesajım
                _buildMesajBalonu(
                  mesaj:
                      'Merhaba, evet hala uygun. 1 paket açılmamış, 80 adet bez var. Size nasıl yardımcı olabilirim?',
                  saat: '10:37',
                  benimMesajimMi: true,
                ),

                // Karşı Tarafın Mesajı
                _buildMesajBalonu(
                  mesaj: 'Çok sevindim. Nereden ve ne zaman teslim alabiliriz?',
                  saat: '10:45',
                  benimMesajimMi: false,
                ),

                // Benim Konum/Adres Mesajım
                _buildMesajBalonu(
                  mesaj:
                      'Yarın saat 15:00 civarı uygun olur. Tam adresi paylaşır mısınız?',
                  saat: '10:48',
                  benimMesajimMi: true,
                ),

                // Karşı Tarafın Adres Mesajı
                _buildMesajBalonu(
                  mesaj: 'Tabii, adresi size konum olarak göndereceğim.',
                  saat: '10:50',
                  benimMesajimMi: false,
                ),

                // Konum Kartı (Özel Tasarım)
                _buildKonumKarti(saat: '10:51'),

                // Benim Onay Mesajım
                _buildMesajBalonu(
                  mesaj: 'Teşekkür ederim, görüşmek üzere.',
                  saat: '10:55',
                  benimMesajimMi: true,
                ),
              ],
            ),
          ),

          // Alt Mesaj Yazma Alanı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Mesajınızı yazın...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Normal Mesaj Balonu Şablonu
  Widget _buildMesajBalonu({
    required String mesaj,
    required String saat,
    required bool benimMesajimMi,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: benimMesajimMi
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!benimMesajimMi) ...[
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: benimMesajimMi ? const Color(0xFFD4EAE2) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: benimMesajimMi
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: benimMesajimMi
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
                border: benimMesajimMi
                    ? null
                    : Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: benimMesajimMi
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    mesaj,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        saat,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (benimMesajimMi) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.green,
                        ), // Okundu işareti
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (benimMesajimMi)
            const SizedBox(width: 20), // Benim mesajımsa sağdan biraz boşluk
        ],
      ),
    );
  }

  // Özel Konum Paylaşma Kartı Şablonu
  Widget _buildKonumKarti({required String saat}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Üsküdar Mah. Doğa Sok. No:15',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Üsküdar / İstanbul',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Konumu Görüntüle >',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    saat,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
