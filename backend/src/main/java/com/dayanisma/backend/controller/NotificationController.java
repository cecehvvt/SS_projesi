package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.model.Notification;
import com.dayanisma.backend.service.NotificationService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/bildirimler")
public class NotificationController {
    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping
    public ApiResponse<List<Notification>> listMine() {
        return ApiResponse.ok("Bildirimler listelendi", notificationService.listMine());
    }
}
