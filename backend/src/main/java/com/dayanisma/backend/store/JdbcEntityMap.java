package com.dayanisma.backend.store;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.util.AbstractMap;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 * Supabase Postgres tablosunu, eski bellek-ici {@code Map} arayuzu gibi gosteren
 * canli (read/write-through) koleksiyon. Boylece servis katmaninda
 * {@code store.listings().get(id)}, {@code ...put(id, x)}, {@code ...values()}
 * cagrilari degismeden calismaya devam eder, ancak veriler veritabanina yazilir.
 */
class JdbcEntityMap<T> extends AbstractMap<String, T> {
    private final JdbcTemplate jdbc;
    private final String table;
    private final RowMapper<T> mapper;
    private final Function<T, String> idOf;
    private final Consumer<T> upserter;

    JdbcEntityMap(JdbcTemplate jdbc, String table, RowMapper<T> mapper,
                  Function<T, String> idOf, Consumer<T> upserter) {
        this.jdbc = jdbc;
        this.table = table;
        this.mapper = mapper;
        this.idOf = idOf;
        this.upserter = upserter;
    }

    @Override
    public T get(Object key) {
        List<T> rows = jdbc.query("SELECT * FROM " + table + " WHERE id = ?", mapper, key);
        return rows.isEmpty() ? null : rows.get(0);
    }

    @Override
    public T put(String key, T value) {
        upserter.accept(value);
        return null;
    }

    @Override
    public Collection<T> values() {
        return jdbc.query("SELECT * FROM " + table, mapper);
    }

    @Override
    public Set<Map.Entry<String, T>> entrySet() {
        LinkedHashMap<String, T> snapshot = new LinkedHashMap<>();
        for (T value : values()) {
            snapshot.put(idOf.apply(value), value);
        }
        return snapshot.entrySet();
    }
}
