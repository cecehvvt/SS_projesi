package com.dayanisma.backend.model;

public record PrivacySettings(
        boolean profilBaskalarinaGorunsun,
        boolean mesajAlabilir,
        boolean konumuIlanlardaGoster
) {
    public static PrivacySettings defaults() {
        return new PrivacySettings(true, true, false);
    }
}
