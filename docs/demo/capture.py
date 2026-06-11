"""
Capture the student-experience screenshots used in the project README.

Usage:
    cd query_minds_project_web_app && python manage.py runserver   # server on :8000
    query_minds_project_web_app/venv/bin/python docs/demo/capture.py

Notes
-----
* Logs in as a seeded student (see USER/PASSWORD) and walks each student flow.
* The Datta Able sidebar is ``position: fixed``, so on a tall ``full_page``
  capture it only spans the first viewport. ``normalize()`` stretches it to the
  full document height so long pages (learning path, AI tasks) look consistent.
* Dashboard-style pages (home) are captured at viewport height, not full_page —
  full_page re-layout makes their two-column grid overlap the fixed sidebar.
* The AI flows (07/08/09) make live GPT-4 calls and need an OPENAI_API_KEY.
"""
import pathlib
from playwright.sync_api import sync_playwright

BASE = "http://127.0.0.1:8000"
USER = "FeiZhou"
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


def shot(page, name, full=True, settle=600):
    page.wait_for_timeout(settle)
    if full:
        page.evaluate(NORMALIZE)
        page.wait_for_timeout(200)
    page.screenshot(path=str(OUT / f"{name}.png"), full_page=full)
    print(f"  ✓ {name}.png")


def run():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        ctx = browser.new_context(viewport={"width": 1440, "height": 900}, device_scale_factor=2)
        page = ctx.new_page()

        page.goto(f"{BASE}/accounts/login/", wait_until="networkidle")
        shot(page, "01-login", full=False)

        page.fill("input[name=username]", USER)
        page.fill("input[name=password]", PASSWORD)
        page.click("button[type=submit], input[type=submit]")
        page.wait_for_load_state("networkidle")

        page.goto(f"{BASE}/home", wait_until="networkidle")
        shot(page, "02-home", full=False)            # dashboard grid — viewport only

        page.goto(f"{BASE}/learning-path/", wait_until="networkidle")
        shot(page, "04-learning-path")               # long page — full + normalize

        page.goto(f"{BASE}/llmexe", wait_until="networkidle")
        shot(page, "05-ai-practice", full=False)

        page.goto(f"{BASE}/inbox/?active=lindaperez", wait_until="networkidle")
        shot(page, "06-inbox", full=False)           # open conversation thread

        # AI practice: live GPT-4 generation -> task list
        try:
            page.goto(f"{BASE}/llmexe", wait_until="networkidle")
            page.fill("input[name=keyword]", "JOIN")
            page.click("button[type=submit], input[type=submit]")
            page.wait_for_load_state("networkidle", timeout=60000)
            shot(page, "07-ai-generated", full=False)
            page.goto(f"{BASE}/llmexe/view/", wait_until="networkidle")
            shot(page, "08-ai-tasks")
        except Exception as e:
            print(f"  ! AI generation skipped: {e}")

        # AI practice analytics: live GPT-4 recommendations + Chart.js
        # (requires seeded EXERCISE_LLM / STUDENT_EVALUATION_LLM rows for the student)
        try:
            page.goto(f"{BASE}/llmexe/record/", wait_until="networkidle")
            page.fill("input[name=start_date]", "2025-05-01")
            page.fill("input[name=end_date]", "2025-05-31")
            page.click("button[type=submit]")
            page.wait_for_load_state("networkidle", timeout=60000)
            page.wait_for_timeout(1800)              # let Chart.js animate in
            shot(page, "09-ai-record")
        except Exception as e:
            print(f"  ! Record page skipped: {e}")

        browser.close()
    print("Done.")


if __name__ == "__main__":
    run()