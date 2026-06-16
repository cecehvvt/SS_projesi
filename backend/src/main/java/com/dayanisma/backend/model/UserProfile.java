package com.dayanisma.backend.model;

import java.time.Instant;

public record UserProfile(
        String id,
        String ad,
        String soyad,
        String tcKimlikNo,
        String adres,
        String epostaVeyaTelefon,
        String kullaniciAdi,
        String hakkinda,
        String konum,
        String telefonNumarasi,
        String eposta,
        String profilFotoUrl,
        PrivacySettings gizlilikAyarlari,
        Instant kayitTarihi,
        boolean aktif
) {
}
