USE online_learning;

SELECT progress_id, user_id, course_id, progress_percent
FROM learning_progress
WHERE user_id IS NULL OR course_id IS NULL;

UPDATE learning_progress progress
JOIN (
    SELECT user_id, course_id, COALESCE(MAX(progress_percent), 0) AS max_progress, MAX(progress_id) AS keep_id
    FROM learning_progress
    WHERE user_id IS NOT NULL AND course_id IS NOT NULL
    GROUP BY user_id, course_id
) consolidated ON consolidated.keep_id = progress.progress_id
SET progress.progress_percent = consolidated.max_progress;

DELETE older
FROM learning_progress older
JOIN learning_progress newer
  ON older.user_id = newer.user_id
 AND older.course_id = newer.course_id
 AND older.progress_id < newer.progress_id;

ALTER TABLE learning_progress
    MODIFY user_id INT NOT NULL,
    MODIFY course_id INT NOT NULL,
    MODIFY progress_percent INT NOT NULL DEFAULT 0,
    ADD CONSTRAINT uq_learning_progress_user_course UNIQUE (user_id, course_id);
