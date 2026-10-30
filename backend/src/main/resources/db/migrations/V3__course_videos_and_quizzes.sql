-- Ensures every starter course has a YouTube lesson and three quizzes.
-- For an existing database, add video_url once before starting the app:
-- ALTER TABLE courses ADD COLUMN video_url VARCHAR(500);

UPDATE courses SET video_url = 'https://www.youtube.com/watch?v=xk4_1vDrzzo' WHERE title = 'Java Programming' AND (video_url IS NULL OR video_url = '');

UPDATE courses SET video_url = 'https://www.youtube.com/watch?v=bMknfKXIFFw' WHERE title = 'React JS' AND (video_url IS NULL OR video_url = '');

UPDATE courses SET video_url = 'https://www.youtube.com/watch?v=HXV3zeQKqGY' WHERE title = 'Database Management' AND (video_url IS NULL OR video_url = '');

UPDATE courses SET video_url = 'https://www.youtube.com/watch?v=9SGDpanrc8U' WHERE title = 'Spring Boot' AND (video_url IS NULL OR video_url = '');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'Java Arrays & Strings' FROM courses WHERE title = 'Java Programming' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'Java Arrays & Strings');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'Object-Oriented Java' FROM courses WHERE title = 'Java Programming' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'Object-Oriented Java');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'React Components & Props' FROM courses WHERE title = 'React JS' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'React Components & Props');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'React Hooks & State' FROM courses WHERE title = 'React JS' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'React Hooks & State');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'SQL Filtering & Joins' FROM courses WHERE title = 'Database Management' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'SQL Filtering & Joins');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'Database Design & Keys' FROM courses WHERE title = 'Database Management' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'Database Design & Keys');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'Spring Boot Fundamentals' FROM courses WHERE title = 'Spring Boot' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'Spring Boot Fundamentals');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'REST APIs with Spring' FROM courses WHERE title = 'Spring Boot' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'REST APIs with Spring');

INSERT INTO quizzes (course_id, title) SELECT course_id, 'Spring Data & Persistence' FROM courses WHERE title = 'Spring Boot' AND NOT EXISTS (SELECT 1 FROM quizzes q WHERE q.course_id = courses.course_id AND q.title = 'Spring Data & Persistence');

INSERT INTO quiz_questions (quiz_id, question_text, question_order)
SELECT q.quiz_id, seed.question_text, seed.question_order
FROM quizzes q JOIN courses c ON c.course_id = q.course_id
JOIN (
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which index accesses the first element of a Java array?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which property gives the number of elements in an array?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which class represents an immutable string?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which keyword creates a subclass?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which concept hides internal implementation details?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which method name is used for a constructor?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'What is a React component commonly used to build?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'How are values commonly passed from a parent component to a child?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'Which syntax is commonly used to describe React UI?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook stores local component state?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook runs an effect after rendering?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Can hooks normally be called inside a conditional block?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which clause filters rows before grouping?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which join returns matching rows from both tables?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which keyword removes duplicate rows from a SELECT result?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'What does a primary key guarantee?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'A foreign key is used to represent what?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'Which normal form helps remove partial dependency on a composite key?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation commonly marks a Spring Boot application entry class?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps HTTP GET requests in Spring MVC?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'What does dependency injection help with?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which HTTP method is commonly used to create a resource?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation binds a request body to a Java object?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which status code typically means a resource was created?' AS question_text, 3 AS question_order
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which Spring abstraction commonly provides CRUD repository methods?' AS question_text, 1 AS question_order
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps a Java class to a database entity?' AS question_text, 2 AS question_order
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'What does a database transaction help ensure?' AS question_text, 3 AS question_order
) seed ON seed.quiz_title = q.title AND seed.course_title = c.title
WHERE NOT EXISTS (SELECT 1 FROM quiz_questions existing WHERE existing.quiz_id = q.quiz_id AND existing.question_order = seed.question_order);

INSERT INTO quiz_options (question_id, option_text, option_order, is_correct)
SELECT question.question_id, seed.option_text, seed.option_order, seed.is_correct
FROM quiz_questions question JOIN quizzes quiz ON quiz.quiz_id = question.quiz_id JOIN courses c ON c.course_id = quiz.course_id
JOIN (
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which index accesses the first element of a Java array?' AS question_text, '0' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which index accesses the first element of a Java array?' AS question_text, '1' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which index accesses the first element of a Java array?' AS question_text, '-1' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which index accesses the first element of a Java array?' AS question_text, 'length' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which property gives the number of elements in an array?' AS question_text, 'size()' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which property gives the number of elements in an array?' AS question_text, 'length' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which property gives the number of elements in an array?' AS question_text, 'count' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which property gives the number of elements in an array?' AS question_text, 'capacity' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which class represents an immutable string?' AS question_text, 'StringBuilder' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which class represents an immutable string?' AS question_text, 'StringBuffer' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which class represents an immutable string?' AS question_text, 'String' AS option_text, 3 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Java Arrays & Strings' AS quiz_title, 'Java Programming' AS course_title, 'Which class represents an immutable string?' AS question_text, 'CharArray' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which keyword creates a subclass?' AS question_text, 'implements' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which keyword creates a subclass?' AS question_text, 'extends' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which keyword creates a subclass?' AS question_text, 'inherits' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which keyword creates a subclass?' AS question_text, 'superclass' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which concept hides internal implementation details?' AS question_text, 'Encapsulation' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which concept hides internal implementation details?' AS question_text, 'Iteration' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which concept hides internal implementation details?' AS question_text, 'Compilation' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which concept hides internal implementation details?' AS question_text, 'Casting' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which method name is used for a constructor?' AS question_text, 'Any chosen name' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which method name is used for a constructor?' AS question_text, 'The class name' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which method name is used for a constructor?' AS question_text, 'main' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Object-Oriented Java' AS quiz_title, 'Java Programming' AS course_title, 'Which method name is used for a constructor?' AS question_text, 'new' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'What is a React component commonly used to build?' AS question_text, 'Reusable UI' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'What is a React component commonly used to build?' AS question_text, 'Database indexes' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'What is a React component commonly used to build?' AS question_text, 'HTTP servers only' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'What is a React component commonly used to build?' AS question_text, 'SQL tables' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'How are values commonly passed from a parent component to a child?' AS question_text, 'Props' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'How are values commonly passed from a parent component to a child?' AS question_text, 'Cookies only' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'How are values commonly passed from a parent component to a child?' AS question_text, 'SQL joins' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'How are values commonly passed from a parent component to a child?' AS question_text, 'DOM queries' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'Which syntax is commonly used to describe React UI?' AS question_text, 'JSX' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'Which syntax is commonly used to describe React UI?' AS question_text, 'JDBC' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'Which syntax is commonly used to describe React UI?' AS question_text, 'JSP' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Components & Props' AS quiz_title, 'React JS' AS course_title, 'Which syntax is commonly used to describe React UI?' AS question_text, 'YAML only' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook stores local component state?' AS question_text, 'useState' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook stores local component state?' AS question_text, 'useRoute' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook stores local component state?' AS question_text, 'useStyle' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook stores local component state?' AS question_text, 'useServer' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook runs an effect after rendering?' AS question_text, 'useEffect' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook runs an effect after rendering?' AS question_text, 'useClass' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook runs an effect after rendering?' AS question_text, 'useHTML' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Which hook runs an effect after rendering?' AS question_text, 'useQueryDOM' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Can hooks normally be called inside a conditional block?' AS question_text, 'Yes, always' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Can hooks normally be called inside a conditional block?' AS question_text, 'No, follow the Rules of Hooks' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Can hooks normally be called inside a conditional block?' AS question_text, 'Only in loops' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'React Hooks & State' AS quiz_title, 'React JS' AS course_title, 'Can hooks normally be called inside a conditional block?' AS question_text, 'Only in CSS' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which clause filters rows before grouping?' AS question_text, 'WHERE' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which clause filters rows before grouping?' AS question_text, 'ORDER BY' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which clause filters rows before grouping?' AS question_text, 'HAVING only' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which clause filters rows before grouping?' AS question_text, 'LIMIT' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which join returns matching rows from both tables?' AS question_text, 'INNER JOIN' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which join returns matching rows from both tables?' AS question_text, 'CROSS JOIN only' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which join returns matching rows from both tables?' AS question_text, 'FULL TEXT' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which join returns matching rows from both tables?' AS question_text, 'UNION ALL always' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which keyword removes duplicate rows from a SELECT result?' AS question_text, 'DISTINCT' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which keyword removes duplicate rows from a SELECT result?' AS question_text, 'UNIQUE ROW' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which keyword removes duplicate rows from a SELECT result?' AS question_text, 'CLEAN' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'SQL Filtering & Joins' AS quiz_title, 'Database Management' AS course_title, 'Which keyword removes duplicate rows from a SELECT result?' AS question_text, 'SINGLE' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'What does a primary key guarantee?' AS question_text, 'Unique row identity' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'What does a primary key guarantee?' AS question_text, 'Duplicate rows' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'What does a primary key guarantee?' AS question_text, 'Encrypted values' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'What does a primary key guarantee?' AS question_text, 'Sorted rows only' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'A foreign key is used to represent what?' AS question_text, 'A relationship to another table' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'A foreign key is used to represent what?' AS question_text, 'A password' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'A foreign key is used to represent what?' AS question_text, 'A backup file' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'A foreign key is used to represent what?' AS question_text, 'A view name' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'Which normal form helps remove partial dependency on a composite key?' AS question_text, '1NF' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'Which normal form helps remove partial dependency on a composite key?' AS question_text, '2NF' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'Which normal form helps remove partial dependency on a composite key?' AS question_text, '4NF only' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Database Design & Keys' AS quiz_title, 'Database Management' AS course_title, 'Which normal form helps remove partial dependency on a composite key?' AS question_text, '0NF' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation commonly marks a Spring Boot application entry class?' AS question_text, '@SpringBootApplication' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation commonly marks a Spring Boot application entry class?' AS question_text, '@ReactApp' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation commonly marks a Spring Boot application entry class?' AS question_text, '@EnableHTML' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation commonly marks a Spring Boot application entry class?' AS question_text, '@RunSQL' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps HTTP GET requests in Spring MVC?' AS question_text, '@GetMapping' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps HTTP GET requests in Spring MVC?' AS question_text, '@GetRequestOnly' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps HTTP GET requests in Spring MVC?' AS question_text, '@Fetch' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps HTTP GET requests in Spring MVC?' AS question_text, '@ReadRoute' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'What does dependency injection help with?' AS question_text, 'Providing required dependencies to objects' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'What does dependency injection help with?' AS question_text, 'Styling HTML' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'What does dependency injection help with?' AS question_text, 'Compressing images' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Boot Fundamentals' AS quiz_title, 'Spring Boot' AS course_title, 'What does dependency injection help with?' AS question_text, 'Creating SQL syntax only' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which HTTP method is commonly used to create a resource?' AS question_text, 'POST' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which HTTP method is commonly used to create a resource?' AS question_text, 'GET' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which HTTP method is commonly used to create a resource?' AS question_text, 'TRACE' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which HTTP method is commonly used to create a resource?' AS question_text, 'HEAD' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation binds a request body to a Java object?' AS question_text, '@RequestBody' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation binds a request body to a Java object?' AS question_text, '@BodyHTML' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation binds a request body to a Java object?' AS question_text, '@PayloadOnly' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation binds a request body to a Java object?' AS question_text, '@EntityBody' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which status code typically means a resource was created?' AS question_text, '200' AS option_text, 1 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which status code typically means a resource was created?' AS question_text, '201' AS option_text, 2 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which status code typically means a resource was created?' AS question_text, '404' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'REST APIs with Spring' AS quiz_title, 'Spring Boot' AS course_title, 'Which status code typically means a resource was created?' AS question_text, '500' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which Spring abstraction commonly provides CRUD repository methods?' AS question_text, 'JpaRepository' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which Spring abstraction commonly provides CRUD repository methods?' AS question_text, 'ReactRepository' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which Spring abstraction commonly provides CRUD repository methods?' AS question_text, 'HttpRepository' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which Spring abstraction commonly provides CRUD repository methods?' AS question_text, 'CssRepository' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps a Java class to a database entity?' AS question_text, '@Entity' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps a Java class to a database entity?' AS question_text, '@TableOnlyClass' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps a Java class to a database entity?' AS question_text, '@PersistJS' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'Which annotation maps a Java class to a database entity?' AS question_text, '@SQLClass' AS option_text, 4 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'What does a database transaction help ensure?' AS question_text, 'A group of operations succeeds or fails consistently' AS option_text, 1 AS option_order, TRUE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'What does a database transaction help ensure?' AS question_text, 'A page uses CSS' AS option_text, 2 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'What does a database transaction help ensure?' AS question_text, 'A video is embedded' AS option_text, 3 AS option_order, FALSE AS is_correct
UNION ALL
SELECT 'Spring Data & Persistence' AS quiz_title, 'Spring Boot' AS course_title, 'What does a database transaction help ensure?' AS question_text, 'A route is public' AS option_text, 4 AS option_order, FALSE AS is_correct
) seed ON seed.quiz_title = quiz.title AND seed.course_title = c.title AND seed.question_text = question.question_text
WHERE NOT EXISTS (SELECT 1 FROM quiz_options existing WHERE existing.question_id = question.question_id AND existing.option_order = seed.option_order);


-- Complete the original starter quizzes with a third question each.
INSERT INTO quiz_questions (quiz_id, question_text, question_order)
SELECT q.quiz_id, seed.question_text, 3
FROM quizzes q JOIN courses c ON c.course_id = q.course_id
JOIN (
    SELECT 'Java Fundamentals Check-in' AS quiz_title, 'Java Programming' AS course_title, 'Which primitive type stores a true or false value?' AS question_text
    UNION ALL SELECT 'React Fundamentals Check-in', 'React JS', 'Which prop is used to give a child component its displayed text?' 
    UNION ALL SELECT 'Database Fundamentals Check-in', 'Database Management', 'Which SQL clause sorts query results?' 
) seed ON seed.quiz_title = q.title AND seed.course_title = c.title
WHERE NOT EXISTS (SELECT 1 FROM quiz_questions existing WHERE existing.quiz_id = q.quiz_id AND existing.question_order = 3);

INSERT INTO quiz_options (question_id, option_text, option_order, is_correct)
SELECT question.question_id, seed.option_text, seed.option_order, seed.is_correct
FROM quiz_questions question JOIN quizzes quiz ON quiz.quiz_id = question.quiz_id
JOIN courses c ON c.course_id = quiz.course_id
JOIN (
    SELECT 'Java Fundamentals Check-in' AS quiz_title, 'Java Programming' AS course_title, 'Which primitive type stores a true or false value?' AS question_text, 'boolean' AS option_text, 1 AS option_order, TRUE AS is_correct
    UNION ALL SELECT 'Java Fundamentals Check-in', 'Java Programming', 'Which primitive type stores a true or false value?', 'int', 2, FALSE
    UNION ALL SELECT 'Java Fundamentals Check-in', 'Java Programming', 'Which primitive type stores a true or false value?', 'char', 3, FALSE
    UNION ALL SELECT 'Java Fundamentals Check-in', 'Java Programming', 'Which primitive type stores a true or false value?', 'double', 4, FALSE
    UNION ALL SELECT 'React Fundamentals Check-in', 'React JS', 'Which prop is used to give a child component its displayed text?', 'A custom prop', 1, TRUE
    UNION ALL SELECT 'React Fundamentals Check-in', 'React JS', 'Which prop is used to give a child component its displayed text?', 'SQL', 2, FALSE
    UNION ALL SELECT 'React Fundamentals Check-in', 'React JS', 'Which prop is used to give a child component its displayed text?', 'A CSS selector', 3, FALSE
    UNION ALL SELECT 'React Fundamentals Check-in', 'React JS', 'Which prop is used to give a child component its displayed text?', 'A database key', 4, FALSE
    UNION ALL SELECT 'Database Fundamentals Check-in', 'Database Management', 'Which SQL clause sorts query results?', 'ORDER BY', 1, TRUE
    UNION ALL SELECT 'Database Fundamentals Check-in', 'Database Management', 'Which SQL clause sorts query results?', 'GROUP ROWS', 2, FALSE
    UNION ALL SELECT 'Database Fundamentals Check-in', 'Database Management', 'Which SQL clause sorts query results?', 'SORT TABLE', 3, FALSE
    UNION ALL SELECT 'Database Fundamentals Check-in', 'Database Management', 'Which SQL clause sorts query results?', 'FILTER BY', 4, FALSE
) seed ON seed.quiz_title = quiz.title AND seed.course_title = c.title AND seed.question_text = question.question_text
WHERE NOT EXISTS (SELECT 1 FROM quiz_options existing WHERE existing.question_id = question.question_id AND existing.option_order = seed.option_order);
