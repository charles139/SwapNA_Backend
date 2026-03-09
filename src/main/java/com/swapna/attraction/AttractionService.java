package com.swapna.attraction;

import com.swapna.attraction.dto.AttractionResponse;
import com.swapna.attraction.dto.CreateAttractionRequest;
import com.swapna.user.User;
import com.swapna.user.UserRepository;
import jakarta.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AttractionService {

    private final AttractionRepository attractionRepository;
    private final UserRepository userRepository;

    public List<AttractionResponse> getTop10ByCountry(String country) {
        List<Long> topIds = attractionRepository.findTopAttractionIdsByCountry(country, PageRequest.of(0, 10));
        List<AttractionResponse> responses = new ArrayList<>();

        for (Long id : topIds) {
            attractionRepository.findById(id).ifPresent(attraction -> responses.add(toResponse(attraction)));
        }

        return responses;
    }

    public AttractionResponse getAttractionById(Long id) {
        Attraction attraction = attractionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Attraction not found"));
        return toResponse(attraction);
    }

    @Transactional
    public AttractionResponse createAttraction(String email, CreateAttractionRequest request) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Attraction attraction = new Attraction();
        attraction.setName(request.name().trim());
        attraction.setDescription(request.description().trim());
        attraction.setCountry(request.country().trim());
        attraction.setImageUrl(request.imageUrl().trim());
        attraction.setCreatedByUserId(user.getId());

        return toResponse(attractionRepository.save(attraction));
    }

    private AttractionResponse toResponse(Attraction attraction) {
        return new AttractionResponse(
                attraction.getId(),
                attraction.getName(),
                attraction.getDescription(),
                attraction.getCountry(),
                attraction.getImageUrl(),
                attraction.getCreatedByUserId()
        );
    }
}
