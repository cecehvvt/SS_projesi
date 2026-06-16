package com.dayanisma.backend.observer;

import java.time.Instant;

public record FavoriteEvent(
        String type,
        String listingId,
        String actorUserId,
        String title,
        String message,
        Instant occurredAt
) {
}
