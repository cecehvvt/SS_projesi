import 'package:flutter/material.dart';

class MesajlarEkrani extends StatelessWidget {
  const MesajlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            // Geri dönme işlemi
          },
        ),
        title: const Text(
          'Mesajlar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Arama Çubuğu
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Sohbet ara...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Mesaj Listesi
            Expanded(
              child: ListView(
                children: [
                  _buildMesajKarti(
                    isim: 'Merve C.',
                    sonMesaj: 'Tamam, yarın saat 15:00\'te buluşalım.',
                    zaman: '10:35',
                    okunmadi: true,
                    konum: 'Üsküdar, İstanbul',
                  ),
                  const Divider(height: 1),
                  _buildMesajKarti(
                    isim: 'Ali C.',
                    sonMesaj: 'Mont hala duruyor mu?',
                    zaman: '18:42',
                    okunmadi: false,
                    konum: 'Beyoğlu, İstanbul',
                  ),
                  const Divider(height: 1),
                  _buildMesajKarti(
                    isim: 'Mehmet A.',
                    sonMesaj: 'Kitap için görüşebilir miyiz?',
                    zaman: 'Dün',
                    okunmadi: false,
                    konum: 'Kadıköy, İstanbul',
                  ),
                  const Divider(height: 1),
                  _buildMesajKarti(
                    isim: 'Seda T.',
                    sonMesaj: 'Süpürge için teşekkür ederim çok iyi oldu.',
                    zaman: 'Dün',
                    okunmadi: false,
                    konum: 'Kadıköy, İstanbul',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mesaj Kartı Tasarım Şablonu
  Widget _buildMesajKarti({
    required String isim,
    required String sonMesaj,
    required String zaman,
    required bool okunmadi,
    required String konum,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Profil Fotoğrafı (Şimdilik Gri İkon)
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFF5F5F5),
            child: Icon(Icons.person, size: 30, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Mesaj İçeriği
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isim,
                      style: TextStyle(
                        fontWeight: okunmadi ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87
                      ),
                    ),
                    Text(
                      zaman,
                      style: TextStyle(
                        fontSize: 12,
                        color: okunmadi ? Colors.black87 : Colors.grey,
                        fontWeight: okunmadi ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  sonMesaj,
                  style: TextStyle(
                    fontSize: 13,
                    color: okunmadi ? Colors.black87 : Colors.grey.shade600,
                    fontWeight: okunmadi ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(konum, style: const TextStyle(fontSize: 11, color: Colors.green)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Konuşulan Ürün Fotoğrafı (Şimdilik Placeholder)
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}