import 'package:flutter/material.dart';

class SifremiUnuttumEkrani extends StatelessWidget {
  const SifremiUnuttumEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Şifremi Unuttum",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // İkon (Tasarımda görsel vardı, şimdilik şık bir ikon koyuyoruz)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mark_email_read_outlined, size: 60, color: Colors.green),
            ),
            const SizedBox(height: 24),
            const Text(
              "Şifreni mi unuttun?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Kayıtlı e-posta adresini gir, sana şifre\nsıfırlama bağlantısı gönderelim.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // E-posta Kutusu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "E-posta adresin",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kod Gönder Butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Şimdilik sadece uyarı versin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Şifre sıfırlama bağlantısı gönderildi!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF558B6E), // Tasarımdaki yeşil tonu
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Kod Gönder",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Güvenlik Uyarı Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.green, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Güvenliğin bizim için önemli", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 4),
                        Text("E-posta adresini başkalarıyla paylaşmayız.", style: TextStyle(fontSize: 12, color: Colors.black87)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Veya Çizgisi
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Veya", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 30),

            // Girişe Dön Butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                label: const Text(
                  "Girişe Dön",
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}