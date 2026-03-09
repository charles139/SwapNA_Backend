package com.swapna.attraction;

import java.util.List;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AttractionRepository extends JpaRepository<Attraction, Long> {

    @Query("""
            SELECT a.id
            FROM Attraction a
            LEFT JOIN com.swapna.ranking.UserRanking r ON r.attractionId = a.id
            WHERE LOWER(a.country) = LOWER(:country)
            GROUP BY a.id
            ORDER BY COALESCE(AVG(r.position), 1000000) ASC, COUNT(r.id) DESC, a.id ASC
            """)
    List<Long> findTopAttractionIdsByCountry(@Param("country") String country, Pageable pageable);
}
