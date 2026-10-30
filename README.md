# LearnEsc

This project preserves the existing React UI/UX and extends it with YouTube course lessons, three quizzes per starter course, and deployment configuration. It uses React + Vite, Spring Boot, and MySQL.

## Features

- Existing Student, Instructor, and Admin dashboards are retained.
- Students can browse/enroll in courses, watch lessons, attempt quizzes, and track progress.
- Instructors can manage courses, attach a YouTube lesson URL, create quizzes, and view course enrollment counts.
- Admins can manage users/roles, courses, and categories through the existing admin dashboard.
- Starter courses: Java Programming, React JS, Database Management, and Spring Boot.
- Three quizzes per starter course (each seeded quiz has three multiple-choice questions).
- Enrollment, progress, quiz attempts, authentication, and management actions use the Spring Boot API and MySQL.
- YouTube lessons play inside the portal through the YouTube IFrame Player API. While playing, the frontend records watched segments and saves progress through the authenticated API. The course is marked complete only after the player ends and at least 95% of the video timeline has been watched without skipping large sections.
- Completion is stored in `learning_progress.progress_percent` as `100`; normal playback progress is capped at `99` so a progress update alone cannot mark a course complete.

## Requirements

- Node.js 20.19+ or 22.12+ (a current supported LTS release is recommended)
- Java 21
- MySQL

## Local setup

### 1. Prepare the database

Create a MySQL database named `online_learning`, then execute these files in order:

1. `database/schema.sql`
2. `database/sample_data.sql`
3. `database/quiz_schema.sql`
4. `database/migrations/V3__course_videos_and_quizzes.sql`

The backend packages matching SQL resources from `backend/src/main/resources/db`; keep those copies in sync when changing the files under `database/`.

For a database that already existed before this update, add the new video column **once** before running the V3 script:

```sql
USE online_learning;
ALTER TABLE courses ADD COLUMN video_url VARCHAR(500);
```

Do not run that `ALTER TABLE` statement again after the column exists. The V3 seed script can be rerun; it avoids duplicating seeded quizzes/questions/options.

Starter YouTube links are example learning resources. If a video is unavailable in your region or is removed by its owner, replace the URL in the instructor dashboard.

### 2. Start the backend

Open a terminal in `backend/` and set your local MySQL credentials. PowerShell example:

```powershell
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "YOUR_MYSQL_PASSWORD"
$env:FRONTEND_URL = "http://localhost:5173"
$env:CORS_ALLOWED_ORIGINS = "http://localhost:5173,http://localhost:3000"
.\mvnw.cmd spring-boot:run
```

On macOS/Linux, run `./mvnw spring-boot:run`. The API listens on `http://localhost:8080` by default. Configure SMTP variables only if password-reset email delivery is required.

### 3. Start the frontend

Open a second terminal in `frontend/`:

```powershell
Copy-Item .env.example .env.local
npm install
npm run dev
```

By default, `.env.example` points to `http://localhost:8080`. Open the URL printed by Vite (normally `http://localhost:5173`).

### 4. Build the frontend

From `frontend/` run:

```powershell
npm run build
```

The production files are generated in `frontend/dist/`.

## Vercel deployment

1. Push the project to GitHub and import it into Vercel.
2. Set **Root Directory** to `frontend`.
3. Build command: `npm run build`; output directory: `dist`.
4. Add `VITE_API_BASE_URL` in Vercel Environment Variables with the public HTTPS URL of your deployed Spring Boot backend (no trailing slash).
5. Redeploy after setting the variable.

`frontend/vercel.json` includes an SPA rewrite so dashboard routes and browser refreshes resolve to the React app.

## Backend and database deployment

Vercel hosts the React frontend; it does not automatically host this Spring Boot server or a MySQL database. Deploy the backend to a Java-capable host and MySQL to a managed database host. Configure these variables on the backend host:

- `DB_USERNAME`
- `DB_PASSWORD`
- `FRONTEND_URL` (deployed Vercel origin)
- `CORS_ALLOWED_ORIGINS` (comma-separated allowed frontend origins)
- `SECURE_COOKIES=true`
- `SESSION_COOKIE_SAME_SITE=none`
- `CSRF_COOKIE_SAME_SITE=None`

For cross-site session cookies, the backend must use HTTPS and allow credentials from the exact frontend origin. Never put database passwords or backend secrets in `VITE_*` variables or commit them to Git.

## Important notes

- Real-time multi-user behavior requires the frontend, backend, and database all to be running and correctly configured. A successful Vercel frontend build alone does not prove that the hosted API/database works.
- Use backend authentication and role checks; do not grant admin privileges from a public registration form.
- The existing UI is retained. Video lessons appear within course details and the student dashboard, and instructors can enter or update a YouTube URL in the existing course form. Videos must be public or unlisted and have embedding enabled.
- Completion API: `POST /api/enrollments/{courseId}/video-completed` with JSON `{ "watchedPercent": 95 }` or higher. The endpoint requires a signed-in student who is enrolled in that course. The server validates the reported coverage, but because YouTube playback events originate in the browser, this is practical progress tracking rather than tamper-proof proctoring.
