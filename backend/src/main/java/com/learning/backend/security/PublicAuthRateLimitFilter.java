package com.learning.backend.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import org.springframework.web.filter.OncePerRequestFilter;

public class PublicAuthRateLimitFilter extends OncePerRequestFilter {

    private static final long WINDOW_MILLIS = Duration.ofMinutes(15).toMillis();
    private static final int MAX_TRACKED_CLIENTS = 10_000;
    private final Map<String, Window> windows = new HashMap<>();

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        int limit = requestLimit(request);
        if (limit > 0 && !allow(request.getRemoteAddr() + ":" + request.getRequestURI(), limit)) {
            response.setStatus(429);
            response.setContentType("application/json");
            response.getWriter().write("{\"message\":\"Too many requests. Try again later.\"}");
            return;
        }
        filterChain.doFilter(request, response);
    }

    private int requestLimit(HttpServletRequest request) {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return 0;
        }
        return switch (request.getRequestURI()) {
            case "/api/auth/login" -> 10;
            case "/api/auth/register", "/api/auth/password/forgot" -> 5;
            default -> 0;
        };
    }

    private synchronized boolean allow(String key, int limit) {
        long now = System.currentTimeMillis();
        Window window = windows.get(key);
        if (window == null || window.expiresAt <= now) {
            if (windows.size() >= MAX_TRACKED_CLIENTS) {
                windows.entrySet().removeIf(entry -> entry.getValue().expiresAt <= now);
                if (windows.size() >= MAX_TRACKED_CLIENTS) {
                    return false;
                }
            }
            windows.put(key, new Window(now + WINDOW_MILLIS, 1));
            return true;
        }
        if (window.attempts >= limit) {
            return false;
        }
        window.attempts++;
        return true;
    }

    private static final class Window {
        private final long expiresAt;
        private int attempts;

        private Window(long expiresAt, int attempts) {
            this.expiresAt = expiresAt;
            this.attempts = attempts;
        }
    }
}
