package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.service.SwapRequestService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/takas-istekleri")
public class SwapRequestController {
    private final SwapRequestService service;

    public SwapRequestController(SwapRequestService service) {
        this.service = service;
    }

    @PostMapping("/ilan/{listingId}")
    public ApiResponse<Map<String, Object>> create(@PathVariable String listingId) {
        return ApiResponse.ok("Takas istegi gonderildi", service.create(listingId));
    }

    @GetMapping("/gelen")
    public ApiResponse<List<Map<String, Object>>> incoming() {
        return ApiResponse.ok("Takas istekleri listelendi", service.incoming());
    }

    @PutMapping("/{id}")
    public ApiResponse<Map<String, Object>> respond(@PathVariable String id, @RequestBody Map<String, Object> body) {
        return ApiResponse.ok("Takas istegi guncellendi", service.respond(id, String.valueOf(body.get("status"))));
    }
}
