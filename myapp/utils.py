from openai import OpenAI
from django.conf import settings

# Create the client using your Django setting
client = OpenAI(api_key=settings.OPENAI_API_KEY)

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

    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a helpful SQL instructor."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=700
    )

    return response.choices[0].message.content.strip()
