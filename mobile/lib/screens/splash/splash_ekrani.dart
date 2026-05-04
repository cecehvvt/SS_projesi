import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/karsilama_ekrani.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const KarsilamaEkrani(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold'un başındaki const kelimesini kaldırdık
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F5),
      body: Center(
        // Yazı yerine logomuzu ekledik
        child: Image.asset(
          'assets/images/vesta_logo.png',
          width: 400, // Logonun büyüklüğünü buradan değiştirebilirsin
        ),
      ),
    );
  }
}