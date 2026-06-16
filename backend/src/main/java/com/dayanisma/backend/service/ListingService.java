package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.store.InMemoryStore;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;

@Service
public class ListingService {
    private final InMemoryStore store;

    public ListingService(InMemoryStore store) {
        this.store = store;
    }

    public List<Listing> list(String tur, String kategori, String q) {
        String currentUserId = store.currentUserId();
        return store.listings().values().stream()
                .filter(listing -> "active".equals(listing.status()))
                .filter(listing -> tur == null || tur.isBlank() || listing.listingType().equalsIgnoreCase(tur))
                .filter(listing -> kategori == null || kategori.isBlank() || listing.category().equalsIgnoreCase(kategori))
                .filter(listing -> q == null || q.isBlank() || matchesSearch(listing, q))
                .map(listing -> listing.withFavorite(isFavorite(listing.id(), currentUserId)))
                .sorted((left, right) -> right.createdAt().compareTo(left.createdAt()))
                .toList();
    }

    public Listing get(String id) {
        Listing listing = store.listings().get(id);
        if (listing == null) {
            throw new NoSuchElementException("Ilan bulunamadi: " + id);
        }
        return listing.withFavorite(isFavorite(id, store.currentUserId()));
    }

    public Listing create(Map<String, Object> request) {
        String id = store.newId();
        Instant now = Instant.now();
        Listing listing = new Listing(
                id,
                text(request, "ownerId", text(request, "ilanSahibiId", store.currentUserId())),
                text(request, "ownerName", text(request, "ilanSahibiAdSoyad", "Ayse D.")),
                text(request, "title", text(request, "baslik", "Yeni Ilan")),
                text(request, "description", text(request, "aciklama", "Aciklama eklenmedi.")),
                text(request, "listingType", text(request, "ilanTuru", "bagis")),
                text(request, "category", text(request, "kategori", "Diger")),
                text(request, "subCategory", ""),
                text(request, "city", "Istanbul"),
                text(request, "district", districtFromLocation(text(request, "konum", "Istanbul"))),
                text(request, "condition", text(request, "urunDurumu", "Iyi")),
                text(request, "deliveryMethod", "Elden teslim"),
                text(request, "contactPreference", "Uygulama ici mesaj"),
                text(request, "desiredSwapItem", null),
                stringList(request, "imageUrls", "fotografUrls"),
                "active",
                now,
                now,
                bool(request, "urgent", bool(request, "acilMi", false)),
                false
        );
        store.addListing(listing);
        return listing;
    }

    public Listing update(String id, Map<String, Object> request) {
        Listing current = get(id);
        Listing updated = new Listing(
                current.id(),
                text(request, "ownerId", current.ownerId()),
                text(request, "ownerName", current.ownerName()),
                text(request, "title", text(request, "baslik", current.title())),
                text(request, "description", text(request, "aciklama", current.description())),
                text(request, "listingType", text(request, "ilanTuru", current.listingType())),
                text(request, "category", text(request, "kategori", current.category())),
                text(request, "subCategory", current.subCategory()),
                text(request, "city", current.city()),
                text(request, "district", current.district()),
                text(request, "condition", text(request, "urunDurumu", current.condition())),
                text(request, "deliveryMethod", current.deliveryMethod()),
                text(request, "contactPreference", current.contactPreference()),
                text(request, "desiredSwapItem", current.desiredSwapItem()),
                request.containsKey("imageUrls") || request.containsKey("fotografUrls")
                        ? stringList(request, "imageUrls", "fotografUrls")
                        : current.imageUrls(),
                text(request, "status", current.status()),
                current.createdAt(),
                Instant.now(),
                bool(request, "urgent", bool(request, "acilMi", current.urgent())),
                current.favorite()
        );
        store.listings().put(id, updated);
        return updated.withFavorite(isFavorite(id, store.currentUserId()));
    }

    public void delete(String id) {
        Listing current = get(id);
        store.listings().put(id, current.withStatus("deleted"));
    }

    public List<Listing> mine() {
        return list(null, null, null).stream()
                .filter(listing -> listing.ownerId().equals(store.currentUserId()))
                .toList();
    }

    private boolean matchesSearch(Listing listing, String q) {
        String lower = q.toLowerCase(Locale.ROOT);
        return listing.title().toLowerCase(Locale.ROOT).contains(lower)
                || listing.description().toLowerCase(Locale.ROOT).contains(lower)
                || listing.category().toLowerCase(Locale.ROOT).contains(lower)
                || listing.subCategory().toLowerCase(Locale.ROOT).contains(lower)
                || listing.city().toLowerCase(Locale.ROOT).contains(lower)
                || listing.district().toLowerCase(Locale.ROOT).contains(lower);
    }

    private boolean isFavorite(String listingId, String userId) {
        return store.favoriteUserIdsByListingId().getOrDefault(listingId, java.util.Set.of()).contains(userId);
    }

    private String text(Map<String, Object> request, String key, String fallback) {
        Object value = request.get(key);
        return value == null || value.toString().isBlank() ? fallback : value.toString();
    }

    @SuppressWarnings("unchecked")
    private List<String> stringList(Map<String, Object> request, String primaryKey, String legacyKey) {
        Object value = request.containsKey(primaryKey) ? request.get(primaryKey) : request.get(legacyKey);
        if (value instanceof List<?> list) {
            return (List<String>) list.stream().map(Object::toString).toList();
        }
        return List.of();
    }

    private boolean bool(Map<String, Object> request, String key, boolean fallback) {
        Object value = request.get(key);
        return value instanceof Boolean bool ? bool : fallback;
    }

    private String districtFromLocation(String location) {
        if (location == null || location.isBlank()) {
            return "";
        }
        return location.split(",")[0].trim();
    }
}
