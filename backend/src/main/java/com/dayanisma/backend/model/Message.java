package com.dayanisma.backend.model;

import java.time.Instant;

import java.util.Objects;

public record Message(
        String id,
        String gondericId,
        String aliciId,
        String ilanId,
        String icerik,
        Instant gonderimZamani,
        String durum,
        boolean silindiMi
) {
    public Message markRead() {
        return new Message(id, gondericId, aliciId, ilanId, icerik, gonderimZamani, "okundu", silindiMi);
    }

    public String otherParticipant(String currentUserId) {
        return Objects.equals(gondericId, currentUserId) ? aliciId : gondericId;
    }
}
