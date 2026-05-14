import 'package:flutter/material.dart';

class VestaMesajBalonu extends StatelessWidget {
  final String mesaj;
  final String saat;
  final bool benimMesajimMi; // Mesaj sağda mı solda mı duracak?

  const VestaMesajBalonu({
    super.key,
    required this.mesaj,
    required this.saat,
    required this.benimMesajimMi,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      // Benim mesajımsa sağa, karşı tarafınsa sola yasla
      alignment: benimMesajimMi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        // Ekranın en fazla %75'ini kaplasın ki çok uzun mesajlar ekranı yutmasın
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          // Benim mesajımsa Vesta mint yeşili, karşı tarafınsa açık gri
          color: benimMesajimMi ? const Color(0xFFDFF0E6) : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            // Benim mesajımsa sağ alt köşe sivri, değilse sol alt köşe sivri
            bottomLeft: Radius.circular(benimMesajimMi ? 16 : 0),
            bottomRight: Radius.circular(benimMesajimMi ? 0 : 16),
          ),
          border: Border.all(
            color: benimMesajimMi ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                if (benimMesajimMi) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: Color(0xFF2E7D32)), // Okundu tikleri
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}