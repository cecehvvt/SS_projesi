package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.service.ListingRequestService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/taleplerim")
public class ListingRequestController {
    private final ListingRequestService listingRequestService;

    public ListingRequestController(ListingRequestService listingRequestService) {
        this.listingRequestService = listingRequestService;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> mine() {
        return ApiResponse.ok("Talepler listelendi", listingRequestService.mine());
    }
}
