package com.dayanisma.backend.service;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.store.DataStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Objects;

@Service
public class ListingService {
    private final DataStore store;
    private final UserService userService;
    private final JdbcTemplate jdbc;

    public ListingService(DataStore store, UserService userService, JdbcTemplate jdbc) {
        this.store = store;
        this.userService = userService;
        this.jdbc = jdbc;
    }

    public List<Listing> list(String tur, String kategori, String q) {
        return list(tur, kategori, null, null, q);
    }

    public List<Listing> list(String tur, String kategori, String durum, Boolean acil, String q) {
        String currentUserId = store.currentUserIdOrNull();
        return store.listings().values().stream()
                .filter(listing -> "active".equals(listing.status()))
                .filter(listing -> tur == null || tur.isBlank() || equalsIgnoreCase(listing.listingType(), tur))
                .filter(listing -> kategori == null || kategori.isBlank() || equalsIgnoreCase(listing.category(), kategori))
                .filter(listing -> durum == null || durum.isBlank() || equalsIgnoreCase(listing.condition(), durum))
                .filter(listing -> acil == null || listing.urgent() == acil)
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
        return listing.withFavorite(isFavorite(id, store.currentUserIdOrNull()));
    }

    public Listing create(Map<String, Object> request) {
        String currentUserId = store.currentUserId();
        String title = requiredText(request, "title", "baslik");
        String description = requiredText(request, "description", "aciklama");
        String listingType = requiredText(request, "listingType", "ilanTuru");
        String category = requiredText(request, "category", "kategori");
        var owner = userService.get(currentUserId);
        String id = store.newId();
        Instant now = Instant.now();
        Listing listing = new Listing(
                id,
                currentUserId,
                displayName(owner.ad(), owner.soyad()),
                title,
                description,
                listingType,
                category,
                text(request, "subCategory", text(request, "altKategori", "")),
                text(request, "city", cityFromLocation(text(request, "konum", "Istanbul"))),
                text(request, "district", districtFromLocation(text(request, "konum", "Istanbul"))),
                text(request, "condition", text(request, "urunDurumu", "Iyi")),
                text(request, "deliveryMethod", text(request, "teslimYontemi", "Elden teslim")),
                text(request, "contactPreference", text(request, "iletisimTercihi", "Uygulama ici mesaj")),
                text(request, "desiredSwapItem", text(request, "istenenTakasUrunu", null)),
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
        assertOwner(current);
        Listing updated = new Listing(
                current.id(),
                current.ownerId(),
                current.ownerName(),
                text(request, "title", text(request, "baslik", current.title())),
                text(request, "description", text(request, "aciklama", current.description())),
                text(request, "listingType", text(request, "ilanTuru", current.listingType())),
                text(request, "category", text(request, "kategori", current.category())),
                text(request, "subCategory", text(request, "altKategori", current.subCategory())),
                text(request, "city", text(request, "sehir", current.city())),
                text(request, "district", text(request, "ilce", current.district())),
                text(request, "condition", text(request, "urunDurumu", current.condition())),
                text(request, "deliveryMethod", text(request, "teslimYontemi", current.deliveryMethod())),
                text(request, "contactPreference", text(request, "iletisimTercihi", current.contactPreference())),
                text(request, "desiredSwapItem", text(request, "istenenTakasUrunu", current.desiredSwapItem())),
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
        assertOwner(current);
        store.listings().put(id, current.withStatus("deleted"));
    }

    public List<Listing> mine() {
        return list(null, null, null).stream()
                .filter(listing -> Objects.equals(listing.ownerId(), store.currentUserId()))
                .toList();
    }

    public List<Map<String, Object>> photos(String listingId) {
        Listing listing = get(listingId);
        return photoRows(listing.id());
    }

    public Map<String, Object> addPhoto(String listingId, Map<String, Object> request) {
        Listing listing = get(listingId);
        assertOwner(listing);
        String url = requiredText(request, "url", "fotoUrl");
        int sortOrder = intValue(request, "sortOrder", photoRows(listingId).size());
        boolean isCover = bool(request, "isCover", bool(request, "kapakMi", listing.imageUrls().isEmpty()));
        if (isCover) {
            jdbc.update("UPDATE listing_photos SET is_cover=FALSE WHERE listing_id=?", listingId);
        }
        String photoId = store.newId();
        jdbc.update(
                "INSERT INTO listing_photos (id, listing_id, url, sort_order, is_cover, created_at) VALUES (?,?,?,?,?,now())",
                photoId,
                listingId,
                url,
                sortOrder,
                isCover
        );
        syncListingImageUrls(listingId);
        return photoRows(listingId).stream()
                .filter(row -> Objects.equals(row.get("id"), photoId))
                .findFirst()
                .orElse(Map.of("id", photoId, "listingId", listingId, "url", url));
    }

    public Map<String, Object> deletePhoto(String listingId, String photoId) {
        Listing listing = get(listingId);
        assertOwner(listing);
        int affected = jdbc.update("DELETE FROM listing_photos WHERE id=? AND listing_id=?", photoId, listingId);
        if (affected == 0) {
            throw new NoSuchElementException("Fotograf bulunamadi: " + photoId);
        }
        syncListingImageUrls(listingId);
        return Map.of("id", photoId, "listingId", listingId, "deleted", true);
    }

    private boolean matchesSearch(Listing listing, String q) {
        String lower = q.toLowerCase(Locale.ROOT);
        return containsIgnoreCase(listing.title(), lower)
                || containsIgnoreCase(listing.description(), lower)
                || containsIgnoreCase(listing.category(), lower)
                || containsIgnoreCase(listing.subCategory(), lower)
                || containsIgnoreCase(listing.city(), lower)
                || containsIgnoreCase(listing.district(), lower);
    }

    private boolean isFavorite(String listingId, String userId) {
        if (userId == null || userId.isBlank()) {
            return false;
        }
        return store.favoriteUserIdsByListingId().getOrDefault(listingId, java.util.Set.of()).contains(userId);
    }

    private void assertOwner(Listing listing) {
        if (!Objects.equals(listing.ownerId(), store.currentUserId())) {
            throw new IllegalArgumentException("Bu ilan uzerinde islem yapma yetkiniz yok.");
        }
    }

    private boolean equalsIgnoreCase(String left, String right) {
        return left != null && right != null && left.equalsIgnoreCase(right);
    }

    private boolean containsIgnoreCase(String value, String lowerQuery) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(lowerQuery);
    }

    private String requiredText(Map<String, Object> request, String primaryKey, String legacyKey) {
        String value = text(request, primaryKey, text(request, legacyKey, ""));
        if (value.isBlank()) {
            throw new IllegalArgumentException(primaryKey + " alani zorunludur.");
        }
        return value;
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

    private int intValue(Map<String, Object> request, String key, int fallback) {
        Object value = request.get(key);
        if (value instanceof Number number) {
            return number.intValue();
        }
        if (value != null) {
            try {
                return Integer.parseInt(value.toString());
            } catch (NumberFormatException ignored) {
                return fallback;
            }
        }
        return fallback;
    }

    private List<Map<String, Object>> photoRows(String listingId) {
        return jdbc.query(
                "SELECT id, listing_id, url, sort_order, is_cover, created_at " +
                        "FROM listing_photos WHERE listing_id=? ORDER BY is_cover DESC, sort_order ASC, created_at ASC",
                (rs, rowNum) -> Map.of(
                        "id", rs.getString("id"),
                        "listingId", rs.getString("listing_id"),
                        "url", rs.getString("url"),
                        "sortOrder", rs.getInt("sort_order"),
                        "isCover", rs.getBoolean("is_cover"),
                        "createdAt", rs.getObject("created_at", OffsetDateTime.class).toInstant()
                ),
                listingId
        );
    }

    private void syncListingImageUrls(String listingId) {
        List<String> urls = new ArrayList<>(photoRows(listingId).stream()
                .map(row -> row.get("url").toString())
                .toList());
        Listing current = store.listings().get(listingId);
        if (current == null) {
            return;
        }
        Listing updated = new Listing(
                current.id(),
                current.ownerId(),
                current.ownerName(),
                current.title(),
                current.description(),
                current.listingType(),
                current.category(),
                current.subCategory(),
                current.city(),
                current.district(),
                current.condition(),
                current.deliveryMethod(),
                current.contactPreference(),
                current.desiredSwapItem(),
                urls,
                current.status(),
                current.createdAt(),
                Instant.now(),
                current.urgent(),
                current.favorite()
        );
        store.listings().put(listingId, updated);
    }

    private String districtFromLocation(String location) {
        if (location == null || location.isBlank()) {
            return "";
        }
        return location.split(",")[0].trim();
    }

    private String cityFromLocation(String location) {
        if (location == null || location.isBlank()) {
            return "Istanbul";
        }
        String[] parts = location.split(",");
        return parts.length > 1 ? parts[1].trim() : "Istanbul";
    }

    private String displayName(String firstName, String lastName) {
        String fullName = (firstName == null ? "" : firstName.trim()) + " " + (lastName == null ? "" : lastName.trim());
        return fullName.isBlank() ? "Vesta kullanicisi" : fullName.trim();
    }
}
