package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.service.AuthService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Giris basarili", authService.login(request));
    }

    @PostMapping("/register")
    public ApiResponse<Map<String, Object>> register(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Kayit basarili", authService.register(request));
    }

    @PostMapping("/forgot-password")
    public ApiResponse<Map<String, Object>> forgotPassword() {
        return ApiResponse.ok("Sifre sifirlama istegi alindi", authService.simpleMessage("mock"));
    }

    @PostMapping("/change-password")
    public ApiResponse<Map<String, Object>> changePassword() {
        return ApiResponse.ok("Sifre degistirme istegi alindi", authService.simpleMessage("mock"));
    }

    @PostMapping("/logout")
    public ApiResponse<Map<String, Object>> logout() {
        return ApiResponse.ok("Cikis basarili", authService.simpleMessage("mock"));
    }

    @PostMapping("/refresh-token")
    public ApiResponse<Map<String, Object>> refreshToken() {
        return ApiResponse.ok("Token yenilendi", authService.simpleMessage("mock"));
    }
}
