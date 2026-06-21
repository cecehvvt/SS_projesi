package com.dayanisma.backend.service;

import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.store.DataStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Objects;

@Service
public class SupportService {
    private final DataStore store;
    private final JdbcTemplate jdbc;

    public SupportService(DataStore store, JdbcTemplate jdbc) {
        this.store = store;
        this.jdbc = jdbc;
    }

    public SupportRequest create(Map<String, Object> request) {
        SupportRequest supportRequest = new SupportRequest(
                store.newId(),
                store.currentUserId(),
                text(request, "konu", "Genel"),
                text(request, "mesaj", ""),
                Instant.now(),
                "alindi"
        );
        store.supportRequests().put(supportRequest.id(), supportRequest);
        return supportRequest;
    }

    public List<SupportRequest> list() {
        String currentUserId = store.currentUserId();
        return store.supportRequests().values().stream()
                .filter(request -> currentUserId.equals(request.userId()))
                .toList();
    }

    public List<Map<String, Object>> replies(String supportRequestId) {
        requireOwnedRequest(supportRequestId);
        return jdbc.query(
                "SELECT id, support_request_id, sender_id, message, created_at " +
                        "FROM support_replies WHERE support_request_id=? ORDER BY created_at ASC",
                (rs, rowNum) -> Map.of(
                        "id", rs.getString("id"),
                        "supportRequestId", rs.getString("support_request_id"),
                        "senderId", rs.getString("sender_id"),
                        "message", rs.getString("message"),
                        "createdAt", rs.getObject("created_at", OffsetDateTime.class).toInstant()
                ),
                supportRequestId
        );
    }

    public Map<String, Object> addReply(String supportRequestId, Map<String, Object> request) {
        requireOwnedRequest(supportRequestId);
        String message = text(request, "message", text(request, "mesaj", "")).trim();
        if (message.isBlank()) {
            throw new IllegalArgumentException("Cevap mesaji zorunludur.");
        }
        String id = store.newId();
        String senderId = store.currentUserId();
        jdbc.update(
                "INSERT INTO support_replies (id, support_request_id, sender_id, message, created_at) VALUES (?,?,?,?,now())",
                id,
                supportRequestId,
                senderId,
                message
        );
        return replies(supportRequestId).stream()
                .filter(row -> Objects.equals(row.get("id"), id))
                .findFirst()
                .orElse(Map.of("id", id, "supportRequestId", supportRequestId, "senderId", senderId, "message", message));
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null ? fallback : value.toString();
    }

    private SupportRequest requireOwnedRequest(String supportRequestId) {
        SupportRequest supportRequest = store.supportRequests().get(supportRequestId);
        if (supportRequest == null) {
            throw new NoSuchElementException("Destek talebi bulunamadi: " + supportRequestId);
        }
        if (!Objects.equals(supportRequest.userId(), store.currentUserId())) {
            throw new IllegalArgumentException("Bu destek talebi uzerinde islem yapma yetkiniz yok.");
        }
        return supportRequest;
    }
}
