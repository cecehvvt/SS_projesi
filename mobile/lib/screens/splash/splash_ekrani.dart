import 'package:flutter/material.dart';

import '../../constants/renkler.dart';
import '../../services/api_client.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani>
    with SingleTickerProviderStateMixin {
  static const _logoWidth = 168.0;

  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 72),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 28,
      ),
    ]).animate(_controller);
    _scale = Tween<double>(begin: 1, end: 1.045).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 250), () async {
      if (!mounted) return;
      final hasSession = await ApiClient.restoreSession();
      if (!mounted) return;
      await _controller.forward();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        hasSession ? '/ana_sayfa' : '/welcome',
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Renkler.authBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value,
              child: Transform.scale(scale: _scale.value, child: child),
            );
          },
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Image.asset(
                'assets/images/vesta_logo.png',
                width: _logoWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
