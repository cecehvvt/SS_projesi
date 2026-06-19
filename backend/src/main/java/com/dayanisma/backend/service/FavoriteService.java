package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.observer.FavoriteEvent;
import com.dayanisma.backend.observer.FavoriteEventPublisher;
import com.dayanisma.backend.store.DataStore;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

@Service
public class FavoriteService {
    private final DataStore store;
    private final ListingService listingService;
    private final NotificationService notificationService;
    private final FavoriteEventPublisher publisher;

    public FavoriteService(
            DataStore store,
            ListingService listingService,
            NotificationService notificationService,
            FavoriteEventPublisher publisher
    ) {
        this.store = store;
        this.listingService = listingService;
        this.notificationService = notificationService;
        this.publisher = publisher;
    }

    public List<Map<String, Object>> listMine() {
        return store.favoriteRowsForCurrentUser();
    }

    public Listing add(String listingId) {
        Listing listing = listingService.get(listingId);
        String currentUserId = store.currentUserId();
        store.favoriteUserIdsByListingId()
                .computeIfAbsent(listingId, ignored -> new LinkedHashSet<>())
                .add(currentUserId);

        notificationService.create(
                listing.ownerId(),
                listingId,
                "Ilan favorilendi",
                listing.title() + " ilani yeni bir kullanici tarafindan favorilendi."
        );
        publisher.publish(new FavoriteEvent(
                "favorite_added",
                listingId,
                currentUserId,
                "Takip ettiginiz ilanda hareket var",
                listing.title() + " ilani favorilere eklendi.",
                Instant.now()
        ));
        return listing.withFavorite(true);
    }

    public void remove(String listingId) {
        store.favoriteUserIdsByListingId()
                .getOrDefault(listingId, new LinkedHashSet<>())
                .remove(store.currentUserId());
    }

    public void notifyFollowers(String listingId, String actorUserId, String title, String message) {
        publisher.publish(new FavoriteEvent(
                "listing_changed",
                listingId,
                actorUserId,
                title,
                message,
                Instant.now()
        ));
    }
}
