package com.learning.backend.repository;

import com.learning.backend.model.CourseInstructor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CourseInstructorRepository extends JpaRepository<CourseInstructor, Integer> {
    List<CourseInstructor> findAllByInstructorId(Integer instructorId);

    List<CourseInstructor> findAllByCourseIdIn(List<Integer> courseIds);

    Optional<CourseInstructor> findByCourseIdAndInstructorId(Integer courseId, Integer instructorId);
}
