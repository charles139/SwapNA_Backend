package com.swapna;

import com.swapna.attraction.AttractionRepository;
import com.swapna.ranking.UserRankingRepository;
import com.swapna.user.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

@SpringBootTest(properties = {
        "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration," +
                "org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration"
})
class SwapNaApplicationTests {

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private UserRankingRepository userRankingRepository;

    @MockBean
    private AttractionRepository attractionRepository;

    @Test
    void contextLoads() {
    }
}
