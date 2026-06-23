package com.dayanisma.backend.controller;

import com.dayanisma.backend.dto.ApiResponse;
import com.dayanisma.backend.model.UserProfile;
import com.dayanisma.backend.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    public ApiResponse<UserProfile> me() {
        return ApiResponse.ok("Kullanici bilgisi", userService.me());
    }

    @DeleteMapping("/me")
    public ApiResponse<Map<String, Integer>> deleteMe() {
        return ApiResponse.ok("Hesap ve kullanıcıya ait ilanlar silindi", userService.deleteMe());
    }

    @PutMapping("/me")
    public ApiResponse<UserProfile> updateMe(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Profil guncellendi", userService.updateMe(request));
    }

    @PostMapping("/me/avatar")
    public ApiResponse<UserProfile> updateAvatar(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Profil fotografi guncellendi", userService.updateMe(request));
    }

    @PutMapping("/me/privacy")
    public ApiResponse<UserProfile> updatePrivacy(@RequestBody Map<String, Object> request) {
        return ApiResponse.ok("Gizlilik ayarlari guncellendi", userService.updatePrivacy(request));
    }

    @GetMapping("/{id}")
    public ApiResponse<UserProfile> get(@PathVariable String id) {
        return ApiResponse.ok("Kullanici profili", userService.get(id));
    }
}
