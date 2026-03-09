package com.swapna.ranking;

import com.swapna.ranking.dto.AddRankingRequest;
import com.swapna.ranking.dto.ReorderRankingsRequest;
import com.swapna.ranking.dto.UserRankingResponse;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/rankings")
@RequiredArgsConstructor
public class UserRankingController {

    private final UserRankingService userRankingService;

    @GetMapping
    public ResponseEntity<List<UserRankingResponse>> getRankings(Principal principal) {
        return ResponseEntity.ok(userRankingService.getRankings(principal.getName()));
    }

    @PostMapping("/add")
    public ResponseEntity<UserRankingResponse> addRanking(
            @Valid @RequestBody AddRankingRequest request,
            Principal principal
    ) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(userRankingService.addRanking(principal.getName(), request));
    }

    @PutMapping("/reorder")
    public ResponseEntity<List<UserRankingResponse>> reorderRankings(
            @Valid @RequestBody ReorderRankingsRequest request,
            Principal principal
    ) {
        return ResponseEntity.ok(userRankingService.reorderRankings(principal.getName(), request));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
}
