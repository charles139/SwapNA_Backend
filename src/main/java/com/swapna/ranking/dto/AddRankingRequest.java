package com.swapna.ranking.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record AddRankingRequest(
        @NotNull Long attractionId,
        @Min(1) Integer position
) {
}
