import 'package:flutter/material.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _sifreGizli = true;

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
          "Giriş Yap",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Hoş Geldiniz !",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Bağış yapabilir veya ihtiyacı olan\nkıyafetleri bulabilirsin.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // E-posta / Telefon
            _buildInputField(
              controller: emailController,
              hint: "E-posta veya Telefon",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),

            // Şifre
            _buildPasswordField(),
            const SizedBox(height: 6),

            // Şifremi Unuttum
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: Colors.black54),
                child: const Text(
                  "Şifremi Unuttum",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Giriş Yap Butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/ana_sayfa");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7EA68A),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Giriş yap",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hesabın yok mu?
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                style: TextButton.styleFrom(foregroundColor: Colors.black54),
                child: const Text(
                  "Hesabın yok mu? Kaydol",
                  style: TextStyle(fontSize: 13.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEDE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEDE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: _sifreGizli,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Şifre",
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _sifreGizli = !_sifreGizli),
            icon: Icon(
              _sifreGizli
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
