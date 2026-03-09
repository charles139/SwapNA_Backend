package com.swapna.ranking;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRankingRepository extends JpaRepository<UserRanking, Long> {

    List<UserRanking> findByUserIdOrderByPositionAsc(Long userId);

    Optional<UserRanking> findByUserIdAndAttractionId(Long userId, Long attractionId);

    boolean existsByUserIdAndAttractionId(Long userId, Long attractionId);
}
