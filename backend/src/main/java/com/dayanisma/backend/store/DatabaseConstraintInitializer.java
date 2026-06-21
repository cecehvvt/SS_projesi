package com.dayanisma.backend.store;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.sql.init.dependency.DependsOnDatabaseInitialization;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@DependsOnDatabaseInitialization
public class DatabaseConstraintInitializer implements ApplicationRunner {
    private final JdbcTemplate jdbc;

    public DatabaseConstraintInitializer(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public void run(ApplicationArguments args) {
        constraints().forEach(this::addIfMissing);
    }

    private void addIfMissing(ConstraintDefinition constraint) {
        Integer exists = jdbc.queryForObject(
                "SELECT COUNT(*) FROM pg_constraint c " +
                        "JOIN pg_namespace n ON n.oid = c.connamespace " +
                        "WHERE c.conname = ? AND n.nspname = current_schema()",
                Integer.class,
                constraint.name()
        );
        if (exists != null && exists > 0) {
            return;
        }
        jdbc.execute(constraint.sql());
    }

    private List<ConstraintDefinition> constraints() {
        return List.of(
                new ConstraintDefinition(
                        "fk_listings_owner",
                        "ALTER TABLE listings ADD CONSTRAINT fk_listings_owner " +
                                "FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_favorites_listing",
                        "ALTER TABLE favorites ADD CONSTRAINT fk_favorites_listing " +
                                "FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_favorites_user",
                        "ALTER TABLE favorites ADD CONSTRAINT fk_favorites_user " +
                                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_listing_requests_listing",
                        "ALTER TABLE listing_requests ADD CONSTRAINT fk_listing_requests_listing " +
                                "FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_listing_requests_requester",
                        "ALTER TABLE listing_requests ADD CONSTRAINT fk_listing_requests_requester " +
                                "FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_messages_sender",
                        "ALTER TABLE messages ADD CONSTRAINT fk_messages_sender " +
                                "FOREIGN KEY (gonderic_id) REFERENCES users(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_messages_receiver",
                        "ALTER TABLE messages ADD CONSTRAINT fk_messages_receiver " +
                                "FOREIGN KEY (alici_id) REFERENCES users(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_messages_listing",
                        "ALTER TABLE messages ADD CONSTRAINT fk_messages_listing " +
                                "FOREIGN KEY (ilan_id) REFERENCES listings(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_notifications_user",
                        "ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user " +
                                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_notifications_listing",
                        "ALTER TABLE notifications ADD CONSTRAINT fk_notifications_listing " +
                                "FOREIGN KEY (ilan_id) REFERENCES listings(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_support_requests_user",
                        "ALTER TABLE support_requests ADD CONSTRAINT fk_support_requests_user " +
                                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_auth_tokens_user",
                        "ALTER TABLE auth_tokens ADD CONSTRAINT fk_auth_tokens_user " +
                                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_password_reset_tokens_user",
                        "ALTER TABLE password_reset_tokens ADD CONSTRAINT fk_password_reset_tokens_user " +
                                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_listing_photos_listing",
                        "ALTER TABLE listing_photos ADD CONSTRAINT fk_listing_photos_listing " +
                                "FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_support_replies_request",
                        "ALTER TABLE support_replies ADD CONSTRAINT fk_support_replies_request " +
                                "FOREIGN KEY (support_request_id) REFERENCES support_requests(id) ON DELETE CASCADE NOT VALID"
                ),
                new ConstraintDefinition(
                        "fk_support_replies_sender",
                        "ALTER TABLE support_replies ADD CONSTRAINT fk_support_replies_sender " +
                                "FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL NOT VALID"
                )
        );
    }

    private record ConstraintDefinition(String name, String sql) {
    }
}
