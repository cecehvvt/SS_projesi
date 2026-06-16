package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.model.Listing;
import com.dayanisma.backend.service.FavoriteService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/favoriler")
public class FavoriteController {
    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok("Favoriler listelendi", favoriteService.listMine());
    }

    @PostMapping("/{ilanId}")
    public ApiResponse<Listing> add(@PathVariable String ilanId) {
        return ApiResponse.ok("Favori eklendi", favoriteService.add(ilanId));
    }

    @DeleteMapping("/{ilanId}")
    public ApiResponse<Void> remove(@PathVariable String ilanId) {
        favoriteService.remove(ilanId);
        return ApiResponse.ok("Favori kaldirildi", null);
    }
}
