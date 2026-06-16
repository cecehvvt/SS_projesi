package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.facade.VestaFacade;
import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.service.ListingService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ilanlar")
public class ListingController {
    private final ListingService listingService;
    private final VestaFacade facade;

    public ListingController(ListingService listingService, VestaFacade facade) {
        this.listingService = listingService;
        this.facade = facade;
    }

    @GetMapping
    public ApiResponse<List<Listing>> list(
            @RequestParam(required = false) String tur,
            @RequestParam(required = false) String kategori,
            @RequestParam(required = false) String q
    ) {
        return ApiResponse.ok("Ilanlar listelendi", listingService.list(tur, kategori, q));
    }

    @GetMapping("/ara")
    public ApiResponse<List<Listing>> search(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String tur,
            @RequestParam(required = false) String kategori
    ) {
        return ApiResponse.ok("Arama tamamlandi", listingService.list(tur, kategori, q));
    }

    @GetMapping("/benim")
    public ApiResponse<List<Listing>> mine() {
        return ApiResponse.ok("Kullanici ilanlari", listingService.mine());
    }

    @GetMapping("/{id}")
    public ApiResponse<Listing> get(@PathVariable String id) {
        return ApiResponse.ok("Ilan detayi", listingService.get(id));
    }

    @PostMapping
    public ApiResponse<Listing> create(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Ilan olusturuldu", facade.createListing(request));
    }

    @PutMapping("/{id}")
    public ApiResponse<Listing> update(@PathVariable String id, @RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Ilan guncellendi", facade.updateListing(id, request));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable String id) {
        facade.deleteListing(id);
        return ApiResponse.ok("Ilan silindi", null);
    }

    @PostMapping("/{id}/talep")
    public ApiResponse<Listing> requestListing(@PathVariable String id) {
        return ApiResponse.ok("Talep alindi", facade.requestListing(id));
    }

    @DeleteMapping("/{id}/talep")
    public ApiResponse<Void> cancelRequest(@PathVariable String id) {
        return ApiResponse.ok("Talep iptal edildi", null);
    }

    @PostMapping("/{id}/fotograflar")
    public ApiResponse<Map<String, Object>> uploadPhoto(@PathVariable String id, @RequestBody(required = false) Map<String, Object> request) {
        return ApiResponse.ok("Fotograf yukleme placeholder", Map.of("ilanId", id));
    }
}
