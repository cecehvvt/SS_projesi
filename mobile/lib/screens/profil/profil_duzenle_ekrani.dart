import 'package:flutter/material.dart';

class ProfilDuzenleEkrani extends StatefulWidget {
  const ProfilDuzenleEkrani({super.key});

  @override
  State<ProfilDuzenleEkrani> createState() => _ProfilDuzenleEkraniState();
}

class _ProfilDuzenleEkraniState extends State<ProfilDuzenleEkrani> {
  // Switch'lerin (Aç/Kapa) durumlarını tutan değişkenler
  bool profilGorsun = true;
  bool mesajGelsin = true;
  bool konumGoster = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // Tasarımdaki açık gri arka plan
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            // ─── PROFİL FOTOĞRAFI BÖLÜMÜ ───
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person_outline, size: 50, color: Colors.black87),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Profil Fotoğrafı Ekle veya Değiştir',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── FORM ALANLARI ───
            // Ad Soyad ve Kullanıcı Adı (Yan Yana)
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Ad Soyad',
                    hint: 'Ayşe Demir',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Kullanıcı Adı',
                    hint: 'aysedemir34',
                    icon: Icons.alternate_email,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Hakkımda
            _buildTextField(
              label: 'Hakkımda',
              hint: 'Paylaşmayı ve yardımlaşmayı çok seviyorum.',
              maxLines: 3,
              isCounter: true,
            ),
            const SizedBox(height: 12),

            // Konum
            _buildTextField(
              label: 'Konum',
              hint: 'Üsküdar, İstanbul',
              icon: Icons.location_on_outlined,
              trailingIcon: Icons.chevron_right,
            ),
            const SizedBox(height: 12),

            // Telefon Numara
            _buildTextField(
              label: 'Telefon Numara',
              hint: '+90 5XX XXX XX XX',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 12),

            // E-posta
            _buildTextField(
              label: 'E-posta',
              hint: 'ayse.demir34@gmail.com',
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 24),

            // ─── GİZLİLİK AYARLARI KARTI ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lock_outline, color: Color(0xFF00A344), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Gizlilik Ayarları',
                        style: TextStyle(
                          color: Color(0xFF00A344),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow('Profil başkalarının görmesini izin ver', Icons.visibility_outlined, profilGorsun, (val) {
                    setState(() { profilGorsun = val; });
                  }),
                  _buildSwitchRow('Mesaj almayı etkinleştir', Icons.chat_bubble_outline, mesajGelsin, (val) {
                    setState(() { mesajGelsin = val; });
                  }),
                  _buildSwitchRow('Konumu ilanlarda göster', Icons.location_on_outlined, konumGoster, (val) {
                    setState(() { konumGoster = val; });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── ŞİFRE DEĞİŞTİR KARTI ───
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.lock_outline, color: Colors.black87),
                title: Text('Şifre Değiştir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),

            // ─── KAYDET BUTONU ───
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Kaydetme işlemleri buraya yazılacak
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A344), // Tasarımdaki Vesta Yeşili
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Özel Text Field Oluşturucu Metot
  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? icon,
    IconData? trailingIcon,
    int maxLines = 1,
    bool isCounter = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              floatingLabelBehavior: FloatingLabelBehavior.always, // Etiket hep üstte dursun
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
              prefixIcon: icon != null ? Icon(icon, color: Colors.black54, size: 20) : null,
              suffixIcon: trailingIcon != null ? Icon(trailingIcon, color: Colors.black54, size: 20) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: maxLines > 1 ? 16 : 10,
                  horizontal: icon != null ? 0 : 16),
            ),
          ),
          if (isCounter)
            const Positioned(
              bottom: 8,
              right: 12,
              child: Text('35 / 150', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ),
        ],
      ),
    );
  }

  // Özel Switch (Aç/Kapa) Satırı Oluşturucu Metot
  Widget _buildSwitchRow(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Transform.scale(
            scale: 0.8, // Switch'i tasarımdaki gibi biraz küçültüyoruz
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF00A344),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}