import 'package:flutter/material.dart';

import '../../constants/renkler.dart';
import '../../services/auth_service.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _epostaController = TextEditingController();
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _hakkindaController = TextEditingController();
  final TextEditingController _konumController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

  bool _sifre1Gizli = true;
  bool _sifre2Gizli = true;
  bool _kosullarKabul = true;
  bool _loading = false;

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _adresController.dispose();
    _epostaController.dispose();
    _kullaniciAdiController.dispose();
    _hakkindaController.dispose();
    _konumController.dispose();
    _telefonController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.authBackground,
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
              _buildInputField(controller: _adController, hint: 'Ad'),
              _buildInputField(controller: _soyadController, hint: 'Soyad'),
              _buildInputField(
                controller: _adresController,
                hint: 'Adres',
                maxLines: 3,
              ),
              _buildInputField(
                controller: _epostaController,
                hint: 'E-posta adresi veya telefon',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildInputField(
                controller: _kullaniciAdiController,
                hint: 'Kullanıcı adı',
              ),
              _buildInputField(
                controller: _hakkindaController,
                hint: 'Hakkimda',
                maxLines: 3,
              ),
              _buildInputField(controller: _konumController, hint: 'Konum'),
              _buildInputField(
                controller: _telefonController,
                hint: 'Telefon numarası',
                keyboardType: TextInputType.phone,
              ),
              _buildPasswordField(
                controller: _sifreController,
                hint: 'Şifre',
                gizli: _sifre1Gizli,
                onToggle: () => setState(() => _sifre1Gizli = !_sifre1Gizli),
              ),
              _buildPasswordField(
                controller: _sifreTekrarController,
                hint: 'Şifre tekrar',
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
                      'Kullanim kosullarini kabul ediyorum.',
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
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7EA68A),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Kaydol',
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
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: TextButton.styleFrom(foregroundColor: Colors.black54),
                  child: const Text(
                    'Zaten hesabın var mı? Giriş yap',
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
    required TextEditingController controller,
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
        controller: controller,
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
    required TextEditingController controller,
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
        controller: controller,
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

  Future<void> _register() async {
    if (!_kosullarKabul) {
      _showError('Kullanim kosullarini kabul etmelisiniz.');
      return;
    }
    if (_sifreController.text != _sifreTekrarController.text) {
      _showError('Şifreler eşleşmiyor.');
      return;
    }
    setState(() => _loading = true);
    try {
      await const AuthService().register(
        ad: _adController.text.trim(),
        soyad: _soyadController.text.trim(),
        adres: _adresController.text.trim(),
        epostaVeyaTelefon: _epostaController.text.trim(),
        password: _sifreController.text,
        kullaniciAdi: _kullaniciAdiController.text.trim(),
        hakkinda: _hakkindaController.text.trim(),
        konum: _konumController.text.trim().isEmpty
            ? _adresController.text.trim()
            : _konumController.text.trim(),
        telefonNumarasi: _telefonController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/ana_sayfa');
    } catch (error) {
      if (mounted) {
        _showError(error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
