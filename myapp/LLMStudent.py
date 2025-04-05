# views.py
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
from django.contrib.auth.decorators import login_required

client = OpenAI(api_key="")  # Add OpenAI API key
MODEL_NAME = "gpt-4"

logger = logging.getLogger(__name__)

# main page of studentllm
@csrf_exempt
@login_required
def llm_interact(request):
    # return render(request, "llmstudent/llminteractstu.html", {
    #     "tasks_generated": request.session.get("tasks") is not None
    # })
    message = request.session.pop("message", None)
    return render(request, "llmstudent/llminteract.html",{"message": message})

# LLM generate tasks
@csrf_exempt
@login_required
def generate_tests_from_keyword(request):
    if request.method == "POST":
        keyword = request.POST.get("keyword", "").strip()

        if not keyword:
            return render(request, "llmstudent/llminteract.html", {
                "error": "Input the topic key word you want to practice"
            })

        prompt = f"""
You are a MySQL teaching assistant. Based on the table below（employee and department, employee's primary 
key is ssn, foreign key is dno, dno is the same of dnumber in department, department's primary key is dnumber
），using keyword `{keyword}` , which relates to the syntax of MySQL, you generate 3 mySQL Practice Questions,
including：
1. A short description of the Question
2. SQL sentence
3. short explanation of the sentence

Please return in the following format
Task1:
Description: ...
SQL answer: ...
Explanation: ...

Tables structure:
CREATE TABLE employee (
    fname VARCHAR(8),
    minit VARCHAR(2),
    lname VARCHAR(8),
    ssn VARCHAR(9) NOT NULL,
    bdate DATE,
    address VARCHAR(27),
    sex VARCHAR(1),
    salary INT(7) NOT NULL,
    super_ssn VARCHAR(9),
    dno INT(1) NOT NULL
);
CREATE TABLE department
    (dnumber      INT(1),
    dname        VARCHAR(15),
    mgr_ssn       VARCHAR(9),
    mgr_start_date DATE);
"""

        try:
            response = client.chat.completions.create(
                model=MODEL_NAME,
                messages=[
                    {"role": "system", "content": "You are an SQL training question generator"},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.7,
                max_tokens=1500
            )

            result = response.choices[0].message.content

            tasks = []
            matches = re.findall(r"Task\d+:(.*?)SQL answer:(.*?)(Explanation:.*?)?(?=Task\d+:|$)", result, re.DOTALL)
            for i, (desc, sql, explain) in enumerate(matches):
                tasks.append({
                    "id": i + 1,
                    "title": f"Task {i + 1}",
                    "description": desc.strip(),
                    "sql": sql.strip(),
                    "explanation": explain.replace("Explanation:", "").strip() if explain else ""
                })

            request.session["tasks"] = tasks
            request.session["keyword"] = keyword
            # print("request:",request)
            # print("task:",request.session["tasks"])

            return render(request, "llmstudent/llminteract.html", {
                "message": f"Based on key word “{keyword}”, we have generate the questions，click to start the practice.",
                "tasks_generated": True
            })

        except Exception as e:
            logger.error(f"fail to generate questions: {str(e)}")
            return render(request, "llmstudent/llminteract.html", {
                "error": "fail to generate questions，try again"
            })

# view task generate by LLM
@csrf_exempt
@login_required
def view_tasks(request):
    tasks = request.session.get("tasks", [])
    return render(request, "llmstudent/viewtasks.html", {"tasks": tasks})

# do tasks and autograde by LLM
@csrf_exempt
@login_required
def submit_answer(request):
    if request.method == "POST":
        task_id = int(request.POST.get("task_id"))
        user_sql = request.POST.get("user_sql", "").strip()

        tasks = request.session.get("tasks", [])
        # task = next((t for t in tasks if t["id"] == task_id), None)

        if not tasks:
            return redirect(f"/llmexe/view/#task-{task_id}")
        # 找到当前 task
        for i in range(len(tasks)):
            if int(tasks[i]["id"]) == task_id:
                target_task = tasks[i]
                print("target_task:",target_task)
                break
        else:
            return redirect(f"/llmexe/view/#task-{task_id}")
        prompt = f"""
You are an SQL scoring assistant. I will provide a standard answer and a user-submitted SQL.
You should judge whether the functions of the two SQL statements are consistent, and give a
 brief score (0-100) and a brief explanation.

Standard SQL：
{target_task['sql']}

User SQL：
{user_sql}

Please output in the following format (no additional content) :

score: <0-100>
comment: <Explain the reason for the score>
"""

        try:
            response = client.chat.completions.create(
                model=MODEL_NAME,
                messages=[
                    {"role": "system", "content": "You are an expert in SQL sentence scoring"},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.5,
                max_tokens=500
            )

            content = response.choices[0].message.content.strip()
            score_match = re.search(r"score:\s*(\d+)", content)
            comment_match = re.search(r"comment:\s*(.*)", content, re.DOTALL)

            score = int(score_match.group(1)) if score_match else 0
            comment = comment_match.group(1).strip() if comment_match else "Score parsing failure"

            tasks[i]["feedback"] = {
                "score": score,
                "comment": comment
            }
            tasks[i]["user_sql"] = user_sql
            request.session["tasks"] = tasks
            print("tasks:",tasks)

        except Exception as e:
            logger.error(f"Grading error: {str(e)}")

    return redirect(f"/llmexe/view/#task-{task_id}")

# get final score of certain task and insert the data into database EXERCISE_LLM and
# STUDENT_EVALUATION_LLM
@csrf_exempt
@login_required
def submit_final_score(request):
    if request.method == "POST":
        keyword = request.POST.get("keyword", "No Topic")
        user =request.user
        student_id = user.id  # 假设用户 ID 是 30
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        tasks = request.session.get("tasks", [])
        # clear the task
        request.session.pop("tasks", None)
        scores = [task.get("feedback", {}).get("score", 0) for task in tasks]
        average_score = round(sum(scores) / len(scores), 2) if scores else 0
        try:
            with connection.cursor() as cursor:
                # 插入 EXERCISE_LLM
                cursor.execute("""
                    INSERT INTO EXERCISE_LLM (f_weight, d_deadline, id_difficultylevel, n_max_attempts, topic)
                    VALUES (%s, %s, %s, %s, %s)
                """, [0.01, now, 1, 1, keyword])

                # 获取新插入的练习 ID
                cursor.execute("SELECT LAST_INSERT_ID()")
                exercise_id = cursor.fetchone()[0]

                # 插入 STUDENT_EVALUATION_LLM
                cursor.execute("""
                    INSERT INTO STUDENT_EVALUATION_LLM (id_student, id_exercise_llm, f_score, d_begins, d_finish)
                    VALUES (%s, %s, %s, %s, %s)
                """, [student_id, exercise_id, average_score, now, now])
            request.session["message"] = "✅ Your score has been successfully submitted!"
            return redirect("llm_interact_student")

        except Exception as e:
            logger.error(f"Database insert failed: {e}")
            return render(request, "llmstudent/viewtasks.html", {
                "tasks": tasks,
                "error": "Submit failed. Please try again."
            })

# EXIT interact with LLM
@csrf_exempt
@login_required
def clear_tasks(request):
    request.session.pop("tasks", None)
    return redirect('home')

@csrf_exempt
@login_required
def llm_view_record(request):
    if request.method == "POST":
        student_id = request.user.id
        start_date = request.POST.get("start_date")
        end_date = request.POST.get("end_date")

        if not (student_id and start_date and end_date):
            return render(request, "llmstudent/llmrecord.html", {"error": "Missing input values."})

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
                return render(request, "llmstudent/llmrecord.html", {
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
        print("topic_summary:",topic_summary)
        print("rank:",rank)
        print("total_score:",total_score)
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

        return render(request, "llmstudent/llmrecord.html", {
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

    return render(request, "llmstudent/llmrecord.html")