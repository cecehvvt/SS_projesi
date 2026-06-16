package com.dayanisma.backend.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.Instant;
import java.util.List;

public record Listing(
        String id,
        String ownerId,
        String ownerName,
        String title,
        String description,
        String listingType,
        String category,
        String subCategory,
        String city,
        String district,
        String condition,
        String deliveryMethod,
        String contactPreference,
        String desiredSwapItem,
        List<String> imageUrls,
        String status,
        Instant createdAt,
        Instant updatedAt,
        boolean urgent,
        boolean favorite
) {
    public Listing withFavorite(boolean value) {
        return new Listing(
                id,
                ownerId,
                ownerName,
                title,
                description,
                listingType,
                category,
                subCategory,
                city,
                district,
                condition,
                deliveryMethod,
                contactPreference,
                desiredSwapItem,
                imageUrls,
                status,
                createdAt,
                updatedAt,
                urgent,
                value
        );
    }

    public Listing withStatus(String value) {
        return new Listing(
                id,
                ownerId,
                ownerName,
                title,
                description,
                listingType,
                category,
                subCategory,
                city,
                district,
                condition,
                deliveryMethod,
                contactPreference,
                desiredSwapItem,
                imageUrls,
                value,
                createdAt,
                Instant.now(),
                urgent,
                favorite
        );
    }

    @JsonProperty("ilanSahibiId")
    public String legacyOwnerId() {
        return ownerId;
    }

    @JsonProperty("ilanSahibiAdSoyad")
    public String legacyOwnerName() {
        return ownerName;
    }

    @JsonProperty("ilanTuru")
    public String legacyListingType() {
        return listingType;
    }

    @JsonProperty("fotografUrls")
    public List<String> legacyImageUrls() {
        return imageUrls;
    }

    @JsonProperty("baslik")
    public String legacyTitle() {
        return title;
    }

    @JsonProperty("aciklama")
    public String legacyDescription() {
        return description;
    }

    @JsonProperty("kategori")
    public String legacyCategory() {
        return category;
    }

    @JsonProperty("urunDurumu")
    public String legacyCondition() {
        return condition;
    }

    @JsonProperty("adet")
    public int legacyQuantity() {
        return 1;
    }

    @JsonProperty("acilBitisTarihi")
    public Instant legacyUrgentUntil() {
        return createdAt.plusSeconds(7 * 24 * 60 * 60);
    }

    @JsonProperty("konum")
    public String legacyLocation() {
        return district + ", " + city;
    }

    @JsonProperty("gizliPaylasim")
    public boolean legacyPrivateShare() {
        return false;
    }

    @JsonProperty("acilMi")
    public boolean legacyUrgent() {
        return urgent;
    }

    @JsonProperty("favorilendi")
    public boolean legacyFavorite() {
        return favorite;
    }

    @JsonProperty("olusturmaTarihi")
    public Instant legacyCreatedAt() {
        return createdAt;
    }

    @JsonProperty("aktif")
    public boolean legacyActive() {
        return "active".equals(status);
    }
}
