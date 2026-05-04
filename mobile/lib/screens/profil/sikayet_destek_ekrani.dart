import 'package:flutter/material.dart';
import '../../constants/renkler.dart';

class SikayetDestekEkrani extends StatefulWidget {
  const SikayetDestekEkrani({super.key});

  @override
  State<SikayetDestekEkrani> createState() => _SikayetDestekEkraniState();
}

class _SikayetDestekEkraniState extends State<SikayetDestekEkrani> {
  String seciliKategori = "Kullanıcı Şikayeti";
  final TextEditingController konuController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.arkaplan,
      appBar: AppBar(
        title: const Text("Şikayet ve Destek"),
        backgroundColor: Renkler.headerTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSikayetFormu(),
            const SizedBox(height: 20),
            _buildDestekKart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSikayetFormu() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Kullanıcı Şikayet Et",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: seciliKategori,
              items: [
                "Kullanıcı Şikayeti",
                "Ürün Şikayeti",
                "Teslimat Sorunu"
              ]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  seciliKategori = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: konuController,
              decoration: const InputDecoration(
                hintText: "Şikayet Konusu",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: aciklamaController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Açıklama yaz...",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Şikayet başarıyla gönderildi"),
                    ),
                  );
                },
                child: const Text("Şikayet Gönder"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDestekKart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Yardım & Destek",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.call),
              title: const Text("Canlı Destek"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("E-posta Gönder"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("SSS"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}