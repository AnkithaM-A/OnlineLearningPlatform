package com.learning.backend.repository;

import com.learning.backend.model.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Collection;

public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Integer> {
    List<QuizQuestion> findAllByQuizIdOrderByQuestionOrder(Integer quizId);

    List<QuizQuestion> findAllByQuizIdInOrderByQuizIdAscQuestionOrderAsc(Collection<Integer> quizIds);
}
