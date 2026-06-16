package com.dayanisma.backend.model;

import java.time.Instant;

public record SupportRequest(
        String id,
        String userId,
        String konu,
        String mesaj,
        Instant olusturmaZamani,
        String durum
) {
}
