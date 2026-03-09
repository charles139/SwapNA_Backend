package com.swapna.ranking;

import com.swapna.ranking.dto.AddRankingRequest;
import com.swapna.ranking.dto.ReorderRankingsRequest;
import com.swapna.ranking.dto.UserRankingResponse;
import com.swapna.user.User;
import com.swapna.user.UserRepository;
import jakarta.transaction.Transactional;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserRankingService {

    private final UserRankingRepository userRankingRepository;
    private final UserRepository userRepository;

    public List<UserRankingResponse> getRankings(String email) {
        Long userId = getUserIdByEmail(email);
        return userRankingRepository.findByUserIdOrderByPositionAsc(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public UserRankingResponse addRanking(String email, AddRankingRequest request) {
        Long userId = getUserIdByEmail(email);

        if (userRankingRepository.existsByUserIdAndAttractionId(userId, request.attractionId())) {
            throw new IllegalArgumentException("Attraction already ranked by this user");
        }

        List<UserRanking> rankings = userRankingRepository.findByUserIdOrderByPositionAsc(userId);
        int newPosition = request.position() == null ? rankings.size() + 1 : request.position();
        if (newPosition < 1 || newPosition > rankings.size() + 1) {
            throw new IllegalArgumentException("Position is out of range");
        }

        for (UserRanking ranking : rankings) {
            if (ranking.getPosition() >= newPosition) {
                ranking.setPosition(ranking.getPosition() + 1);
            }
        }
        userRankingRepository.saveAll(rankings);

        UserRanking ranking = new UserRanking();
        ranking.setUserId(userId);
        ranking.setAttractionId(request.attractionId());
        ranking.setPosition(newPosition);

        return toResponse(userRankingRepository.save(ranking));
    }

    @Transactional
    public List<UserRankingResponse> reorderRankings(String email, ReorderRankingsRequest request) {
        Long userId = getUserIdByEmail(email);
        List<UserRanking> rankings = userRankingRepository.findByUserIdOrderByPositionAsc(userId);

        if (rankings.isEmpty()) {
            throw new IllegalArgumentException("No rankings found for this user");
        }

        List<Long> newOrder = request.orderedAttractionIds();
        if (newOrder.size() != rankings.size()) {
            throw new IllegalArgumentException("Reorder list must include all ranked attractions");
        }

        Set<Long> deduped = new HashSet<>(newOrder);
        if (deduped.size() != newOrder.size()) {
            throw new IllegalArgumentException("Reorder list contains duplicate attraction IDs");
        }

        Set<Long> existingAttractionIds = rankings.stream()
                .map(UserRanking::getAttractionId)
                .collect(java.util.stream.Collectors.toSet());

        if (!existingAttractionIds.equals(deduped)) {
            throw new IllegalArgumentException("Reorder list must match existing ranked attractions");
        }

        for (int i = 0; i < newOrder.size(); i++) {
            Long attractionId = newOrder.get(i);
            UserRanking ranking = rankings.stream()
                    .filter(r -> r.getAttractionId().equals(attractionId))
                    .findFirst()
                    .orElseThrow();
            ranking.setPosition(i + 1);
        }

        userRankingRepository.saveAll(rankings);

        return userRankingRepository.findByUserIdOrderByPositionAsc(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private UserRankingResponse toResponse(UserRanking ranking) {
        return new UserRankingResponse(
                ranking.getId(),
                ranking.getUserId(),
                ranking.getAttractionId(),
                ranking.getPosition()
        );
    }

    private Long getUserIdByEmail(String email) {
        User user = userRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        return user.getId();
    }
}
