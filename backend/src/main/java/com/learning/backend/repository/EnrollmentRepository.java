package com.learning.backend.repository;

import com.learning.backend.model.Enrollment;
import com.learning.backend.dto.CourseEnrollmentCount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EnrollmentRepository extends JpaRepository<Enrollment, Integer> {
    boolean existsByUserUserIdAndCourseCourseId(Integer userId, Integer courseId);

    List<Enrollment> findByUserUserIdOrderByEnrolledAtDesc(Integer userId);

    long countByCourseCourseId(Integer courseId);

    @Query("""
            select enrollment.course.courseId as courseId, count(enrollment) as enrollmentCount
            from Enrollment enrollment
            where enrollment.course.courseId in :courseIds
            group by enrollment.course.courseId
            """)
    List<CourseEnrollmentCount> countByCourseIds(@Param("courseIds") List<Integer> courseIds);
}
