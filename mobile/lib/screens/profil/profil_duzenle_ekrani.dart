import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/kullanici_model.dart';
import '../../services/kullanici_service.dart';
import '../../utils/profile_image.dart';

class ProfilDuzenleEkrani extends StatefulWidget {
  const ProfilDuzenleEkrani({super.key});

  @override
  State<ProfilDuzenleEkrani> createState() => _ProfilDuzenleEkraniState();
}

class _ProfilDuzenleEkraniState extends State<ProfilDuzenleEkrani> {
  final _service = const KullaniciService();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _kullaniciAdiController = TextEditingController();
  final _hakkindaController = TextEditingController();
  final _adresController = TextEditingController();
  final _konumController = TextEditingController();
  final _telefonController = TextEditingController();
  final _epostaController = TextEditingController();
  final _picker = ImagePicker();
  String _profileImage = '';
  bool _pickingImage = false;

  bool profilGorsun = true;
  bool mesajGelsin = true;
  bool konumGoster = false;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _kullaniciAdiController.dispose();
    _hakkindaController.dispose();
    _adresController.dispose();
    _konumController.dispose();
    _telefonController.dispose();
    _epostaController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final user = await _service.me();
      if (!mounted) return;
      _fill(user);
    } catch (error) {
      if (mounted) _showError(error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(KullaniciModel user) {
    _adController.text = user.ad;
    _soyadController.text = user.soyad;
    _kullaniciAdiController.text = user.kullaniciAdi ?? '';
    _hakkindaController.text = user.hakkinda ?? '';
    _adresController.text = user.adres;
    _konumController.text = user.konum ?? '';
    _telefonController.text = user.telefonNumarasi ?? '';
    _epostaController.text = user.eposta ?? user.epostaVeyaTelefon;
    _profileImage = user.profilFotoUrl ?? '';
    profilGorsun = user.gizlilikAyarlari.profilBaskalarinaGorunsun;
    mesajGelsin = user.gizlilikAyarlari.mesajAlabilir;
    konumGoster = user.gizlilikAyarlari.konumuIlanlardaGoster;
    setState(() {});
  }

  Future<void> _save() async {
    if (_adController.text.trim().isEmpty ||
        _soyadController.text.trim().isEmpty) {
      _showError('Ad ve soyad zorunludur.');
      return;
    }
    setState(() => _saving = true);
    try {
      await _service.updateProfile({
        'ad': _adController.text.trim(),
        'soyad': _soyadController.text.trim(),
        'kullaniciAdi': _kullaniciAdiController.text.trim(),
        'hakkinda': _hakkindaController.text.trim(),
        'adres': _adresController.text.trim(),
        'konum': _konumController.text.trim(),
        'telefonNumarasi': _telefonController.text.trim(),
        'eposta': _epostaController.text.trim(),
        'profilFotoUrl': _profileImage,
      });
      await _service.updatePrivacy(
        GizlilikAyarlari(
          profilBaskalarinaGorunsun: profilGorsun,
          mesajAlabilir: mesajGelsin,
          konumuIlanlardaGoster: konumGoster,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _showError(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profili Düzenle',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _AvatarPreview(source: _profileImage),
                  const SizedBox(height: 12),
                  PopupMenuButton<ImageSource>(
                    enabled: !_pickingImage,
                    onSelected: _pickProfileImage,
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: ImageSource.gallery,
                        child: Text('Galeriden seç'),
                      ),
                      PopupMenuItem(
                        value: ImageSource.camera,
                        child: Text('Kamerayla çek'),
                      ),
                    ],
                    child: Chip(
                      avatar: _pickingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_a_photo_outlined, size: 18),
                      label: Text(
                        _profileImage.isEmpty
                            ? 'Profil fotoğrafı ekle'
                            : 'Profil fotoğrafını değiştir',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _adController,
                          label: 'Ad',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _soyadController,
                          label: 'Soyad',
                        ),
                      ),
                    ],
                  ),
                  _buildTextField(
                    controller: _kullaniciAdiController,
                    label: 'Kullanıcı adı',
                    icon: Icons.alternate_email,
                  ),
                  _buildTextField(
                    controller: _hakkindaController,
                    label: 'Hakkımda',
                    maxLines: 4,
                    maxLength: 150,
                  ),
                  _buildTextField(
                    controller: _adresController,
                    label: 'Adres',
                    icon: Icons.home_outlined,
                  ),
                  _buildTextField(
                    controller: _konumController,
                    label: 'Konum',
                    icon: Icons.location_on_outlined,
                  ),
                  _buildTextField(
                    controller: _telefonController,
                    label: 'Telefon',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    controller: _epostaController,
                    label: 'E-posta',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _PrivacyCard(
                    profilGorsun: profilGorsun,
                    mesajGelsin: mesajGelsin,
                    konumGoster: konumGoster,
                    onProfilChanged: (value) =>
                        setState(() => profilGorsun = value),
                    onMesajChanged: (value) =>
                        setState(() => mesajGelsin = value),
                    onKonumChanged: (value) =>
                        setState(() => konumGoster = value),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A344),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Kaydet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: icon == null
              ? null
              : Icon(icon, color: Colors.black54, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? 16 : 12,
            horizontal: icon == null ? 16 : 0,
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    setState(() => _pickingImage = true);
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 720,
        imageQuality: 75,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      final mime = image.mimeType ?? 'image/jpeg';
      if (!mounted) return;
      setState(
        () => _profileImage = 'data:$mime;base64,${base64Encode(bytes)}',
      );
    } catch (_) {
      if (mounted) _showError('Fotoğraf seçilemedi. Lütfen tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AvatarPreview extends StatelessWidget {
  final String source;

  const _AvatarPreview({required this.source});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: const Color(0xFFE0E0E0),
      backgroundImage: profileImageProvider(source),
      child: source.isEmpty
          ? const Icon(Icons.person_outline, size: 50, color: Colors.black87)
          : null,
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final bool profilGorsun;
  final bool mesajGelsin;
  final bool konumGoster;
  final ValueChanged<bool> onProfilChanged;
  final ValueChanged<bool> onMesajChanged;
  final ValueChanged<bool> onKonumChanged;

  const _PrivacyCard({
    required this.profilGorsun,
    required this.mesajGelsin,
    required this.konumGoster,
    required this.onProfilChanged,
    required this.onMesajChanged,
    required this.onKonumChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            'Profil başkalarına görünsün',
            Icons.visibility_outlined,
            profilGorsun,
            onProfilChanged,
          ),
          _buildSwitchRow(
            'Mesaj almayı etkinleştir',
            Icons.chat_bubble_outline,
            mesajGelsin,
            onMesajChanged,
          ),
          _buildSwitchRow(
            'Konumu ilanlarda göster',
            Icons.location_on_outlined,
            konumGoster,
            onKonumChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF00A344),
        ),
      ],
    );
  }
}
