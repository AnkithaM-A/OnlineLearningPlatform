package com.learning.backend.security;

import jakarta.servlet.ServletException;
import java.io.IOException;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockFilterChain;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PublicAuthRateLimitFilterTest {

    @Test
    void limitsRepeatedLoginRequestsFromOneClient() throws ServletException, IOException {
        PublicAuthRateLimitFilter filter = new PublicAuthRateLimitFilter();

        for (int attempt = 0; attempt < 10; attempt++) {
            MockHttpServletResponse response = request(filter);
            assertEquals(200, response.getStatus());
        }

        assertEquals(429, request(filter).getStatus());
    }

    private MockHttpServletResponse request(PublicAuthRateLimitFilter filter)
            throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/auth/login");
        request.setRemoteAddr("192.0.2.10");
        MockHttpServletResponse response = new MockHttpServletResponse();
        filter.doFilter(request, response, new MockFilterChain());
        return response;
    }
}
