package com.swapna.attraction.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateAttractionRequest(
        @NotBlank String name,
        @NotBlank String description,
        @NotBlank String country,
        @NotBlank String imageUrl
) {
}
