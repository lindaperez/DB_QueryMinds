from openai import AuthenticationError, OpenAI, OpenAIError, RateLimitError
from django.conf import settings

# Build the client lazily. Instantiating it at import time crashes the whole
# URLconf (and therefore login) whenever OPENAI_API_KEY is unset, because
# views.py imports this module at module load.
_client = None


class OpenAIGenerationError(Exception):
    """User-safe error for SQL question generation failures."""


def get_client():
    global _client
    if _client is None:
        if not settings.OPENAI_API_KEY:
            raise OpenAIGenerationError(
                "OpenAI API key is not configured. Add OPENAI_API_KEY to .env and restart the server."
            )
        _client = OpenAI(api_key=settings.OPENAI_API_KEY)
    return _client

def generate_sql_question_answer(phrase: str, difficulty: str):
    phrase = phrase.lower()

    if "partition by" in phrase:
        if difficulty == "easy":
            question = "List employees and their salary ranks within each department."
            answer = """SELECT name, department, salary,
                               RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
                        FROM employees;"""
        elif difficulty == "medium":
            question = "Show average salary by department and rank employees based on it using PARTITION BY."
            answer = """SELECT name, department, salary,
                               AVG(salary) OVER (PARTITION BY department) AS avg_salary,
                               RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
                        FROM employees;"""
        else:
            question = "Write a query to compare current and previous salary using LAG/PARTITION BY."
            answer = """SELECT name, department, salary,
                               LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) AS prev_salary
                        FROM employees;"""

    elif "with" in phrase:
        if difficulty == "easy":
            question = "Using a WITH clause, show total sales per region."
            answer = """WITH sales_region AS (
                            SELECT region, SUM(sales) AS total_sales
                            FROM orders
                            GROUP BY region
                        )
                        SELECT * FROM sales_region;"""
        else:
            question = "Using WITH and window functions, find top seller per region."
            answer = """WITH ranked_sales AS (
                            SELECT salesperson, region, SUM(amount) AS total_sales,
                                   RANK() OVER (PARTITION BY region ORDER BY SUM(amount) DESC) AS rank
                            FROM sales
                            GROUP BY salesperson, region
                        )
                        SELECT * FROM ranked_sales WHERE rank = 1;"""

    elif "where" in phrase:
        question = "Write a query to return all customers who have placed more than 3 orders."
        answer = """SELECT customer_id
                    FROM orders
                    GROUP BY customer_id
                    HAVING COUNT(*) > 3;"""

    else:
        question = f"Write a SQL query using the phrase '{phrase}' with {difficulty} difficulty."
        answer = "-- This will vary based on schema and goal."

    return question, answer


import random

def generate_multiple_choice_sql(phrase: str, difficulty: str):
    correct_question, correct_answer = generate_sql_question_answer(phrase, difficulty)

    # Add 3 distractors (wrong answers)
    distractors = [
        "SELECT name, department, salary, RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM employees;",  # missing PARTITION BY
        "SELECT name, department, salary, DENSE_RANK() OVER (PARTITION BY department ORDER BY salary ASC) AS salary_rank FROM employees;",  # ASC instead of DESC
        "SELECT name, department, salary FROM employees ORDER BY salary;"  # no rank at all
    ]

    options = distractors + [correct_answer]
    random.shuffle(options)

    return correct_question, options, correct_answer


def generate_sql_with_openai(phrase, difficulty, mode="multiple"):
    prompt = (
        f"Create a {difficulty} level SQL question using the phrase '{phrase}'.\n"
        f"Return:\n"
        f"- The question text\n"
        f"- Exactly 4 SQL query options (A, B, C, D)\n"
        f"- Indicate which one is the correct answer\n"
        f"Format:\n\n"
        f"Question: ...\n"
        f"A) ...\nB) ...\nC) ...\nD) ...\nCorrect Answer: B"
    )

    try:
        response = get_client().chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful SQL instructor."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=700
        )
    except RateLimitError as exc:
        body = exc.body if isinstance(exc.body, dict) else {}
        error = body.get("error", {}) if isinstance(body.get("error"), dict) else {}
        error_code = body.get("code") or error.get("code")
        if error_code == "insufficient_quota":
            raise OpenAIGenerationError(
                "OpenAI quota is unavailable for the configured API key. Check the key's project billing/quota, then restart the server."
            ) from exc
        raise OpenAIGenerationError(
            "OpenAI rate limit was reached. Please wait and try again."
        ) from exc
    except AuthenticationError as exc:
        raise OpenAIGenerationError(
            "OpenAI rejected the configured API key. Check OPENAI_API_KEY in .env, then restart the server."
        ) from exc
    except OpenAIError as exc:
        raise OpenAIGenerationError(
            "OpenAI could not generate a SQL question right now. Check the API key and service configuration."
        ) from exc

    return response.choices[0].message.content.strip()

import re
def parse_openai_mcq_output(raw_text):
    # Split the main text and the answer
    parts = raw_text.split("Answer:")
    question_block = parts[0].strip()
    answer = parts[1].strip() if len(parts) > 1 else "?"

    # Extract individual parts
    question_match = re.search(r"Question:\s*(.*?)(?=A\))", question_block, re.DOTALL)
    question_text = question_match.group(1).strip() if question_match else "Could not parse question"

    # Extract options
    options = re.findall(r"([A-D])\)\s*(.*?)(?=([A-D]\)|$))", question_block, re.DOTALL)
    options_list = [(opt[0], opt[1].strip().replace("\n", " ")) for opt in options]

    return question_text, options_list, answer
