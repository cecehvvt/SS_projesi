import 'package:flutter/material.dart';
import 'filtre_ekrani.dart';

class IhtiyaclarEkrani extends StatefulWidget {
  const IhtiyaclarEkrani({super.key});

  @override
  State<IhtiyaclarEkrani> createState() => _IhtiyaclarEkraniState();
}

class _IhtiyaclarEkraniState extends State<IhtiyaclarEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4D8CD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "İhtiyaçlar",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "İhtiyaçlar içinde ara...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FiltreEkrani.ihtiyac(),
                    );
                  },
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black54,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ihtiyacKarti(
                  "Bebek Bezi",
                  "4 Numara bebek bezine acil ihtiyacımız var. 2 paket olsa yeterli.",
                  "Rabia C.",
                  "Üsküdar, İstanbul",
                  "3 saat önce",
                  "assets/images/ilanlar/bez.png",
                  isAcil: true,
                  onTap: () {
                    Navigator.pushNamed(context, '/ihtiyac_detay');
                  },
                ),
                _ihtiyacKarti(
                  "Elektrikli Isıtıcı",
                  "Evimiz çok soğuk oluyor, bebeğimiz için ısıtıcıya ihtiyacımız var.",
                  "Fatma Y.",
                  "Beyoğlu, İstanbul",
                  "3 saat önce",
                  "assets/images/ilanlar/isitici.png",
                  isAcil: true,
                ),
                _ihtiyacKarti(
                  "Akıllı Telefon",
                  "Öğrenciyim, derslerim için çalışan bir telefona ihtiyacım var.",
                  "Murat G.",
                  "Beşiktaş, İstanbul",
                  "5 saat önce",
                  "assets/images/ilanlar/telefon.png",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ihtiyacKarti(
    String baslik,
    String aciklama,
    String kisi,
    String konum,
    String sure,
    String resimYolu, {
    bool isAcil = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAcil ? Colors.orange.shade200 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                resimYolu,
                width: 90,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 110,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        baslik,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (isAcil)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "ACİL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    aciklama,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14),
                      const SizedBox(width: 4),
                      Text(kisi, style: const TextStyle(fontSize: 11)),
                      const Spacer(),
                      Text(
                        sure,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            konum,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          minimumSize: const Size(80, 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Yardım Et",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
