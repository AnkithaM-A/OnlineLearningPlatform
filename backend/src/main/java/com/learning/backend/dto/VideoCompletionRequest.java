package com.learning.backend.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record VideoCompletionRequest(
        @NotNull @Min(95) @Max(100) Integer watchedPercent) {
}
