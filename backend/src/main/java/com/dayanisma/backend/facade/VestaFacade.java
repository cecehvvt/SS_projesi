package com.dayanisma.backend.facade;

import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.service.FavoriteService;
import com.dayanisma.backend.service.ListingRequestService;
import com.dayanisma.backend.service.ListingService;
import com.dayanisma.backend.service.SupportService;
import com.dayanisma.backend.store.DataStore;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class VestaFacade {
    private final DataStore store;
    private final ListingService listingService;
    private final ListingRequestService listingRequestService;
    private final FavoriteService favoriteService;
    private final SupportService supportService;

    public VestaFacade(
            DataStore store,
            ListingService listingService,
            ListingRequestService listingRequestService,
            FavoriteService favoriteService,
            SupportService supportService
    ) {
        this.store = store;
        this.listingService = listingService;
        this.listingRequestService = listingRequestService;
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

    public Map<String, Object> requestListing(String id) {
        Listing listing = listingService.get(id);
        Map<String, Object> request = listingRequestService.request(id);
        favoriteService.notifyFollowers(
                id,
                store.currentUserId(),
                "Favori ilanda yeni talep",
                listing.title() + " icin yeni bir talep olustu."
        );
        return request;
    }

    public Map<String, Object> cancelListingRequest(String id) {
        return listingRequestService.cancel(id);
    }

    public SupportRequest createSupportRequest(Map<String, Object> request) {
        return supportService.create(request);
    }
}
