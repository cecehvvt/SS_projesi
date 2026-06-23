package com.dayanisma.backend.service;

import com.dayanisma.backend.store.DataStore;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock
    private DataStore store;

    @Mock
    private JdbcTemplate jdbc;

    @Test
    void deleteMeDeletesOwnedListingsBeforeUser() {
        when(store.currentUserId()).thenReturn("user-42");
        when(jdbc.update(
                "DELETE FROM swap_requests WHERE owner_id=? OR requester_id=? " +
                        "OR listing_id IN (SELECT id FROM listings WHERE owner_id=?)",
                "user-42", "user-42", "user-42"
        )).thenReturn(2);
        when(jdbc.update("DELETE FROM listings WHERE owner_id=?", "user-42")).thenReturn(3);
        when(jdbc.update("DELETE FROM users WHERE id=?", "user-42")).thenReturn(1);

        UserService service = new UserService(store, jdbc);

        Map<String, Integer> result = service.deleteMe();

        assertEquals(3, result.get("silinenIlanSayisi"));
        InOrder order = inOrder(jdbc);
        order.verify(jdbc).update(
                "DELETE FROM swap_requests WHERE owner_id=? OR requester_id=? " +
                        "OR listing_id IN (SELECT id FROM listings WHERE owner_id=?)",
                "user-42", "user-42", "user-42"
        );
        order.verify(jdbc).update("DELETE FROM listings WHERE owner_id=?", "user-42");
        order.verify(jdbc).update("DELETE FROM users WHERE id=?", "user-42");
    }
}
