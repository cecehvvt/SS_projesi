import 'package:flutter/material.dart';
import 'sohbet_ekrani.dart'; // Merve C.'ye tıklayınca gideceğimiz sayfa
import '../../widgets/alt_menu.dart'; // Alt menümüz

class MesajlarEkrani extends StatelessWidget {
  const MesajlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Column(
        children: [
          // ARAMA ÇUBUĞU
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Tasarımdaki açık gri arka plan
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Sohbet ara...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // SOHBET LİSTESİ
          Expanded(
            child: ListView(
              children: [
                // 1. SOHBET (MERVE C. - SOHBET EKRANINA GİDER)
                _mesajListesiKarti(
                  context: context,
                  isim: "Merve C.",
                  sonMesaj: "Tamam, yarın saat 15:00'te buluşalım.",
                  konum: "Üsküdar, İstanbul",
                  saat: "10:35",
                  okunmadiMi: true, // Mesaj metni daha siyah ve kalın
                  urunResimYolu:
                      "assets/images/ilanlar/bez.png", // Klasöründeki bez resmi
                  hedefSayfa: const SohbetEkrani(), // TIKLANINCA GİDECEĞİ YER
                ),

                // 2. SOHBET (ALİ C.)
                _mesajListesiKarti(
                  context: context,
                  isim: "Ali C.",
                  sonMesaj: "Mont hala duruyor mu?",
                  konum: "Beyoğlu, İstanbul",
                  saat: "18:42",
                  okunmadiMi: false, // Gri mesaj metni
                  urunResimYolu:
                      "assets/images/ilanlar/mont2.png", // Klasöründeki mont resmi
                ),

                // 3. SOHBET (MEHMET A.)
                _mesajListesiKarti(
                  context: context,
                  isim: "Mehmet A.",
                  sonMesaj: "Kitap için görüşebilir miyiz?",
                  konum: "Kadıköy, İstanbul",
                  saat: "Dün",
                  okunmadiMi: false,
                  urunResimYolu: "", // Resim yoksa gri kutu çıkar
                ),

                // 4. SOHBET (SEDA T.)
                _mesajListesiKarti(
                  context: context,
                  isim: "Seda T.",
                  sonMesaj: "Süpürge için teşekkür ederim çok iyi oldu.",
                  konum: "Kadıköy, İstanbul",
                  saat: "Dün",
                  okunmadiMi: false,
                  urunResimYolu: "",
                ),
              ],
            ),
          ),
        ],
      ),
      // ALT MENÜYÜ EKLİYORUZ
      bottomNavigationBar: const VestaAltMenu(),
    );
  }

  // SOHBET SATIRI WIDGET'I (Tıklanabilir)
  Widget _mesajListesiKarti({
    required BuildContext context,
    required String isim,
    required String sonMesaj,
    required String konum,
    required String saat,
    required bool okunmadiMi,
    required String urunResimYolu,
    Widget?
    hedefSayfa, // Eğer sayfa verilmişse ona gider, verilmemişse hiçbir şey yapmaz
  }) {
    return InkWell(
      onTap: () {
        if (hedefSayfa != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => hedefSayfa),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFİL FOTOĞRAFI
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFF0F0F0),
              child: Icon(Icons.person, color: Colors.grey, size: 28),
            ),
            const SizedBox(width: 12),

            // ORTA KISIM (İsim, Mesaj, Konum)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isim,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sonMesaj,
                    style: TextStyle(
                      fontSize: 13,
                      color: okunmadiMi ? Colors.black87 : Colors.grey.shade600,
                      fontWeight: okunmadiMi
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        konum,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // SAĞ KISIM (Saat ve Ürün Resmi)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  saat,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: okunmadiMi
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: urunResimYolu.isNotEmpty
                      ? Image.asset(
                          urunResimYolu,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _bosResimKutusu(),
                        )
                      : _bosResimKutusu(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Resim yoksa gösterilecek gri yer tutucu
  Widget _bosResimKutusu() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
    );
  }
}
