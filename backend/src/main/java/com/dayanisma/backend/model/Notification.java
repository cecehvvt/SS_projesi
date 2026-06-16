package com.dayanisma.backend.model;

import java.time.Instant;

public record Notification(
        String id,
        String userId,
        String ilanId,
        String baslik,
        String mesaj,
        Instant olusturmaZamani,
        boolean okundu
) {
}
