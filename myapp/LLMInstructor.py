import os
import re
import logging
from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from openai import OpenAI
from datetime import datetime
import json
from datetime import datetime
from django.db import connection
from openai import OpenAI
import json
from datetime import datetime, timedelta
from django.contrib.auth.decorators import login_required

client = OpenAI(api_key="")  # Add OpenAI API key
MODEL_NAME = "gpt-4"

logger = logging.getLogger(__name__)


@csrf_exempt
@login_required
def llm_view_record(request):
    if request.method == "POST":
        student_id = request.POST.get("student_id")
        start_date = request.POST.get("start_date")
        end_date = request.POST.get("end_date")

        if not (student_id and start_date and end_date):
            return render(request, "llminstructor/llmsturecord.html", {"error": "Missing input values."})

        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT LOWER(topic) AS topic, COUNT(*) AS times, ROUND(AVG(f_score), 2) AS avg_score
                FROM EXERCISE_LLM e
                JOIN STUDENT_EVALUATION_LLM s ON e.id_exercise_llm = s.id_exercise_llm
                WHERE id_student = %s AND s.d_finish BETWEEN %s AND %s
                GROUP BY LOWER(topic)
                ORDER BY times DESC;
            """, [student_id, start_date, end_date])
            topic_data = cursor.fetchall()
            if not topic_data:
                return render(request, "llminstructor/llmsturecord.html", {
                    "student_id": student_id,
                    "start_date": start_date,
                    "end_date": end_date,
                    "no_data": True,  # 前端可以根据这个 flag 显示提示
                })

            cursor.execute("""
                WITH topic_scores AS (
                    SELECT id_student, LOWER(e.topic) AS topic, AVG(s.f_score) AS avg_score
                    FROM EXERCISE_LLM e
                    JOIN STUDENT_EVALUATION_LLM s ON e.id_exercise_llm = s.id_exercise_llm

                    GROUP BY id_student, LOWER(e.topic)
                ),
                student_totals AS (
                    SELECT id_student, AVG(avg_score) AS total_score FROM topic_scores GROUP BY id_student
                ),
                student_rank AS (
                    SELECT id_student,total_score, RANK() OVER (ORDER BY total_score DESC) AS stu_rank
                    FROM student_totals)
                SELECT total_score, stu_rank
                FROM student_rank
                WHERE id_student = %s;
            """, [student_id])
            rankall = cursor.fetchone()
            total_score = round(rankall[0],2)
            rank = rankall[1]
        topics = [row[0] for row in topic_data]
        topic_summary = ", ".join([f"{t} (avg: {s})" for t, _, s in topic_data])
        prompt = f"""
            The following is a student's practice report:
            Topics practiced: {topic_summary}
            Total score: {total_score}
            Please provide:
            1. A brief suggestion on which topic the student should focus more on (based on average score or times practiced).
            2. Recommend 2 or 3 new topics the student can explore next.

            Format:
            Suggested: <...>
            Recommended: <...>
            Using "you" to address this student and make the reply more likely to stimulate the student's enthusiasm for learning,
            you can add emoji.
            """
        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[
                {"role": "system", "content": "You are a helpful assistant for SQL learning analytics."},
                {"role": "user", "content": prompt},
            ]
        )
        content = response.choices[0].message.content.strip()
        suggested = ""
        recommended = ""
        for line in content.split("\n"):
            if line.lower().startswith("suggested"):
                suggested = line.split(":", 1)[-1].strip()
            elif line.lower().startswith("recommended"):
                recommended = line.split(":", 1)[-1].strip()

        # suggested = "Consider practicing more on: " + ", ".join(topics[-1:]) if topics else "More practice needed."
        # recommended = "You can also explore topics like: 'Window Functions', 'CTEs', 'Subqueries'."

        chart_labels = [row[0] for row in topic_data]
        chart_scores = [float(row[2]) for row in topic_data]

        return render(request, "llminstructor/llmsturecord.html", {
            "student_id": student_id,
            "start_date": start_date,
            "end_date": end_date,
            "topic_data": topic_data,
            "total_score": total_score,
            "rank": rank,
            "suggested": suggested,
            "recommended": recommended,
            "chart_labels": json.dumps(chart_labels),
            "chart_scores": json.dumps(chart_scores),
        })

    return render(request, "llminstructor/llmsturecord.html")


@csrf_exempt
@login_required
def llm_view_AIassist(request):
    topic_report = []
    score_topics = []
    top_students = []
    recent_activity = []
    ai_answer = ""
    generated_sql = ""
    query_text=""
    data=()

    with connection.cursor() as cursor:
        # Part 1 - topic attempts
        cursor.execute("""
            WITH topic_attempts AS (
                SELECT LOWER(e.topic) AS topic, COUNT(*) AS total_attempts
                FROM EXERCISE_LLM e
                JOIN STUDENT_EVALUATION_LLM s ON e.id_exercise_llm = s.id_exercise_llm
                GROUP BY LOWER(e.topic)
            )
            SELECT topic, total_attempts, RANK() OVER (ORDER BY total_attempts DESC) AS topic_rank
            FROM topic_attempts;
        """)
        topic_report = cursor.fetchall()

        # Part 2 - topic scores
        cursor.execute("""
            WITH topic_scores AS (
                SELECT LOWER(e.topic) AS topic, ROUND(AVG(s.f_score), 2) AS avg_score
                FROM EXERCISE_LLM e
                JOIN STUDENT_EVALUATION_LLM s ON e.id_exercise_llm = s.id_exercise_llm
                WHERE s.f_score IS NOT NULL
                GROUP BY LOWER(e.topic)
            )
            SELECT topic, avg_score, RANK() OVER (ORDER BY avg_score DESC) AS topic_score_rank
            FROM topic_scores;
        """)
        score_topics = cursor.fetchall()

        # Part 3 - top students
        cursor.execute("""
            WITH topic_scores AS (
                SELECT id_student, LOWER(e.topic) AS topic, AVG(s.f_score) AS avg_score
                FROM EXERCISE_LLM e
                JOIN STUDENT_EVALUATION_LLM s ON e.id_exercise_llm = s.id_exercise_llm
                GROUP BY id_student, LOWER(e.topic)
            ),
            student_totals AS (
                SELECT id_student, AVG(avg_score) AS total_score
                FROM topic_scores
                GROUP BY id_student
            )
            SELECT id_student, ROUND(total_score, 2), RANK() OVER (ORDER BY total_score DESC)
            FROM student_totals
            LIMIT 3;
        """)
        top_students = cursor.fetchall()

        # Part 4 - recent activity for chart
        cursor.execute("""
            SELECT DATE(s.d_finish) AS day, COUNT(*) AS attempts
            FROM STUDENT_EVALUATION_LLM s
            WHERE s.d_finish >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY day
            ORDER BY day;
        """)
        recent_activity = cursor.fetchall()
        # cursor.execute("""
        #                SELECT * from EXERCISE_LLM;
        #            """)
        # exe = cursor.fetchall()
        # cursor.execute("""
        #                SELECT * from STUDENT_EVALUATION_LLM;
        #            """)
        # eva = cursor.fetchall()
    # Activity data for chart.js
    activity_dates = [str(d) for d, _ in recent_activity]
    activity_counts = [c for _, c in recent_activity]
    if request.method == "POST":
        query_text = request.POST.get("instructor_question")
        if query_text:
            # Use GPT to analyze the query with schema context
            # schema = "Tables: EXERCISE_LLM(topic, id_exercise_llm), STUDENT_EVALUATION_LLM(id_student, f_score, d_finish, id_exercise_llm)"

            gpt_prompt = f"""
            You are a SQL analytics assistant. A teacher asks the following question:

            Question: {query_text}

            Here is the database schema:
            EXERCISE_LLM(topic, id_exercise_llm)
            STUDENT_EVALUATION_LLM(id_student, f_score, d_finish, id_exercise_llm)
            Please write a sql :
            sql: <write your query here>
            Your response should be clear and follow this structure.
            """
            response = client.chat.completions.create(
                model=MODEL_NAME,
                messages=[{"role": "system", "content": "You are a data assistant."},
                          {"role": "user", "content": gpt_prompt}]
            )
            ai_answer = response.choices[0].message.content.strip()
            # Remove "SQL" if present in the response
            generated_sql = re.sub(r"(?i)sql", "", ai_answer)
            # Use regex to extract the SQL part between triple quotes
            match = re.search(r"```(.*?)```", generated_sql, re.DOTALL)
            if match:
                generated_sql = match.group(1).strip()
            else:
                # If no triple quotes found, use the entire response
                generated_sql = generated_sql.strip()
            # print("ai_answer:",ai_answer)
            # print("generated_sql:",generated_sql)
        with connection.cursor() as cursor:
            cursor.execute(generated_sql)
            data = cursor.fetchall()
            # print("data:",data)
    return render(request, "llminstructor/llmAIassist.html", {
        "topic_report": topic_report,
        "score_topics": score_topics,
        "top_students": top_students,
        "activity_dates": json.dumps(activity_dates),
        "activity_counts": json.dumps(activity_counts),
        "ai_question":query_text,
        "executed_result": data,
    })
