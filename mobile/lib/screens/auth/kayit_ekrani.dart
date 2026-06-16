import 'package:flutter/material.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  bool _sifre1Gizli = true;
  bool _sifre2Gizli = true;
  bool _kosullarKabul = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              const Center(
                child: Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildInputField(hint: "Ad"),
              _buildInputField(hint: "Soyad"),
              _buildInputField(
                hint: "T.C Kimlik No",
                keyboardType: TextInputType.number,
              ),
              _buildInputField(hint: "Adres", maxLines: 3),
              _buildInputField(
                hint: "E-posta Adresi veya Telefon",
                keyboardType: TextInputType.emailAddress,
              ),
              _buildPasswordField(
                hint: "Şifre",
                gizli: _sifre1Gizli,
                onToggle: () => setState(() => _sifre1Gizli = !_sifre1Gizli),
              ),
              _buildPasswordField(
                hint: "Şifre Tekrar",
                gizli: _sifre2Gizli,
                onToggle: () => setState(() => _sifre2Gizli = !_sifre2Gizli),
              ),

              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _kosullarKabul = !_kosullarKabul),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _kosullarKabul
                              ? const Color(0xFF4A7C5F)
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: _kosullarKabul
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Color(0xFF4A7C5F),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Kullanım Koşulları'nı Kabul Ediyorum.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

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
                    "Kaydol",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.black54),
                  child: const Text(
                    "Zaten bir hesabın var mı? Giriş yap",
                    style: TextStyle(fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEDE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: maxLines > 1 ? 14 : 17,
          ),
          isCollapsed: false,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool gizli,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEDE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        obscureText: gizli,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              gizli ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
