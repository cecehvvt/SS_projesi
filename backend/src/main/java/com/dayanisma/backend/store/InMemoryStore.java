package com.dayanisma.backend.store;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.Message;
import com.dayanisma.backend.model.Notification;
import com.dayanisma.backend.model.PrivacySettings;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.model.UserProfile;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class InMemoryStore {
    private static final String CURRENT_USER_ID = "user-1";

    private final Map<String, UserProfile> users = new ConcurrentHashMap<>();
    private final Map<String, Listing> listings = new ConcurrentHashMap<>();
    private final Map<String, Message> messages = new ConcurrentHashMap<>();
    private final Map<String, Notification> notifications = new ConcurrentHashMap<>();
    private final Map<String, SupportRequest> supportRequests = new ConcurrentHashMap<>();
    private final Map<String, Set<String>> favoriteUserIdsByListingId = new ConcurrentHashMap<>();

    @PostConstruct
    void seed() {
        users.put("user-1", new UserProfile(
                "user-1",
                "Ayse",
                "Demir",
                "11111111111",
                "Uskudar, Istanbul",
                "ayse@example.com",
                "@aysedemir34",
                "Paylasmayi seven Vesta kullanicisi.",
                "Uskudar, Istanbul",
                "+90 555 000 0001",
                "ayse@example.com",
                null,
                PrivacySettings.defaults(),
                Instant.now().minus(30, ChronoUnit.DAYS),
                true
        ));
        listings.clear();
        favoriteUserIdsByListingId.clear();
        messages.clear();
    }

    public String currentUserId() {
        return CURRENT_USER_ID;
    }

    public String newId() {
        return UUID.randomUUID().toString();
    }

    public Map<String, UserProfile> users() {
        return users;
    }

    public Map<String, Listing> listings() {
        return listings;
    }

    public Map<String, Message> messages() {
        return messages;
    }

    public Map<String, Notification> notifications() {
        return notifications;
    }

    public Map<String, SupportRequest> supportRequests() {
        return supportRequests;
    }

    public Map<String, Set<String>> favoriteUserIdsByListingId() {
        return favoriteUserIdsByListingId;
    }

    public void addListing(Listing listing) {
        listings.put(listing.id(), listing);
    }

    public void addMessage(Message message) {
        messages.put(message.id(), message);
    }

    public List<Message> allMessagesOrdered() {
        return messages.values().stream()
                .sorted((left, right) -> left.gonderimZamani().compareTo(right.gonderimZamani()))
                .toList();
    }

    public List<Notification> allNotificationsFor(String userId) {
        return notifications.values().stream()
                .filter(notification -> notification.userId().equals(userId))
                .sorted((left, right) -> right.olusturmaZamani().compareTo(left.olusturmaZamani()))
                .toList();
    }

    public Map<String, Object> chatSummary(Message message, UserProfile otherUser, Listing listing) {
        Map<String, Object> summary = new LinkedHashMap<>();
        String otherUserId = otherUser == null ? message.otherParticipant(CURRENT_USER_ID) : otherUser.id();
        String otherUserName = otherUser == null
                ? (listing == null ? "Vesta kullanicisi" : listing.ownerName())
                : otherUser.ad() + " " + otherUser.soyad().charAt(0) + ".";
        summary.put("karsiKullaniciId", otherUserId);
        summary.put("karsiKullaniciAd", otherUserName);
        summary.put("karsiKullaniciAvatarUrl", otherUser == null ? null : otherUser.profilFotoUrl());
        summary.put("ilanId", listing == null ? null : listing.id());
        summary.put("ilanBaslik", listing == null ? null : listing.title());
        summary.put("ilanKonum", listing == null ? null : listing.district() + ", " + listing.city());
        summary.put("ilanFotoUrl", listing == null || listing.imageUrls().isEmpty() ? null : listing.imageUrls().get(0));
        summary.put("sonMesajIcerik", message.icerik());
        summary.put("sonMesajZamani", message.gonderimZamani());
        summary.put("okunmamisSayi", message.aliciId().equals(CURRENT_USER_ID) && !"okundu".equals(message.durum()) ? 1 : 0);
        return summary;
    }

    public List<Map<String, Object>> favoriteRowsForCurrentUser() {
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Map.Entry<String, Set<String>> entry : favoriteUserIdsByListingId.entrySet()) {
            if (entry.getValue().contains(CURRENT_USER_ID)) {
                Listing listing = listings.get(entry.getKey());
                if (listing != null) {
                    rows.add(Map.of("ilan", listing.withFavorite(true), "favoriTakipciSayisi", entry.getValue().size()));
                }
            }
        }
        return rows;
    }
}
