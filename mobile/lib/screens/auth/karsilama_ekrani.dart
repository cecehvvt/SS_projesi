import 'package:flutter/material.dart';
import 'giris_ekrani.dart';
import 'kayit_ekrani.dart';

class KarsilamaEkrani extends StatelessWidget {
  const KarsilamaEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/images/vesta_logo.png', width: 260),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Giriş Yap Butonu
                SizedBox(
                  width: 150,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA8C8AE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GirisEkrani()),
                      );
                    },
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ),

                // Kaydol Butonu
                SizedBox(
                  width: 150,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const KayitEkrani()),
                      );
                    },
                    child: const Text(
                      "Kaydol",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
