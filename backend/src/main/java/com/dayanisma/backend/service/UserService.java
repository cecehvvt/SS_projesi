package com.dayanisma.backend.service;

import com.dayanisma.backend.model.PrivacySettings;
import com.dayanisma.backend.model.UserProfile;
import com.dayanisma.backend.store.InMemoryStore;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Map;
import java.util.NoSuchElementException;

@Service
public class UserService {
    private final InMemoryStore store;

    public UserService(InMemoryStore store) {
        this.store = store;
    }

    public UserProfile me() {
        return get(store.currentUserId());
    }

    public UserProfile get(String id) {
        UserProfile user = store.users().get(id);
        if (user == null) {
            throw new NoSuchElementException("Kullanici bulunamadi: " + id);
        }
        return user;
    }

    public UserProfile updateMe(Map<String, Object> request) {
        UserProfile current = me();
        UserProfile updated = new UserProfile(
                current.id(),
                text(request, "ad", current.ad()),
                text(request, "soyad", current.soyad()),
                text(request, "tcKimlikNo", current.tcKimlikNo()),
                text(request, "adres", current.adres()),
                text(request, "epostaVeyaTelefon", current.epostaVeyaTelefon()),
                text(request, "kullaniciAdi", current.kullaniciAdi()),
                text(request, "hakkinda", current.hakkinda()),
                text(request, "konum", current.konum()),
                text(request, "telefonNumarasi", current.telefonNumarasi()),
                text(request, "eposta", current.eposta()),
                text(request, "profilFotoUrl", current.profilFotoUrl()),
                current.gizlilikAyarlari(),
                current.kayitTarihi(),
                current.aktif()
        );
        store.users().put(updated.id(), updated);
        return updated;
    }

    public UserProfile updatePrivacy(Map<String, Object> request) {
        UserProfile current = me();
        PrivacySettings privacy = new PrivacySettings(
                bool(request, "profilBaskalarinaGorunsun", current.gizlilikAyarlari().profilBaskalarinaGorunsun()),
                bool(request, "mesajAlabilir", current.gizlilikAyarlari().mesajAlabilir()),
                bool(request, "konumuIlanlardaGoster", current.gizlilikAyarlari().konumuIlanlardaGoster())
        );
        UserProfile updated = new UserProfile(
                current.id(),
                current.ad(),
                current.soyad(),
                current.tcKimlikNo(),
                current.adres(),
                current.epostaVeyaTelefon(),
                current.kullaniciAdi(),
                current.hakkinda(),
                current.konum(),
                current.telefonNumarasi(),
                current.eposta(),
                current.profilFotoUrl(),
                privacy,
                current.kayitTarihi(),
                current.aktif()
        );
        store.users().put(updated.id(), updated);
        return updated;
    }

    public UserProfile register(Map<String, Object> request) {
        String id = store.newId();
        UserProfile user = new UserProfile(
                id,
                text(request, "ad", "Yeni"),
                text(request, "soyad", "Kullanici"),
                text(request, "tcKimlikNo", ""),
                text(request, "adres", ""),
                text(request, "epostaVeyaTelefon", text(request, "email", "")),
                null,
                null,
                null,
                null,
                text(request, "email", null),
                null,
                PrivacySettings.defaults(),
                Instant.now(),
                true
        );
        store.users().put(id, user);
        return user;
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null ? fallback : value.toString();
    }

    private boolean bool(Map<String, Object> request, String key, boolean fallback) {
        Object value = request.get(key);
        return value instanceof Boolean bool ? bool : fallback;
    }
}
