package com.swapna.attraction.dto;

public record AttractionResponse(
        Long id,
        String name,
        String description,
        String country,
        String imageUrl,
        Long createdByUserId
) {
}
