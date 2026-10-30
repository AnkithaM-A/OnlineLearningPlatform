package com.learning.backend.security;

import com.learning.backend.model.UserAccount;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.stereotype.Component;

@Component
public class AccountSessionInvalidator {

    private final SessionRegistry sessionRegistry;

    public AccountSessionInvalidator(SessionRegistry sessionRegistry) {
        this.sessionRegistry = sessionRegistry;
    }

    public void invalidateSessions(Integer userId) {
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            if (principal instanceof UserAccount user && user.getUserId().equals(userId)) {
                for (SessionInformation session : sessionRegistry.getAllSessions(user, false)) {
                    session.expireNow();
                }
            }
        }
    }
}
