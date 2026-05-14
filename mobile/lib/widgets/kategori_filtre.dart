import 'package:flutter/material.dart';

class VestaKategoriFiltre extends StatelessWidget {
  final List<String> sekmeler; // Örn: ["Tümü", "Bağışlananlar", "İhtiyaçlar"]
  final String seciliSekme; // Şu an hangisi seçili?
  final Function(String) onSekmeDegisti; // Tıklanınca ne olacak?
  
  // Renkleri dışarıdan alıyoruz ki her sayfada farklı tema uygulayabilelim
  final Color aktifArkaPlanRengi;
  final Color aktifYaziRengi;

  const VestaKategoriFiltre({
    super.key,
    required this.sekmeler,
    required this.seciliSekme,
    required this.onSekmeDegisti,
    // Varsayılan olarak Bağışlananlar ekranındaki nane yeşilini atıyoruz
    this.aktifArkaPlanRengi = const Color(0xFFDFF0E6), 
    this.aktifYaziRengi = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100, 
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: sekmeler.map((tab) {
            bool secili = seciliSekme == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSekmeDegisti(tab), // Yeni sekmeyi parent'a gönderiyoruz
                child: Container(
                  decoration: BoxDecoration(
                    color: secili ? aktifArkaPlanRengi : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: secili ? FontWeight.bold : FontWeight.normal,
                        color: secili ? aktifYaziRengi : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}