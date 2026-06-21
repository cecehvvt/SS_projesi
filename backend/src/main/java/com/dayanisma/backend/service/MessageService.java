package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.Message;
import com.dayanisma.backend.model.UserProfile;
import com.dayanisma.backend.store.DataStore;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Objects;

@Service
public class MessageService {
    private final DataStore store;

    public MessageService(DataStore store) {
        this.store = store;
    }

    public List<Map<String, Object>> conversations() {
        Map<String, Message> latestByChat = new LinkedHashMap<>();
        String currentUserId = store.currentUserId();
        for (Message message : store.allMessagesOrdered()) {
            if (!Objects.equals(message.gondericId(), currentUserId) && !Objects.equals(message.aliciId(), currentUserId)) {
                continue;
            }
            String otherId = message.otherParticipant(currentUserId);
            latestByChat.put(chatKey(otherId, message.ilanId()), message);
        }
        return latestByChat.values().stream()
                .sorted((left, right) -> right.gonderimZamani().compareTo(left.gonderimZamani()))
                .map(message -> summaryFor(message, currentUserId))
                .toList();
    }

    public List<Message> messagesWith(String otherUserId, String listingId) {
        String currentUserId = store.currentUserId();
        return store.allMessagesOrdered().stream()
                .filter(message ->
                        Objects.equals(message.gondericId(), currentUserId) && Objects.equals(message.aliciId(), otherUserId)
                                || Objects.equals(message.gondericId(), otherUserId) && Objects.equals(message.aliciId(), currentUserId)
                )
                .filter(message -> listingId == null || listingId.isBlank() || Objects.equals(message.ilanId(), listingId))
                .toList();
    }

    public Message send(Map<String, Object> request) {
        String receiverId = text(request, "aliciId", "");
        String content = text(request, "icerik", "").trim();
        String currentUserId = store.currentUserId();
        if (receiverId.isBlank()) {
            throw new IllegalArgumentException("Mesaj gonderilecek kullanici secilmedi.");
        }
        if (receiverId.equals(currentUserId)) {
            throw new IllegalArgumentException("Kendi ilaniniza mesaj gonderemezsiniz.");
        }
        if (store.users().get(receiverId) == null) {
            throw new IllegalArgumentException("Mesaj gonderilecek kullanici bulunamadi.");
        }
        String listingId = text(request, "ilanId", null);
        if (listingId != null && !listingId.isBlank() && store.listings().get(listingId) == null) {
            throw new IllegalArgumentException("Mesaj gonderilecek ilan bulunamadi.");
        }
        if (content.isBlank()) {
            throw new IllegalArgumentException("Mesaj bos olamaz.");
        }
        Message message = new Message(
                store.newId(),
                currentUserId,
                receiverId,
                listingId,
                content,
                Instant.now(),
                "gonderildi",
                false
        );
        store.messages().put(message.id(), message);
        return message;
    }

    public Message markRead(String id) {
        Message current = store.messages().get(id);
        if (current == null) {
            throw new NoSuchElementException("Mesaj bulunamadi: " + id);
        }
        if (!Objects.equals(current.aliciId(), store.currentUserId())) {
            throw new AccessDeniedException("Bu mesaji okundu isaretleme yetkiniz yok.");
        }
        Message updated = current.markRead();
        store.messages().put(id, updated);
        return updated;
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null ? fallback : value.toString();
    }

    private String chatKey(String otherUserId, String listingId) {
        return otherUserId + "::" + (listingId == null ? "genel" : listingId);
    }

    private Map<String, Object> summaryFor(Message message, String currentUserId) {
        String otherId = message.otherParticipant(currentUserId);
        UserProfile otherUser = store.users().get(otherId);
        Listing listing = message.ilanId() == null ? null : store.listings().get(message.ilanId());
        return store.chatSummary(message, otherUser, listing, currentUserId);
    }
}
