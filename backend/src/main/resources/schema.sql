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

ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS password_hash TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS refresh_token_hash TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS ad TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS soyad TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS tc_kimlik_no TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS adres TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS eposta_veya_telefon TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS kullanici_adi TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS hakkinda TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS konum TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS telefon_numarasi TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS eposta TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS profil_foto_url TEXT;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS gizlilik_profil_gorunur BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS gizlilik_mesaj_alabilir BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS gizlilik_konum_goster BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS kayit_tarihi TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS users ADD COLUMN IF NOT EXISTS aktif BOOLEAN NOT NULL DEFAULT TRUE;

CREATE TABLE IF NOT EXISTS auth_tokens (
    token_hash TEXT PRIMARY KEY,
    user_id    TEXT        NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS auth_tokens ADD COLUMN IF NOT EXISTS user_id TEXT;
ALTER TABLE IF EXISTS auth_tokens ADD COLUMN IF NOT EXISTS token_hash TEXT;
ALTER TABLE IF EXISTS auth_tokens ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS auth_tokens ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_auth_tokens_user ON auth_tokens (user_id);
CREATE INDEX IF NOT EXISTS idx_auth_tokens_expires ON auth_tokens (expires_at);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    token_hash TEXT PRIMARY KEY,
    user_id    TEXT        NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at    TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS password_reset_tokens ADD COLUMN IF NOT EXISTS token_hash TEXT;
ALTER TABLE IF EXISTS password_reset_tokens ADD COLUMN IF NOT EXISTS user_id TEXT;
ALTER TABLE IF EXISTS password_reset_tokens ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS password_reset_tokens ADD COLUMN IF NOT EXISTS used_at TIMESTAMPTZ;
ALTER TABLE IF EXISTS password_reset_tokens ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_user ON password_reset_tokens (user_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_expires ON password_reset_tokens (expires_at);

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

ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS owner_id TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS owner_name TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS listing_type TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS category TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS sub_category TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS district TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS condition TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS delivery_method TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS contact_preference TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS desired_swap_item TEXT;
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS image_urls TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS listings ADD COLUMN IF NOT EXISTS urgent BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS listing_photos (
    id         TEXT PRIMARY KEY,
    listing_id TEXT        NOT NULL,
    url        TEXT        NOT NULL,
    sort_order INTEGER     NOT NULL DEFAULT 0,
    is_cover   BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS id TEXT;
ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS listing_id TEXT;
ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS url TEXT;
ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS sort_order INTEGER NOT NULL DEFAULT 0;
ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS is_cover BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE IF EXISTS listing_photos ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_listing_photos_listing ON listing_photos (listing_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_listing_photos_cover ON listing_photos (listing_id) WHERE is_cover = TRUE;

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

ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS gonderic_id TEXT;
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS alici_id TEXT;
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS ilan_id TEXT;
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS icerik TEXT;
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS gonderim_zamani TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS durum TEXT;
ALTER TABLE IF EXISTS messages ADD COLUMN IF NOT EXISTS silindi_mi BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS notifications (
    id               TEXT PRIMARY KEY,
    user_id          TEXT,
    ilan_id          TEXT,
    baslik           TEXT,
    mesaj            TEXT,
    olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now(),
    okundu           BOOLEAN     NOT NULL DEFAULT FALSE
);

ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS user_id TEXT;
ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS ilan_id TEXT;
ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS baslik TEXT;
ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS mesaj TEXT;
ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS notifications ADD COLUMN IF NOT EXISTS okundu BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS support_requests (
    id               TEXT PRIMARY KEY,
    user_id          TEXT,
    konu             TEXT,
    mesaj            TEXT,
    olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now(),
    durum            TEXT
);

ALTER TABLE IF EXISTS support_requests ADD COLUMN IF NOT EXISTS user_id TEXT;
ALTER TABLE IF EXISTS support_requests ADD COLUMN IF NOT EXISTS konu TEXT;
ALTER TABLE IF EXISTS support_requests ADD COLUMN IF NOT EXISTS mesaj TEXT;
ALTER TABLE IF EXISTS support_requests ADD COLUMN IF NOT EXISTS olusturma_zamani TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS support_requests ADD COLUMN IF NOT EXISTS durum TEXT;

CREATE TABLE IF NOT EXISTS support_replies (
    id                 TEXT PRIMARY KEY,
    support_request_id TEXT        NOT NULL,
    sender_id          TEXT,
    message            TEXT        NOT NULL,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE IF EXISTS support_replies ADD COLUMN IF NOT EXISTS id TEXT;
ALTER TABLE IF EXISTS support_replies ADD COLUMN IF NOT EXISTS support_request_id TEXT;
ALTER TABLE IF EXISTS support_replies ADD COLUMN IF NOT EXISTS sender_id TEXT;
ALTER TABLE IF EXISTS support_replies ADD COLUMN IF NOT EXISTS message TEXT;
ALTER TABLE IF EXISTS support_replies ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_support_replies_request ON support_replies (support_request_id, created_at);
CREATE INDEX IF NOT EXISTS idx_support_replies_sender ON support_replies (sender_id);

CREATE TABLE IF NOT EXISTS favorites (
    listing_id TEXT NOT NULL,
    user_id    TEXT NOT NULL,
    PRIMARY KEY (listing_id, user_id)
);

ALTER TABLE IF EXISTS favorites ADD COLUMN IF NOT EXISTS listing_id TEXT;
ALTER TABLE IF EXISTS favorites ADD COLUMN IF NOT EXISTS user_id TEXT;

CREATE TABLE IF NOT EXISTS listing_requests (
    id           TEXT PRIMARY KEY,
    listing_id   TEXT        NOT NULL,
    requester_id TEXT        NOT NULL,
    status       TEXT        NOT NULL DEFAULT 'requested',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (listing_id, requester_id)
);

ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS listing_id TEXT;
ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS id TEXT;
ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS requester_id TEXT;
ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'requested';
ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS listing_requests ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_listings_status     ON listings (status);
CREATE INDEX IF NOT EXISTS idx_listings_owner      ON listings (owner_id);
CREATE INDEX IF NOT EXISTS idx_listings_location   ON listings (city, district);
CREATE INDEX IF NOT EXISTS idx_listings_type       ON listings (listing_type);
CREATE INDEX IF NOT EXISTS idx_listings_updated    ON listings (updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_gonderic   ON messages (gonderic_id);
CREATE INDEX IF NOT EXISTS idx_messages_alici      ON messages (alici_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user  ON notifications (user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_user      ON favorites (user_id);
CREATE INDEX IF NOT EXISTS idx_listing_requests_user ON listing_requests (requester_id);
CREATE INDEX IF NOT EXISTS idx_listing_requests_listing ON listing_requests (listing_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_listing_requests_listing_requester ON listing_requests (listing_id, requester_id);

CREATE TABLE IF NOT EXISTS swap_requests (
    id           TEXT PRIMARY KEY,
    listing_id   TEXT        NOT NULL,
    requester_id TEXT        NOT NULL,
    owner_id     TEXT        NOT NULL,
    status       TEXT        NOT NULL DEFAULT 'pending',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (listing_id, requester_id)
);

CREATE INDEX IF NOT EXISTS idx_swap_requests_owner ON swap_requests (owner_id, status, updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_swap_requests_requester ON swap_requests (requester_id, updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_chat ON messages (gonderic_id, alici_id, ilan_id, gonderim_zamani);
CREATE INDEX IF NOT EXISTS idx_users_eposta_veya_telefon ON users (lower(eposta_veya_telefon));
CREATE INDEX IF NOT EXISTS idx_users_eposta ON users (lower(eposta));
