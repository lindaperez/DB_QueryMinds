"""
Capture the instructor-experience screenshots used in the project README.

Usage:
    query_minds_project_web_app/venv/bin/python docs/demo/capture_instructor.py

Logs in as the instructor who authored the demo chapters (lindaperez) and walks
each instructor flow. AI screens make live GPT-4 calls (need OPENAI_API_KEY).
Sidebar full-height normalization matches docs/demo/capture.py.
"""
import pathlib
from playwright.sync_api import sync_playwright

BASE = "http://127.0.0.1:8000"
USER = "lindaperez"
PASSWORD = "DemoPass123!"
OUT = pathlib.Path(__file__).parent / "shots"
OUT.mkdir(exist_ok=True)

NORMALIZE = """() => {
  document.querySelectorAll('.pc-menu-overlay, .pc-overlay, .menu-overlay').forEach(e => e.remove());
  const side = document.querySelector('.pc-sidebar');
  if (side) {
    side.classList.remove('mob-sidebar-active', 'mob-open', 'navbar-collapsed');
    side.style.position = 'absolute'; side.style.top = '0'; side.style.transform = 'none';
    side.style.height = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight) + 'px';
  }
}"""


def shot(page, name, full=True, settle=700):
    page.wait_for_timeout(settle)
    if full:
        page.evaluate(NORMALIZE)
        page.wait_for_timeout(200)
    page.screenshot(path=str(OUT / f"{name}.png"), full_page=full)
    print(f"  ✓ {name}.png")


def run():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        ctx = browser.new_context(viewport={"width": 1440, "height": 950}, device_scale_factor=2)
        page = ctx.new_page()

        page.goto(f"{BASE}/accounts/login/", wait_until="networkidle")
        page.fill("input[name=username]", USER)
        page.fill("input[name=password]", PASSWORD)
        page.click("button[type=submit], input[type=submit]")
        page.wait_for_load_state("networkidle")

        print("Instructor home…")
        page.goto(f"{BASE}/home", wait_until="networkidle")
        shot(page, "i01-home", full=False)

        print("Chapter dashboard (authoring)…")
        page.goto(f"{BASE}/dashboard/", wait_until="networkidle")
        shot(page, "i02-dashboard")

        # AI MCQ generation (live GPT-4) — POST into the dashboard generator
        try:
            print("AI MCQ generation (live GPT-4)…")
            page.goto(f"{BASE}/dashboard/", wait_until="networkidle")
            page.fill("input[name=phrase]", "JOIN")
            page.select_option("select[name=difficulty]", label="Moderate")
            page.select_option("select[name=answer_mode]", "multiple")
            page.click("button[name=generate_sql]")
            page.wait_for_load_state("networkidle", timeout=60000)
            page.wait_for_timeout(800)
            # focus the generator + generated-question section
            page.evaluate("() => { const a = document.querySelector('#SQL-question-generator'); if (a) a.scrollIntoView(); }")
            page.wait_for_timeout(400)
            shot(page, "i03-ai-mcq", full=False)
        except Exception as e:
            print(f"  ! MCQ generation skipped: {e}")

        print("Course performance analytics…")
        page.goto(f"{BASE}/instructor/course_performance/", wait_until="networkidle")
        page.wait_for_timeout(1800)  # let Chart.js animate
        shot(page, "i04-course-performance")

        # Global AI analytics assistant (GET, aggregates all students' practice)
        try:
            print("AI analytics assistant…")
            page.goto(f"{BASE}/llmins/aiassist/", wait_until="networkidle")
            page.wait_for_timeout(1800)
            shot(page, "i05-ai-assist")
        except Exception as e:
            print(f"  ! AI assist skipped: {e}")

        browser.close()
    print("Done.")


if __name__ == "__main__":
    run()