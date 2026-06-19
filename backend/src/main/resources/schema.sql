-- Dayanisma App - Supabase Postgres semasi
-- Uygulama acilisinda otomatik calisir (spring.sql.init.mode=always).

CREATE TABLE IF NOT EXISTS users (
    id                       TEXT PRIMARY KEY,
    ad                       TEXT,
    soyad                    TEXT,
    tc_kimlik_no             TEXT,
    adres                    TEXT,
    eposta_veya_telefon      TEXT,
    kullanici_adi            TEXT,
    hakkinda                 TEXT,
    konum                    TEXT,
    telefon_numarasi         TEXT,
    eposta                   TEXT,
    profil_foto_url          TEXT,
    gizlilik_profil_gorunur  BOOLEAN     NOT NULL DEFAULT TRUE,
    gizlilik_mesaj_alabilir  BOOLEAN     NOT NULL DEFAULT TRUE,
    gizlilik_konum_goster    BOOLEAN     NOT NULL DEFAULT FALSE,
    kayit_tarihi             TIMESTAMPTZ NOT NULL DEFAULT now(),
    aktif                    BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS listings (
    id                  TEXT PRIMARY KEY,
    owner_id            TEXT,
    owner_name          TEXT,
    title               TEXT,
    description         TEXT,
    listing_type        TEXT,
    category            TEXT,
    sub_category        TEXT,
    city                TEXT,
    district            TEXT,
    condition           TEXT,
    delivery_method     TEXT,
    contact_preference  TEXT,
    desired_swap_item   TEXT,
    image_urls          TEXT[]      NOT NULL DEFAULT '{}',
    status              TEXT        NOT NULL DEFAULT 'active',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    urgent              BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS messages (
    id              TEXT PRIMARY KEY,
    gonderic_id     TEXT,
    alici_id        TEXT,
    ilan_id         TEXT,
    icerik          TEXT,
    gonderim_zamani TIMESTAMPTZ NOT NULL DEFAULT now(),
    durum           TEXT,
    silindi_mi      BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS notifications (
    id               TEXT PRIMARY KEY,
    user_id          TEXT,
    ilan_id          TEXT,
    baslik           TEXT,
    mesaj            TEXT,
    olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now(),
    okundu           BOOLEAN     NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS support_requests (
    id               TEXT PRIMARY KEY,
    user_id          TEXT,
    konu             TEXT,
    mesaj            TEXT,
    olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now(),
    durum            TEXT
);

CREATE TABLE IF NOT EXISTS favorites (
    listing_id TEXT NOT NULL,
    user_id    TEXT NOT NULL,
    PRIMARY KEY (listing_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_listings_status     ON listings (status);
CREATE INDEX IF NOT EXISTS idx_messages_gonderic   ON messages (gonderic_id);
CREATE INDEX IF NOT EXISTS idx_messages_alici      ON messages (alici_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user  ON notifications (user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_user      ON favorites (user_id);
