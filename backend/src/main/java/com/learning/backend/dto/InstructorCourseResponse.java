package com.learning.backend.dto;

public record InstructorCourseResponse(
        Integer courseId,
        String title,
        String description,
        String instructor,
        Integer categoryId,
        long enrollmentCount,
        String videoUrl) {
}
