package com.dayanisma.backend.service;

import com.dayanisma.backend.model.UserProfile;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {
    private final UserService userService;
    private final JdbcTemplate jdbc;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserService userService, JdbcTemplate jdbc, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.jdbc = jdbc;
        this.passwordEncoder = passwordEncoder;
    }

    public Map<String, Object> login(Map<String, Object> request) {
        String identifier = text(request, "email", text(request, "eposta", text(request, "epostaVeyaTelefon", ""))).trim();
        String password = text(request, "password", text(request, "sifre", ""));
        if (identifier.isBlank() || password.isBlank()) {
            throw new IllegalArgumentException("E-posta/telefon ve sifre zorunludur.");
        }

        List<Map<String, Object>> rows = jdbc.queryForList(
                "SELECT id, password_hash FROM users " +
                        "WHERE (lower(coalesce(eposta, '')) = lower(?) " +
                        "OR lower(coalesce(eposta_veya_telefon, '')) = lower(?) " +
                        "OR lower(coalesce(kullanici_adi, '')) = lower(?)) " +
                        "AND aktif = TRUE " +
                        "LIMIT 1",
                identifier, identifier, identifier
        );
        if (rows.isEmpty()) {
            throw new IllegalArgumentException("Kullanici bilgileri hatali.");
        }
        Map<String, Object> row = rows.get(0);
        String passwordHash = (String) row.get("password_hash");
        if (passwordHash == null || !passwordEncoder.matches(password, passwordHash)) {
            throw new IllegalArgumentException("Kullanici bilgileri hatali.");
        }
        return tokenResponse(row.get("id").toString());
    }

    public Map<String, Object> register(Map<String, Object> request) {
        String ad = text(request, "ad", "").trim();
        String soyad = text(request, "soyad", "").trim();
        String email = text(request, "email", text(request, "eposta", "")).trim();
        String phoneOrEmail = text(request, "epostaVeyaTelefon", email).trim();
        String password = text(request, "password", text(request, "sifre", ""));
        if (ad.isBlank() || soyad.isBlank()) {
            throw new IllegalArgumentException("Ad ve soyad zorunludur.");
        }
        if (phoneOrEmail.isBlank()) {
            throw new IllegalArgumentException("E-posta veya telefon zorunludur.");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Sifre en az 6 karakter olmalidir.");
        }
        Integer duplicateCount = jdbc.queryForObject(
                "SELECT COUNT(*) FROM users WHERE (? <> '' AND lower(coalesce(eposta, '')) = lower(?)) " +
                        "OR lower(coalesce(eposta_veya_telefon, '')) = lower(?)",
                Integer.class,
                email,
                email,
                phoneOrEmail
        );
        if (duplicateCount != null && duplicateCount > 0) {
            throw new IllegalArgumentException("Bu e-posta veya telefon zaten kayitli.");
        }

        UserProfile user = userService.register(request);
        jdbc.update("UPDATE users SET password_hash=?, tc_kimlik_no=NULL WHERE id=?",
                passwordEncoder.encode(password), user.id());
        return tokenResponse(user.id());
    }

    public Map<String, Object> simpleMessage(String message) {
        return Map.of("message", message);
    }

    public Map<String, Object> forgotPassword(Map<String, Object> request) {
        String identifier = text(request, "email", text(request, "eposta", text(request, "epostaVeyaTelefon", ""))).trim();
        if (identifier.isBlank()) {
            throw new IllegalArgumentException("E-posta veya telefon zorunludur.");
        }
        List<String> userIds = jdbc.queryForList(
                "SELECT id FROM users " +
                        "WHERE (lower(coalesce(eposta, '')) = lower(?) " +
                        "OR lower(coalesce(eposta_veya_telefon, '')) = lower(?) " +
                        "OR lower(coalesce(kullanici_adi, '')) = lower(?)) " +
                        "AND aktif = TRUE LIMIT 1",
                String.class,
                identifier,
                identifier,
                identifier
        );
        if (userIds.isEmpty()) {
            return Map.of("message", "Sifre sifirlama istegi alindi.");
        }

        String resetToken = UUID.randomUUID().toString() + "." + UUID.randomUUID();
        jdbc.update(
                "INSERT INTO password_reset_tokens (token_hash, user_id, expires_at, created_at) VALUES (?,?,?,now())",
                hash(resetToken),
                userIds.get(0),
                OffsetDateTime.now(ZoneOffset.UTC).plusMinutes(30)
        );
        return Map.of(
                "message", "Sifre sifirlama tokeni olusturuldu.",
                "resetToken", resetToken,
                "expiresInMinutes", 30
        );
    }

    public void resetPassword(Map<String, Object> request) {
        String resetToken = text(request, "resetToken", text(request, "token", ""));
        String newPassword = text(request, "newPassword", text(request, "yeniSifre", text(request, "password", "")));
        if (resetToken.isBlank() || newPassword.isBlank()) {
            throw new IllegalArgumentException("Reset token ve yeni sifre zorunludur.");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Yeni sifre en az 6 karakter olmalidir.");
        }
        List<String> userIds = jdbc.queryForList(
                "SELECT user_id FROM password_reset_tokens " +
                        "WHERE token_hash=? AND used_at IS NULL AND expires_at > now() LIMIT 1",
                String.class,
                hash(resetToken)
        );
        if (userIds.isEmpty()) {
            throw new IllegalArgumentException("Reset token gecersiz veya suresi dolmus.");
        }
        String userId = userIds.get(0);
        jdbc.update("UPDATE users SET password_hash=?, refresh_token_hash=NULL WHERE id=?",
                passwordEncoder.encode(newPassword), userId);
        jdbc.update("UPDATE password_reset_tokens SET used_at=now() WHERE token_hash=?", hash(resetToken));
        jdbc.update("DELETE FROM auth_tokens WHERE user_id=?", userId);
    }

    public void changePassword(Map<String, Object> request) {
        String userId = currentUserId();
        String currentPassword = text(request, "currentPassword", text(request, "mevcutSifre", ""));
        String newPassword = text(request, "newPassword", text(request, "yeniSifre", ""));
        if (currentPassword.isBlank() || newPassword.isBlank()) {
            throw new IllegalArgumentException("Mevcut sifre ve yeni sifre zorunludur.");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Yeni sifre en az 6 karakter olmalidir.");
        }

        List<String> hashes = jdbc.queryForList(
                "SELECT password_hash FROM users WHERE id=? AND aktif = TRUE LIMIT 1",
                String.class,
                userId
        );
        if (hashes.isEmpty() || hashes.get(0) == null || !passwordEncoder.matches(currentPassword, hashes.get(0))) {
            throw new IllegalArgumentException("Mevcut sifre hatali.");
        }
        jdbc.update("UPDATE users SET password_hash=?, refresh_token_hash=NULL WHERE id=?",
                passwordEncoder.encode(newPassword), userId);
        jdbc.update("DELETE FROM auth_tokens WHERE user_id=?", userId);
    }

    public Map<String, Object> refresh(Map<String, Object> request) {
        String refreshToken = text(request, "refreshToken", "");
        if (refreshToken.isBlank()) {
            throw new IllegalArgumentException("Refresh token zorunludur.");
        }
        List<String> userIds = jdbc.queryForList(
                "SELECT id FROM users WHERE refresh_token_hash=? AND aktif = TRUE LIMIT 1",
                String.class,
                hash(refreshToken)
        );
        if (userIds.isEmpty()) {
            throw new IllegalArgumentException("Refresh token gecersiz.");
        }
        return tokenResponse(userIds.get(0));
    }

    public void logout(String accessToken) {
        if (accessToken == null || accessToken.isBlank()) {
            return;
        }
        jdbc.update("DELETE FROM auth_tokens WHERE token_hash=?", hash(accessToken));
    }

    public Optional<String> userIdForAccessToken(String accessToken) {
        jdbc.update("DELETE FROM auth_tokens WHERE expires_at < now()");
        List<String> userIds = jdbc.queryForList(
                "SELECT auth_tokens.user_id FROM auth_tokens " +
                        "JOIN users ON users.id = auth_tokens.user_id " +
                        "WHERE auth_tokens.token_hash=? AND auth_tokens.expires_at > now() AND users.aktif = TRUE LIMIT 1",
                String.class,
                hash(accessToken)
        );
        return userIds.stream().findFirst();
    }

    private Map<String, Object> tokenResponse(String userId) {
        String accessToken = UUID.randomUUID().toString() + "." + UUID.randomUUID();
        String refreshToken = UUID.randomUUID().toString() + "." + UUID.randomUUID();
        jdbc.update(
                "INSERT INTO auth_tokens (token_hash, user_id, expires_at, created_at) VALUES (?,?,?,now())",
                hash(accessToken),
                userId,
                OffsetDateTime.now(ZoneOffset.UTC).plusDays(7)
        );
        jdbc.update("UPDATE users SET refresh_token_hash=? WHERE id=?", hash(refreshToken), userId);
        return Map.of(
                "accessToken", accessToken,
                "refreshToken", refreshToken,
                "user", userService.get(userId)
        );
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null ? fallback : value.toString();
    }

    private String currentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getName() == null) {
            throw new AccessDeniedException("Oturum gerekli.");
        }
        return authentication.getName();
    }

    private String hash(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashed = digest.digest(value.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hashed);
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException("Token hash algoritmasi bulunamadi.", exception);
        }
    }
}
