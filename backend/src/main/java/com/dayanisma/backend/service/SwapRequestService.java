package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.UserProfile;
import com.dayanisma.backend.store.DataStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class SwapRequestService {
    private final DataStore store;
    private final JdbcTemplate jdbc;
    private final NotificationService notifications;

    public SwapRequestService(DataStore store, JdbcTemplate jdbc, NotificationService notifications) {
        this.store = store;
        this.jdbc = jdbc;
        this.notifications = notifications;
    }

    public Map<String, Object> create(String listingId) {
        Listing listing = store.listings().get(listingId);
        if (listing == null || !"active".equals(listing.status())) {
            throw new IllegalArgumentException("Takas istenen aktif ilan bulunamadi.");
        }
        String requesterId = store.currentUserId();
        if (Objects.equals(requesterId, listing.ownerId())) {
            throw new IllegalArgumentException("Kendi ilaniniza takas istegi gonderemezsiniz.");
        }
        String id = store.newId();
        jdbc.update(
                "INSERT INTO swap_requests (id, listing_id, requester_id, owner_id, status, created_at, updated_at) " +
                        "VALUES (?,?,?,?, 'pending', now(), now()) " +
                        "ON CONFLICT (listing_id, requester_id) DO UPDATE SET status='pending', updated_at=now()",
                id, listingId, requesterId, listing.ownerId()
        );
        notifications.create(
                listing.ownerId(), listingId, "Yeni takas istegi",
                displayName(requesterId) + ", " + listing.title() + " ilani icin takas yapmak istiyor."
        );
        return findByListingAndRequester(listingId, requesterId);
    }

    public List<Map<String, Object>> incoming() {
        return jdbc.query(
                "SELECT id, listing_id, requester_id, owner_id, status, created_at, updated_at " +
                        "FROM swap_requests WHERE owner_id=? ORDER BY updated_at DESC",
                (rs, rowNum) -> row(
                        rs.getString("id"), rs.getString("listing_id"),
                        rs.getString("requester_id"), rs.getString("owner_id"),
                        rs.getString("status"), rs.getObject("created_at", OffsetDateTime.class),
                        rs.getObject("updated_at", OffsetDateTime.class)
                ),
                store.currentUserId()
        );
    }

    public Map<String, Object> respond(String id, String status) {
        if (!List.of("accepted", "rejected").contains(status)) {
            throw new IllegalArgumentException("Gecersiz takas yaniti.");
        }
        List<Map<String, Object>> matches = jdbc.queryForList(
                "SELECT listing_id, requester_id FROM swap_requests WHERE id=? AND owner_id=?",
                id, store.currentUserId()
        );
        if (matches.isEmpty()) {
            throw new IllegalArgumentException("Takas istegi bulunamadi.");
        }
        Map<String, Object> match = matches.get(0);
        String listingId = match.get("listing_id").toString();
        String requesterId = match.get("requester_id").toString();
        jdbc.update("UPDATE swap_requests SET status=?, updated_at=now() WHERE id=?", status, id);
        Listing listing = store.listings().get(listingId);
        notifications.create(
                requesterId, listingId,
                "accepted".equals(status) ? "Takas istegi onaylandi" : "Takas istegi reddedildi",
                (listing == null ? "Ilan" : listing.title()) + " icin takas isteginiz " +
                        ("accepted".equals(status) ? "onaylandi." : "reddedildi.")
        );
        return find(id);
    }

    private Map<String, Object> find(String id) {
        return jdbc.queryForObject(
                "SELECT id, listing_id, requester_id, owner_id, status, created_at, updated_at FROM swap_requests WHERE id=?",
                (rs, rowNum) -> row(
                        rs.getString("id"), rs.getString("listing_id"),
                        rs.getString("requester_id"), rs.getString("owner_id"),
                        rs.getString("status"), rs.getObject("created_at", OffsetDateTime.class),
                        rs.getObject("updated_at", OffsetDateTime.class)
                ), id
        );
    }

    private Map<String, Object> findByListingAndRequester(String listingId, String requesterId) {
        return jdbc.queryForObject(
                "SELECT id, listing_id, requester_id, owner_id, status, created_at, updated_at " +
                        "FROM swap_requests WHERE listing_id=? AND requester_id=?",
                (rs, rowNum) -> row(
                        rs.getString("id"), rs.getString("listing_id"),
                        rs.getString("requester_id"), rs.getString("owner_id"),
                        rs.getString("status"), rs.getObject("created_at", OffsetDateTime.class),
                        rs.getObject("updated_at", OffsetDateTime.class)
                ), listingId, requesterId
        );
    }

    private Map<String, Object> row(String id, String listingId, String requesterId, String ownerId,
                                    String status, OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("id", id);
        result.put("listingId", listingId);
        result.put("requesterId", requesterId);
        result.put("requesterName", displayName(requesterId));
        result.put("ownerId", ownerId);
        result.put("status", status);
        result.put("listing", store.listings().get(listingId));
        result.put("createdAt", createdAt == null ? null : createdAt.toInstant());
        result.put("updatedAt", updatedAt == null ? null : updatedAt.toInstant());
        return result;
    }

    private String displayName(String userId) {
        UserProfile user = store.users().get(userId);
        if (user == null) return "Bir kullanici";
        String name = ((user.ad() == null ? "" : user.ad()) + " " +
                (user.soyad() == null ? "" : user.soyad())).trim();
        return name.isEmpty() ? "Bir kullanici" : name;
    }
}
