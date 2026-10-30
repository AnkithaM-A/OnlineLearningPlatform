package com.learning.backend.repository;

import com.learning.backend.model.QuizAttempt;
import com.learning.backend.dto.QuizAttemptHistoryResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Integer> {
    List<QuizAttempt> findAllByUserIdOrderByAttemptedAtDesc(Integer userId);

    @Query("""
            select new com.learning.backend.dto.QuizAttemptHistoryResponse(
                attempt.attemptId, course.title, quiz.title, attempt.score,
                attempt.totalQuestions, attempt.attemptedAt)
            from QuizAttempt attempt, Quiz quiz, Course course
            where attempt.userId = :userId
              and quiz.quizId = attempt.quizId
              and course.courseId = quiz.courseId
            order by attempt.attemptedAt desc
            """)
    List<QuizAttemptHistoryResponse> findHistoryByUserId(@Param("userId") Integer userId);
}
