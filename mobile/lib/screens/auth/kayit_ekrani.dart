import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: const KayitEkrani(),
    debugShowCheckedModeBanner: false,
  ));
}


class KayitEkrani extends StatelessWidget {
  const KayitEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Arka plan rengi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kayıt Ol',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Giriş Alanları
            _buildTextField("Ad"),
            _buildTextField("Soyad"),
            _buildTextField("T.C Kimlik No"),
            _buildTextField("Adres", maxLines: 3),
            _buildTextField("E-posta Adresi veya Telefon"),
            _buildTextField("Şifre", isPassword: true),
            _buildTextField("Şifre Tekrar", isPassword: true),

            const SizedBox(height: 10),

            // Kullanım Koşulları
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 20, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Kullanım Koşulları'nı Kabul Ediyorum.",
                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Kaydol Butonu
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF94B49F), // Görseldeki yeşil tonu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Kaydol",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Alt Metin
            TextButton(
              onPressed: () {},
              child: const Text(
                "Zaten bir hesabın var mı? Giriş yap",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Ortak TextField Tasarımı
  Widget _buildTextField(String hint, {bool isPassword = false, int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE3E3), // Input arka plan rengi
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }
}