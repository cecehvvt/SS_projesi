package com.dayanisma.backend.service;

import com.dayanisma.backend.model.UserProfile;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class AuthService {
    private final UserService userService;

    public AuthService(UserService userService) {
        this.userService = userService;
    }

    public Map<String, Object> login(Map<String, Object> request) {
        return Map.of(
                "accessToken", "mock-access-token",
                "refreshToken", "mock-refresh-token",
                "user", userService.me()
        );
    }

    public Map<String, Object> register(Map<String, Object> request) {
        UserProfile user = userService.register(request);
        return Map.of(
                "accessToken", "mock-access-token",
                "refreshToken", "mock-refresh-token",
                "user", user
        );
    }

    public Map<String, Object> simpleMessage(String message) {
        return Map.of("message", message);
    }
}
