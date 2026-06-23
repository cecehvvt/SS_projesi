import 'package:flutter/material.dart';

import 'ilan_form_ekrani.dart';

class IlanOlusturEkrani extends StatelessWidget {
  final bool altMenuGoster;

  const IlanOlusturEkrani({super.key, this.altMenuGoster = true});

  @override
  Widget build(BuildContext context) {
    return const IlanFormEkrani(initialType: 'bagis');
  }
}
