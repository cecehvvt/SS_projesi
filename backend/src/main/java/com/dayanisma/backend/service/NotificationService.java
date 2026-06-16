package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Notification;
import com.dayanisma.backend.observer.FavoriteEvent;
import com.dayanisma.backend.observer.FavoriteObserver;
import com.dayanisma.backend.store.InMemoryStore;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Set;

@Service
public class NotificationService implements FavoriteObserver {
    private final InMemoryStore store;

    public NotificationService(InMemoryStore store) {
        this.store = store;
    }

    @Override
    public void onFavoriteEvent(FavoriteEvent event) {
        Set<String> followerIds = store.favoriteUserIdsByListingId().getOrDefault(event.listingId(), Set.of());
        for (String followerId : followerIds) {
            if (!followerId.equals(event.actorUserId())) {
                create(followerId, event.listingId(), event.title(), event.message());
            }
        }
    }

    public Notification create(String userId, String listingId, String title, String message) {
        Notification notification = new Notification(
                store.newId(),
                userId,
                listingId,
                title,
                message,
                Instant.now(),
                false
        );
        store.notifications().put(notification.id(), notification);
        return notification;
    }

    public List<Notification> listMine() {
        return store.allNotificationsFor(store.currentUserId());
    }
}
