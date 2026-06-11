# Demo assets

Real screenshots of the running app (student role), rendered in the project
[`README.md`](../../README.md#demo). All were produced by
[`capture.py`](capture.py) driving a logged-in student through each flow with
Playwright.

| File | Flow |
|---|---|
| `shots/01-login.png` | Branded role-based login |
| `shots/02-home.png` | Student dashboard (profile, messages, course, QueryLLM) |
| `shots/04-learning-path.png` | Gated learning path — sequential chapter unlocking, auto-scored exercises |
| `shots/05-ai-practice.png` | AI SQL practice — topic keyword input |
| `shots/06-inbox.png` | Student ⇄ instructor messaging thread |
| `shots/07-ai-generated.png` | GPT-4 generation confirmation |
| `shots/08-ai-tasks.png` | GPT-4-generated SQL practice tasks (auto-graded) |
| `shots/09-ai-record.png` | AI practice analytics — Chart.js + GPT-4 recommendations |
| `shots/i01-home.png` | Instructor home (profile, messages, AI assistant shortcuts) |
| `shots/i02-dashboard.png` | Chapter / exercise / evaluation authoring dashboard |
| `shots/i03-ai-mcq.png` | GPT-4-generated multiple-choice SQL question |
| `shots/i04-course-performance.png` | Cohort analytics — Chart.js KPIs + per-student table |
| `shots/i05-ai-assist.png` | AI teaching assistant — topic ranks, top students, GPT-4 Q&A |

The instructor flows are produced by [`capture_instructor.py`](capture_instructor.py)
(same login/normalize approach, logged in as the instructor who authored the
demo chapters).

## Regenerating the screenshots

```bash
# 1. Start the app (DB reachable — local MySQL or Cloud SQL Auth Proxy)
cd query_minds_project_web_app
python manage.py runserver           # serves http://127.0.0.1:8000

# 2. Install Playwright once
venv/bin/pip install playwright && venv/bin/playwright install chromium

# 3. Capture (logs in as the student in capture.py: USER / PASSWORD)
venv/bin/python ../docs/demo/capture.py
```

Notes
- Steps 5–6 / shots 07–09 make **live GPT-4 calls** and need `OPENAI_API_KEY`.
- The analytics report (`09-ai-record.png`) needs a few `EXERCISE_LLM` +
  `STUDENT_EVALUATION_LLM` rows for the student, or it renders the empty-state.
- Captured at 1440-wide, retina (`device_scale_factor=2`). The fixed sidebar is
  stretched to full document height for long pages — see `normalize()`.