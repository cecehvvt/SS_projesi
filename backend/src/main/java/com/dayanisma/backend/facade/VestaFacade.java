package com.dayanisma.backend.facade;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.service.FavoriteService;
import com.dayanisma.backend.service.ListingService;
import com.dayanisma.backend.service.SupportService;
import com.dayanisma.backend.store.DataStore;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class VestaFacade {
    private final DataStore store;
    private final ListingService listingService;
    private final FavoriteService favoriteService;
    private final SupportService supportService;

    public VestaFacade(
            DataStore store,
            ListingService listingService,
            FavoriteService favoriteService,
            SupportService supportService
    ) {
        this.store = store;
        this.listingService = listingService;
        this.favoriteService = favoriteService;
        this.supportService = supportService;
    }

    public Listing createListing(Map<String, Object> request) {
        return listingService.create(request);
    }

    public Listing updateListing(String id, Map<String, Object> request) {
        Listing listing = listingService.update(id, request);
        favoriteService.notifyFollowers(
                id,
                store.currentUserId(),
                "Favori ilanin guncellendi",
                listing.title() + " ilaninda yeni bir guncelleme var."
        );
        return listing;
    }

    public void deleteListing(String id) {
        Listing listing = listingService.get(id);
        listingService.delete(id);
        favoriteService.notifyFollowers(
                id,
                store.currentUserId(),
                "Favori ilanin yayindan kalkti",
                listing.title() + " artik aktif degil."
        );
    }

    public Listing requestListing(String id) {
        Listing listing = listingService.get(id);
        favoriteService.notifyFollowers(
                id,
                store.currentUserId(),
                "Favori ilanda yeni talep",
                listing.title() + " icin yeni bir talep olustu."
        );
        return listing;
    }

    public SupportRequest createSupportRequest(Map<String, Object> request) {
        return supportService.create(request);
    }
}
