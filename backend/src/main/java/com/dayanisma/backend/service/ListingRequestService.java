package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.store.DataStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class ListingRequestService {
    private final DataStore store;
    private final JdbcTemplate jdbc;

    public ListingRequestService(DataStore store, JdbcTemplate jdbc) {
        this.store = store;
        this.jdbc = jdbc;
    }

    public Map<String, Object> request(String listingId) {
        Listing listing = requireListing(listingId);
        String currentUserId = store.currentUserId();
        if (Objects.equals(listing.ownerId(), currentUserId)) {
            throw new IllegalArgumentException("Kendi ilaniniza talep olusturamazsiniz.");
        }
        jdbc.update(
                "INSERT INTO listing_requests (id, listing_id, requester_id, status, created_at, updated_at) " +
                        "VALUES (?,?,?,?,now(),now()) " +
                        "ON CONFLICT (listing_id, requester_id) DO UPDATE SET status='requested', updated_at=now()",
                store.newId(), listingId, currentUserId, "requested"
        );
        return rowFor(listingId, currentUserId);
    }

    public Map<String, Object> cancel(String listingId) {
        String currentUserId = store.currentUserId();
        jdbc.update(
                "UPDATE listing_requests SET status='cancelled', updated_at=now() WHERE listing_id=? AND requester_id=?",
                listingId, currentUserId
        );
        return rowFor(listingId, currentUserId);
    }

    public List<Map<String, Object>> mine() {
        String currentUserId = store.currentUserId();
        return jdbc.query(
                "SELECT id, listing_id, requester_id, status, created_at, updated_at " +
                        "FROM listing_requests WHERE requester_id=? AND status='requested' ORDER BY updated_at DESC",
                (rs, rowNum) -> {
                    Listing listing = store.listings().get(rs.getString("listing_id"));
                    Map<String, Object> row = requestMap(
                            rs.getString("id"),
                            rs.getString("listing_id"),
                            rs.getString("requester_id"),
                            rs.getString("status"),
                            rs.getObject("created_at", OffsetDateTime.class),
                            rs.getObject("updated_at", OffsetDateTime.class)
                    );
                    row.put("ilan", listing);
                    row.put("listing", listing);
                    return row;
                },
                currentUserId
        );
    }

    private Listing requireListing(String listingId) {
        Listing listing = store.listings().get(listingId);
        if (listing == null || !"active".equals(listing.status())) {
            throw new IllegalArgumentException("Talep edilecek aktif ilan bulunamadi.");
        }
        return listing;
    }

    private Map<String, Object> rowFor(String listingId, String requesterId) {
        List<Map<String, Object>> rows = jdbc.query(
                "SELECT id, listing_id, requester_id, status, created_at, updated_at " +
                        "FROM listing_requests WHERE listing_id=? AND requester_id=?",
                (rs, rowNum) -> requestMap(
                        rs.getString("id"),
                        rs.getString("listing_id"),
                        rs.getString("requester_id"),
                        rs.getString("status"),
                        rs.getObject("created_at", OffsetDateTime.class),
                        rs.getObject("updated_at", OffsetDateTime.class)
                ),
                listingId,
                requesterId
        );
        if (rows.isEmpty()) {
            return Map.of("listingId", listingId, "requesterId", requesterId, "status", "none");
        }
        Map<String, Object> row = rows.get(0);
        row.put("ilan", store.listings().get(listingId));
        row.put("listing", row.get("ilan"));
        return row;
    }

    private Map<String, Object> requestMap(
            String id,
            String listingId,
            String requesterId,
            String status,
            OffsetDateTime createdAt,
            OffsetDateTime updatedAt
    ) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("id", id);
        row.put("listingId", listingId);
        row.put("requesterId", requesterId);
        row.put("status", status);
        row.put("createdAt", createdAt == null ? null : createdAt.toInstant());
        row.put("updatedAt", updatedAt == null ? null : updatedAt.toInstant());
        return row;
    }
}
