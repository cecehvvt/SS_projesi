package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/konum")
public class LocationController {
    @GetMapping("/ara")
    public ApiResponse<List<String>> search(@RequestParam(required = false) String q) {
        List<String> locations = List.of(
                "Uskudar, Istanbul",
                "Kadikoy, Istanbul",
                "Beyoglu, Istanbul",
                "Besiktas, Istanbul"
        );
        return ApiResponse.ok("Konumlar listelendi", locations);
    }
}
