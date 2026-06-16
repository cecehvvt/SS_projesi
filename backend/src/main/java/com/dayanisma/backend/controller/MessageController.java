package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.model.Message;
import com.dayanisma.backend.service.MessageService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/mesajlar")
public class MessageController {
    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @GetMapping("/sohbetler")
    public ApiResponse<List<Map<String, Object>>> conversations() {
        return ApiResponse.ok("Sohbetler listelendi", messageService.conversations());
    }

    @GetMapping("/{karsiKullaniciId}")
    public ApiResponse<List<Message>> messagesWith(
            @PathVariable String karsiKullaniciId,
            @RequestParam(required = false) String ilanId
    ) {
        return ApiResponse.ok("Mesajlar listelendi", messageService.messagesWith(karsiKullaniciId, ilanId));
    }

    @PostMapping
    public ApiResponse<Message> send(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Mesaj gonderildi", messageService.send(request));
    }

    @PatchMapping("/{id}/okundu")
    public ApiResponse<Message> markRead(@PathVariable String id) {
        return ApiResponse.ok("Mesaj okundu", messageService.markRead(id));
    }
}
