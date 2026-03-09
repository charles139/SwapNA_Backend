package com.swapna.ranking.dto;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public record ReorderRankingsRequest(
        @NotEmpty List<Long> orderedAttractionIds
) {
}
