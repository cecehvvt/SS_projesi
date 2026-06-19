package com.dayanisma.backend.store;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.AbstractMap;
import java.util.AbstractSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;

/**
 * {@code favorites} tablosunu, eski {@code Map<String, Set<String>>}
 * (ilanId -> favorileyen kullaniciId'leri) arayuzu gibi gosteren canli koleksiyon.
 * {@code computeIfAbsent}/{@code getOrDefault} her zaman veritabanina bagli canli bir
 * {@link JdbcFavoriteSet} dondurur; uzerindeki add/remove dogrudan Postgres'e yazar.
 */
class JdbcFavoriteMap extends AbstractMap<String, Set<String>> {
    private final JdbcTemplate jdbc;

    JdbcFavoriteMap(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public Set<String> get(Object key) {
        return new JdbcFavoriteSet(jdbc, String.valueOf(key));
    }

    @Override
    public Set<String> getOrDefault(Object key, Set<String> defaultValue) {
        return new JdbcFavoriteSet(jdbc, String.valueOf(key));
    }

    @Override
    public Set<String> computeIfAbsent(String key, Function<? super String, ? extends Set<String>> mappingFunction) {
        return new JdbcFavoriteSet(jdbc, key);
    }

    @Override
    public Set<Map.Entry<String, Set<String>>> entrySet() {
        Map<String, Set<String>> grouped = new LinkedHashMap<>();
        jdbc.query("SELECT listing_id, user_id FROM favorites", rs -> {
            grouped.computeIfAbsent(rs.getString("listing_id"), ignored -> new LinkedHashSet<>())
                    .add(rs.getString("user_id"));
        });
        return grouped.entrySet();
    }

    /**
     * Tek bir ilana ait favori kullanici kumesi; islemler dogrudan Postgres'e yansir.
     */
    static final class JdbcFavoriteSet extends AbstractSet<String> {
        private final JdbcTemplate jdbc;
        private final String listingId;

        JdbcFavoriteSet(JdbcTemplate jdbc, String listingId) {
            this.jdbc = jdbc;
            this.listingId = listingId;
        }

        @Override
        public boolean add(String userId) {
            return jdbc.update(
                    "INSERT INTO favorites (listing_id, user_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
                    listingId, userId) > 0;
        }

        @Override
        public boolean remove(Object userId) {
            return jdbc.update(
                    "DELETE FROM favorites WHERE listing_id = ? AND user_id = ?",
                    listingId, userId) > 0;
        }

        @Override
        public boolean contains(Object userId) {
            Integer count = jdbc.queryForObject(
                    "SELECT COUNT(*) FROM favorites WHERE listing_id = ? AND user_id = ?",
                    Integer.class, listingId, userId);
            return count != null && count > 0;
        }

        @Override
        public int size() {
            Integer count = jdbc.queryForObject(
                    "SELECT COUNT(*) FROM favorites WHERE listing_id = ?",
                    Integer.class, listingId);
            return count == null ? 0 : count;
        }

        @Override
        public Iterator<String> iterator() {
            return jdbc.queryForList(
                    "SELECT user_id FROM favorites WHERE listing_id = ?",
                    String.class, listingId).iterator();
        }
    }
}
