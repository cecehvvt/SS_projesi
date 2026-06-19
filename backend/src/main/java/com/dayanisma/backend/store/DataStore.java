package com.dayanisma.backend.store;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.Message;
import com.dayanisma.backend.model.Notification;
import com.dayanisma.backend.model.PrivacySettings;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.model.UserProfile;
import jakarta.annotation.PostConstruct;
import org.springframework.boot.sql.init.dependency.DependsOnDatabaseInitialization;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.sql.Array;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * Tum uygulama verisini Supabase Postgres uzerinde tutan veri katmani.
 *
 * <p>Onceki bellek-ici (RAM) surumun ({@code InMemoryStore}) genel API'si korunmustur:
 * {@code users()}, {@code listings()}, {@code favoriteUserIdsByListingId()} gibi metotlar
 * hala {@code Map} dondurur, ancak bu Map'ler {@link JdbcEntityMap}/{@link JdbcFavoriteMap}
 * araciligiyla dogrudan veritabanina okur/yazar. Boylece servis katmaninda hicbir degisiklik
 * gerekmeden veriler kalici hale gelir.</p>
 */
@Component
@DependsOnDatabaseInitialization
public class DataStore {
    private static final String CURRENT_USER_ID = "user-1";

    private final JdbcTemplate jdbc;

    private final Map<String, UserProfile> users;
    private final Map<String, Listing> listings;
    private final Map<String, Message> messages;
    private final Map<String, Notification> notifications;
    private final Map<String, SupportRequest> supportRequests;
    private final JdbcFavoriteMap favoriteUserIdsByListingId;

    public DataStore(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
        this.users = new JdbcEntityMap<>(jdbc, "users", USER_MAPPER, UserProfile::id, this::upsertUser);
        this.listings = new JdbcEntityMap<>(jdbc, "listings", LISTING_MAPPER, Listing::id, this::upsertListing);
        this.messages = new JdbcEntityMap<>(jdbc, "messages", MESSAGE_MAPPER, Message::id, this::upsertMessage);
        this.notifications = new JdbcEntityMap<>(jdbc, "notifications", NOTIFICATION_MAPPER, Notification::id, this::upsertNotification);
        this.supportRequests = new JdbcEntityMap<>(jdbc, "support_requests", SUPPORT_MAPPER, SupportRequest::id, this::upsertSupportRequest);
        this.favoriteUserIdsByListingId = new JdbcFavoriteMap(jdbc);
    }

    @PostConstruct
    void seed() {
        // Varsayilan kullaniciyi yalnizca yoksa ekle (mevcut verileri ezme).
        jdbc.update(
                "INSERT INTO users (id, ad, soyad, tc_kimlik_no, adres, eposta_veya_telefon, kullanici_adi, " +
                        "hakkinda, konum, telefon_numarasi, eposta, profil_foto_url, gizlilik_profil_gorunur, " +
                        "gizlilik_mesaj_alabilir, gizlilik_konum_goster, kayit_tarihi, aktif) " +
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ON CONFLICT (id) DO NOTHING",
                CURRENT_USER_ID, "Ayse", "Demir", "11111111111", "Uskudar, Istanbul",
                "ayse@example.com", "@aysedemir34", "Paylasmayi seven Vesta kullanicisi.",
                "Uskudar, Istanbul", "+90 555 000 0001", "ayse@example.com", null,
                true, true, false, ts(Instant.now().minus(30, ChronoUnit.DAYS)), true);
    }

    public String currentUserId() {
        return CURRENT_USER_ID;
    }

    public String newId() {
        return UUID.randomUUID().toString();
    }

    public Map<String, UserProfile> users() {
        return users;
    }

    public Map<String, Listing> listings() {
        return listings;
    }

    public Map<String, Message> messages() {
        return messages;
    }

    public Map<String, Notification> notifications() {
        return notifications;
    }

    public Map<String, SupportRequest> supportRequests() {
        return supportRequests;
    }

    public Map<String, Set<String>> favoriteUserIdsByListingId() {
        return favoriteUserIdsByListingId;
    }

    public void addListing(Listing listing) {
        listings.put(listing.id(), listing);
    }

    public void addMessage(Message message) {
        messages.put(message.id(), message);
    }

    public List<Message> allMessagesOrdered() {
        return messages.values().stream()
                .sorted((left, right) -> left.gonderimZamani().compareTo(right.gonderimZamani()))
                .toList();
    }

    public List<Notification> allNotificationsFor(String userId) {
        return notifications.values().stream()
                .filter(notification -> notification.userId().equals(userId))
                .sorted((left, right) -> right.olusturmaZamani().compareTo(left.olusturmaZamani()))
                .toList();
    }

    public Map<String, Object> chatSummary(Message message, UserProfile otherUser, Listing listing) {
        Map<String, Object> summary = new LinkedHashMap<>();
        String otherUserId = otherUser == null ? message.otherParticipant(CURRENT_USER_ID) : otherUser.id();
        String otherUserName = otherUser == null
                ? (listing == null ? "Vesta kullanicisi" : listing.ownerName())
                : otherUser.ad() + " " + otherUser.soyad().charAt(0) + ".";
        summary.put("karsiKullaniciId", otherUserId);
        summary.put("karsiKullaniciAd", otherUserName);
        summary.put("karsiKullaniciAvatarUrl", otherUser == null ? null : otherUser.profilFotoUrl());
        summary.put("ilanId", listing == null ? null : listing.id());
        summary.put("ilanBaslik", listing == null ? null : listing.title());
        summary.put("ilanKonum", listing == null ? null : listing.district() + ", " + listing.city());
        summary.put("ilanFotoUrl", listing == null || listing.imageUrls().isEmpty() ? null : listing.imageUrls().get(0));
        summary.put("sonMesajIcerik", message.icerik());
        summary.put("sonMesajZamani", message.gonderimZamani());
        summary.put("okunmamisSayi", message.aliciId().equals(CURRENT_USER_ID) && !"okundu".equals(message.durum()) ? 1 : 0);
        return summary;
    }

    public List<Map<String, Object>> favoriteRowsForCurrentUser() {
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Map.Entry<String, Set<String>> entry : favoriteUserIdsByListingId.entrySet()) {
            if (entry.getValue().contains(CURRENT_USER_ID)) {
                Listing listing = listings.get(entry.getKey());
                if (listing != null) {
                    rows.add(Map.of("ilan", listing.withFavorite(true), "favoriTakipciSayisi", entry.getValue().size()));
                }
            }
        }
        return rows;
    }

    // ---------------------------------------------------------------------
    // RowMapper'lar (satir -> record)
    // ---------------------------------------------------------------------

    private static final RowMapper<UserProfile> USER_MAPPER = (rs, rowNum) -> new UserProfile(
            rs.getString("id"),
            rs.getString("ad"),
            rs.getString("soyad"),
            rs.getString("tc_kimlik_no"),
            rs.getString("adres"),
            rs.getString("eposta_veya_telefon"),
            rs.getString("kullanici_adi"),
            rs.getString("hakkinda"),
            rs.getString("konum"),
            rs.getString("telefon_numarasi"),
            rs.getString("eposta"),
            rs.getString("profil_foto_url"),
            new PrivacySettings(
                    rs.getBoolean("gizlilik_profil_gorunur"),
                    rs.getBoolean("gizlilik_mesaj_alabilir"),
                    rs.getBoolean("gizlilik_konum_goster")),
            instant(rs, "kayit_tarihi"),
            rs.getBoolean("aktif"));

    private static final RowMapper<Listing> LISTING_MAPPER = (rs, rowNum) -> new Listing(
            rs.getString("id"),
            rs.getString("owner_id"),
            rs.getString("owner_name"),
            rs.getString("title"),
            rs.getString("description"),
            rs.getString("listing_type"),
            rs.getString("category"),
            rs.getString("sub_category"),
            rs.getString("city"),
            rs.getString("district"),
            rs.getString("condition"),
            rs.getString("delivery_method"),
            rs.getString("contact_preference"),
            rs.getString("desired_swap_item"),
            stringList(rs.getArray("image_urls")),
            rs.getString("status"),
            instant(rs, "created_at"),
            instant(rs, "updated_at"),
            rs.getBoolean("urgent"),
            false);

    private static final RowMapper<Message> MESSAGE_MAPPER = (rs, rowNum) -> new Message(
            rs.getString("id"),
            rs.getString("gonderic_id"),
            rs.getString("alici_id"),
            rs.getString("ilan_id"),
            rs.getString("icerik"),
            instant(rs, "gonderim_zamani"),
            rs.getString("durum"),
            rs.getBoolean("silindi_mi"));

    private static final RowMapper<Notification> NOTIFICATION_MAPPER = (rs, rowNum) -> new Notification(
            rs.getString("id"),
            rs.getString("user_id"),
            rs.getString("ilan_id"),
            rs.getString("baslik"),
            rs.getString("mesaj"),
            instant(rs, "olusturma_zamani"),
            rs.getBoolean("okundu"));

    private static final RowMapper<SupportRequest> SUPPORT_MAPPER = (rs, rowNum) -> new SupportRequest(
            rs.getString("id"),
            rs.getString("user_id"),
            rs.getString("konu"),
            rs.getString("mesaj"),
            instant(rs, "olusturma_zamani"),
            rs.getString("durum"));

    // ---------------------------------------------------------------------
    // Upsert'ler (record -> satir)
    // ---------------------------------------------------------------------

    private void upsertUser(UserProfile u) {
        PrivacySettings p = u.gizlilikAyarlari() == null ? PrivacySettings.defaults() : u.gizlilikAyarlari();
        jdbc.update(
                "INSERT INTO users (id, ad, soyad, tc_kimlik_no, adres, eposta_veya_telefon, kullanici_adi, " +
                        "hakkinda, konum, telefon_numarasi, eposta, profil_foto_url, gizlilik_profil_gorunur, " +
                        "gizlilik_mesaj_alabilir, gizlilik_konum_goster, kayit_tarihi, aktif) " +
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) " +
                        "ON CONFLICT (id) DO UPDATE SET ad=EXCLUDED.ad, soyad=EXCLUDED.soyad, " +
                        "tc_kimlik_no=EXCLUDED.tc_kimlik_no, adres=EXCLUDED.adres, " +
                        "eposta_veya_telefon=EXCLUDED.eposta_veya_telefon, kullanici_adi=EXCLUDED.kullanici_adi, " +
                        "hakkinda=EXCLUDED.hakkinda, konum=EXCLUDED.konum, telefon_numarasi=EXCLUDED.telefon_numarasi, " +
                        "eposta=EXCLUDED.eposta, profil_foto_url=EXCLUDED.profil_foto_url, " +
                        "gizlilik_profil_gorunur=EXCLUDED.gizlilik_profil_gorunur, " +
                        "gizlilik_mesaj_alabilir=EXCLUDED.gizlilik_mesaj_alabilir, " +
                        "gizlilik_konum_goster=EXCLUDED.gizlilik_konum_goster, " +
                        "kayit_tarihi=EXCLUDED.kayit_tarihi, aktif=EXCLUDED.aktif",
                u.id(), u.ad(), u.soyad(), u.tcKimlikNo(), u.adres(), u.epostaVeyaTelefon(), u.kullaniciAdi(),
                u.hakkinda(), u.konum(), u.telefonNumarasi(), u.eposta(), u.profilFotoUrl(),
                p.profilBaskalarinaGorunsun(), p.mesajAlabilir(), p.konumuIlanlardaGoster(),
                ts(u.kayitTarihi()), u.aktif());
    }

    private void upsertListing(Listing l) {
        jdbc.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO listings (id, owner_id, owner_name, title, description, listing_type, category, " +
                            "sub_category, city, district, condition, delivery_method, contact_preference, " +
                            "desired_swap_item, image_urls, status, created_at, updated_at, urgent) " +
                            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) " +
                            "ON CONFLICT (id) DO UPDATE SET owner_id=EXCLUDED.owner_id, owner_name=EXCLUDED.owner_name, " +
                            "title=EXCLUDED.title, description=EXCLUDED.description, listing_type=EXCLUDED.listing_type, " +
                            "category=EXCLUDED.category, sub_category=EXCLUDED.sub_category, city=EXCLUDED.city, " +
                            "district=EXCLUDED.district, condition=EXCLUDED.condition, " +
                            "delivery_method=EXCLUDED.delivery_method, contact_preference=EXCLUDED.contact_preference, " +
                            "desired_swap_item=EXCLUDED.desired_swap_item, image_urls=EXCLUDED.image_urls, " +
                            "status=EXCLUDED.status, created_at=EXCLUDED.created_at, updated_at=EXCLUDED.updated_at, " +
                            "urgent=EXCLUDED.urgent");
            ps.setString(1, l.id());
            ps.setString(2, l.ownerId());
            ps.setString(3, l.ownerName());
            ps.setString(4, l.title());
            ps.setString(5, l.description());
            ps.setString(6, l.listingType());
            ps.setString(7, l.category());
            ps.setString(8, l.subCategory());
            ps.setString(9, l.city());
            ps.setString(10, l.district());
            ps.setString(11, l.condition());
            ps.setString(12, l.deliveryMethod());
            ps.setString(13, l.contactPreference());
            ps.setString(14, l.desiredSwapItem());
            List<String> urls = l.imageUrls() == null ? List.of() : l.imageUrls();
            Array array = connection.createArrayOf("text", urls.toArray());
            ps.setArray(15, array);
            ps.setString(16, l.status());
            ps.setObject(17, ts(l.createdAt()));
            ps.setObject(18, ts(l.updatedAt()));
            ps.setBoolean(19, l.urgent());
            return ps;
        });
    }

    private void upsertMessage(Message m) {
        jdbc.update(
                "INSERT INTO messages (id, gonderic_id, alici_id, ilan_id, icerik, gonderim_zamani, durum, silindi_mi) " +
                        "VALUES (?,?,?,?,?,?,?,?) " +
                        "ON CONFLICT (id) DO UPDATE SET gonderic_id=EXCLUDED.gonderic_id, alici_id=EXCLUDED.alici_id, " +
                        "ilan_id=EXCLUDED.ilan_id, icerik=EXCLUDED.icerik, gonderim_zamani=EXCLUDED.gonderim_zamani, " +
                        "durum=EXCLUDED.durum, silindi_mi=EXCLUDED.silindi_mi",
                m.id(), m.gondericId(), m.aliciId(), m.ilanId(), m.icerik(),
                ts(m.gonderimZamani()), m.durum(), m.silindiMi());
    }

    private void upsertNotification(Notification n) {
        jdbc.update(
                "INSERT INTO notifications (id, user_id, ilan_id, baslik, mesaj, olusturma_zamani, okundu) " +
                        "VALUES (?,?,?,?,?,?,?) " +
                        "ON CONFLICT (id) DO UPDATE SET user_id=EXCLUDED.user_id, ilan_id=EXCLUDED.ilan_id, " +
                        "baslik=EXCLUDED.baslik, mesaj=EXCLUDED.mesaj, olusturma_zamani=EXCLUDED.olusturma_zamani, " +
                        "okundu=EXCLUDED.okundu",
                n.id(), n.userId(), n.ilanId(), n.baslik(), n.mesaj(), ts(n.olusturmaZamani()), n.okundu());
    }

    private void upsertSupportRequest(SupportRequest s) {
        jdbc.update(
                "INSERT INTO support_requests (id, user_id, konu, mesaj, olusturma_zamani, durum) " +
                        "VALUES (?,?,?,?,?,?) " +
                        "ON CONFLICT (id) DO UPDATE SET user_id=EXCLUDED.user_id, konu=EXCLUDED.konu, " +
                        "mesaj=EXCLUDED.mesaj, olusturma_zamani=EXCLUDED.olusturma_zamani, durum=EXCLUDED.durum",
                s.id(), s.userId(), s.konu(), s.mesaj(), ts(s.olusturmaZamani()), s.durum());
    }

    // ---------------------------------------------------------------------
    // Yardimcilar
    // ---------------------------------------------------------------------

    private static OffsetDateTime ts(Instant instant) {
        return instant == null ? null : OffsetDateTime.ofInstant(instant, ZoneOffset.UTC);
    }

    private static Instant instant(ResultSet rs, String column) throws SQLException {
        OffsetDateTime value = rs.getObject(column, OffsetDateTime.class);
        return value == null ? null : value.toInstant();
    }

    private static List<String> stringList(Array array) throws SQLException {
        if (array == null) {
            return List.of();
        }
        Object raw = array.getArray();
        if (raw instanceof String[] strings) {
            return Arrays.asList(strings);
        }
        return List.of();
    }
}
