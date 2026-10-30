package com.learning.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank @Size(max = 100) String name,
        @NotBlank @Email @Size(max = 100) String email,
        @NotBlank @Size(min = 8, max = 72) String password,
        @Pattern(regexp = "STUDENT|INSTRUCTOR", message = "Account type must be STUDENT or INSTRUCTOR")
        String role) {

    public RegisterRequest(String name, String email, String password) {
        this(name, email, password, "STUDENT");
    }

    public RegisterRequest {
        if (role == null) {
            role = "STUDENT";
        }
    }
}
