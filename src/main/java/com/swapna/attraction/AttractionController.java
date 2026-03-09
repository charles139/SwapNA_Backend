package com.swapna.attraction;

import com.swapna.attraction.dto.AttractionResponse;
import com.swapna.attraction.dto.CreateAttractionRequest;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/attractions")
@RequiredArgsConstructor
public class AttractionController {

    private final AttractionService attractionService;

    @GetMapping("/top10")
    public ResponseEntity<List<AttractionResponse>> getTop10ByCountry(@RequestParam String country) {
        return ResponseEntity.ok(attractionService.getTop10ByCountry(country));
    }

    @PostMapping
    public ResponseEntity<AttractionResponse> createAttraction(
            @Valid @RequestBody CreateAttractionRequest request,
            Principal principal
    ) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(attractionService.createAttraction(principal.getName(), request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AttractionResponse> getAttractionById(@PathVariable Long id) {
        return ResponseEntity.ok(attractionService.getAttractionById(id));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
}
