package com.dayanisma.backend.config;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.model.UserProfile;
import com.dayanisma.backend.service.AuthService;
import com.dayanisma.backend.service.ListingService;
import com.dayanisma.backend.service.SupportService;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@Component
@Profile("feature-smoke")
public class FeatureSmokeRunner implements ApplicationRunner {
    private final AuthService authService;
    private final ListingService listingService;
    private final SupportService supportService;

    public FeatureSmokeRunner(AuthService authService, ListingService listingService, SupportService supportService) {
        this.authService = authService;
        this.listingService = listingService;
        this.supportService = supportService;
    }

    @Override
    public void run(ApplicationArguments args) {
        String suffix = String.valueOf(Instant.now().toEpochMilli());
        String email = "codex-smoke-" + suffix + "@example.com";
        String password = "Test12345";
        String newPassword = "Test54321";

        Map<String, Object> registered = authService.register(Map.of(
                "ad", "Codex",
                "soyad", "Smoke",
                "adres", "Test adres",
                "epostaVeyaTelefon", email,
                "password", password
        ));
        UserProfile user = (UserProfile) registered.get("user");
        String userId = user.id();

        require(authService.login(Map.of("epostaVeyaTelefon", email, "password", password)).containsKey("accessToken"), "login");
        Map<String, Object> forgot = authService.forgotPassword(Map.of("epostaVeyaTelefon", email));
        authService.resetPassword(Map.of("resetToken", forgot.get("resetToken"), "newPassword", newPassword));
        require(authService.login(Map.of("epostaVeyaTelefon", email, "password", newPassword)).containsKey("accessToken"), "reset-login");

        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(userId, null, List.of())
        );

        Listing listing = listingService.create(Map.of(
                "title", "Smoke Test Ilan " + suffix,
                "description", "Smoke test aciklama",
                "listingType", "bagis",
                "category", "Mont",
                "city", "Istanbul",
                "district", "Kadikoy",
                "condition", "Iyi"
        ));
        Map<String, Object> photo = listingService.addPhoto(listing.id(), Map.of(
                "url", "https://example.com/smoke-photo.jpg",
                "isCover", true
        ));
        require(listingService.photos(listing.id()).size() == 1, "photo-add");
        listingService.deletePhoto(listing.id(), photo.get("id").toString());
        require(listingService.photos(listing.id()).isEmpty(), "photo-delete");

        SupportRequest supportRequest = supportService.create(Map.of(
                "konu", "Smoke test",
                "mesaj", "Destek test mesaji"
        ));
        supportService.addReply(supportRequest.id(), Map.of("message", "Destek cevabi test"));
        require(supportService.replies(supportRequest.id()).size() == 1, "support-reply");

        System.out.println("FEATURE_SMOKE_OK email=" + email + " listingId=" + listing.id() + " supportId=" + supportRequest.id());
    }

    private void require(boolean condition, String step) {
        if (!condition) {
            throw new IllegalStateException("Feature smoke failed: " + step);
        }
    }
}
