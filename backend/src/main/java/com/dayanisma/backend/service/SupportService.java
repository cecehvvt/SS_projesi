package com.dayanisma.backend.service;

import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.store.DataStore;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@Service
public class SupportService {
    private final DataStore store;

    public SupportService(DataStore store) {
        this.store = store;
    }

    public SupportRequest create(Map<String, Object> request) {
        SupportRequest supportRequest = new SupportRequest(
                store.newId(),
                text(request, "userId", store.currentUserId()),
                text(request, "konu", "Genel"),
                text(request, "mesaj", ""),
                Instant.now(),
                "alindi"
        );
        store.supportRequests().put(supportRequest.id(), supportRequest);
        return supportRequest;
    }

    public List<SupportRequest> list() {
        return store.supportRequests().values().stream().toList();
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null ? fallback : value.toString();
    }
}
