package com.swapna.auth.dto;

public record AuthResponse(Long id, String email, String message, String token) {
}
