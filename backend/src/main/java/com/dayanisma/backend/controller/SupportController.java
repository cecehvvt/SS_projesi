package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.facade.VestaFacade;
import com.dayanisma.backend.model.SupportRequest;
import com.dayanisma.backend.service.SupportService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/destek")
public class SupportController {
    private final VestaFacade facade;
    private final SupportService supportService;

    public SupportController(VestaFacade facade, SupportService supportService) {
        this.facade = facade;
        this.supportService = supportService;
    }

    @GetMapping
    public ApiResponse<List<SupportRequest>> list() {
        return ApiResponse.ok("Destek kayitlari", supportService.list());
    }

    @PostMapping
    public ApiResponse<SupportRequest> create(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Destek talebi alindi", facade.createSupportRequest(request));
    }

    @GetMapping("/{id}/cevaplar")
    public ApiResponse<List<Map<String, Object>>> replies(@PathVariable String id) {
        return ApiResponse.ok("Destek cevaplari", supportService.replies(id));
    }

    @PostMapping("/{id}/cevaplar")
    public ApiResponse<Map<String, Object>> addReply(@PathVariable String id, @RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Destek cevabi eklendi", supportService.addReply(id, request));
    }
}
