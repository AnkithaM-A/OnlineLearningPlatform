package com.learning.backend.service;

import com.learning.backend.dto.QuizAttemptHistoryResponse;
import com.learning.backend.dto.QuizAttemptRequest;
import com.learning.backend.dto.QuizAttemptResponse;
import com.learning.backend.dto.QuizOptionResponse;
import com.learning.backend.dto.QuizQuestionResponse;
import com.learning.backend.dto.QuizResponse;
import com.learning.backend.model.Course;
import com.learning.backend.model.LearningProgress;
import com.learning.backend.model.Quiz;
import com.learning.backend.model.QuizAttempt;
import com.learning.backend.model.QuizOption;
import com.learning.backend.model.QuizQuestion;
import com.learning.backend.model.UserAccount;
import com.learning.backend.repository.CourseRepository;
import com.learning.backend.repository.EnrollmentRepository;
import com.learning.backend.repository.LearningProgressRepository;
import com.learning.backend.repository.QuizAttemptRepository;
import com.learning.backend.repository.QuizOptionRepository;
import com.learning.backend.repository.QuizQuestionRepository;
import com.learning.backend.repository.QuizRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class QuizService {

    private final QuizRepository quizRepository;
    private final QuizQuestionRepository questionRepository;
    private final QuizOptionRepository optionRepository;
    private final QuizAttemptRepository attemptRepository;
    private final EnrollmentRepository enrollmentRepository;
    private final LearningProgressRepository progressRepository;
    private final CourseRepository courseRepository;

    public QuizService(
            QuizRepository quizRepository,
            QuizQuestionRepository questionRepository,
            QuizOptionRepository optionRepository,
            QuizAttemptRepository attemptRepository,
            EnrollmentRepository enrollmentRepository,
            LearningProgressRepository progressRepository,
            CourseRepository courseRepository) {
        this.quizRepository = quizRepository;
        this.questionRepository = questionRepository;
        this.optionRepository = optionRepository;
        this.attemptRepository = attemptRepository;
        this.enrollmentRepository = enrollmentRepository;
        this.progressRepository = progressRepository;
        this.courseRepository = courseRepository;
    }

    @Transactional(readOnly = true)
    public List<QuizResponse> findForCourse(UserAccount user, Integer courseId) {
        requireEnrollment(user, courseId);
        return toResponses(quizRepository.findAllByCourseIdOrderByQuizId(courseId));
    }

    @Transactional
    public QuizAttemptResponse submit(UserAccount user, Integer quizId, QuizAttemptRequest request) {
        Quiz quiz = quizRepository.findById(quizId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz not found."));
        requireEnrollment(user, quiz.getCourseId());

        List<QuizQuestion> questions = questionRepository.findAllByQuizIdOrderByQuestionOrder(quizId);
        Map<Integer, Integer> answers = request == null ? null : request.answers();
        if (questions.isEmpty() || answers == null || answers.size() != questions.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Answer every question before submitting.");
        }

        int score = 0;
        for (QuizQuestion question : questions) {
            Integer selectedOptionId = answers.get(question.getQuestionId());
            if (selectedOptionId == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Answer every question before submitting.");
            }
            QuizOption selectedOption = optionRepository.findById(selectedOptionId)
                    .orElseThrow(() -> new ResponseStatusException(
                            HttpStatus.BAD_REQUEST, "An answer does not belong to its question."));
            if (!selectedOption.getQuestionId().equals(question.getQuestionId())) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST, "An answer does not belong to its question.");
            }
            if (selectedOption.isCorrect()) {
                score++;
            }
        }

        int percent = score * 100 / questions.size();
        attemptRepository.save(new QuizAttempt(user.getUserId(), quizId, score, questions.size()));

        Course course = courseRepository.findById(quiz.getCourseId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Course not found."));
        LearningProgress progress = progressRepository
                .findFirstByUserUserIdAndCourseCourseId(user.getUserId(), course.getCourseId())
                .orElseGet(() -> new LearningProgress(user, course));
        progress.setProgressPercent(Math.max(progress.getProgressPercent(), percent));
        progressRepository.save(progress);

        return new QuizAttemptResponse(score, questions.size(), progress.getProgressPercent());
    }

    @Transactional(readOnly = true)
    public List<QuizAttemptHistoryResponse> history(UserAccount user) {
        return attemptRepository.findHistoryByUserId(user.getUserId());
    }

    private void requireEnrollment(UserAccount user, Integer courseId) {
        if (!enrollmentRepository.existsByUserUserIdAndCourseCourseId(user.getUserId(), courseId)) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Enroll in this course to access its quizzes.");
        }
    }

    private List<QuizResponse> toResponses(List<Quiz> quizzes) {
        if (quizzes.isEmpty()) {
            return List.of();
        }
        List<Integer> quizIds = quizzes.stream().map(Quiz::getQuizId).toList();
        List<QuizQuestion> allQuestions =
                questionRepository.findAllByQuizIdInOrderByQuizIdAscQuestionOrderAsc(quizIds);
        Map<Integer, List<QuizQuestion>> questionsByQuiz = allQuestions.stream()
                .collect(Collectors.groupingBy(QuizQuestion::getQuizId));
        List<Integer> questionIds = allQuestions.stream().map(QuizQuestion::getQuestionId).toList();
        Map<Integer, List<QuizOption>> optionsByQuestion = questionIds.isEmpty()
                ? Map.of()
                : optionRepository.findAllByQuestionIdInOrderByQuestionIdAscOptionOrderAsc(questionIds)
                        .stream()
                        .collect(Collectors.groupingBy(QuizOption::getQuestionId));
        return quizzes.stream()
                .map(quiz -> new QuizResponse(
                        quiz.getQuizId(),
                        quiz.getTitle(),
                        questionsByQuiz.getOrDefault(quiz.getQuizId(), List.of()).stream()
                                .map(question -> new QuizQuestionResponse(
                                        question.getQuestionId(),
                                        question.getQuestionText(),
                                        optionsByQuestion.getOrDefault(
                                                        question.getQuestionId(), List.of())
                                                .stream()
                                                .map(option -> new QuizOptionResponse(
                                                        option.getOptionId(), option.getOptionText()))
                                                .toList()))
                                .toList()))
                .toList();
    }
}
