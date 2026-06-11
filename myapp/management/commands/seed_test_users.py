"""
Seed a fixed list of test users (students + instructors) with known passwords.

Usage:
    python manage.py seed_test_users           # create / update the test users
    python manage.py seed_test_users --course 6 # enroll students into a given course
    python manage.py seed_test_users --delete   # remove the test users again

The credentials created here are listed in the command output and are meant for
local / staging testing only. Do NOT run this against production.
"""

from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.db import transaction, connection
from django.utils import timezone
from django.utils.timezone import now

from myapp.models.profile import UserProfile
from myapp.models.students import Student
from myapp.models import (
    Instructor,
    Course,
    ChapterStudent,
    LearningChapter,
)

# Default course students are enrolled into. Matches the `register` view,
# which enrolls new students into course pk=6 (and all of its chapters).
DEFAULT_COURSE_ID = 6

# username, password, first, last, email, user_type
TEST_USERS = [
    ("student1",    "Test@1234", "Ava",    "Stone",   "ava.student@test.local",    "student"),
    ("student2",    "Test@1234", "Ben",    "Lee",     "ben.student@test.local",    "student"),
    ("student3",    "Test@1234", "Cara",   "Ortiz",   "cara.student@test.local",   "student"),
    ("student4",    "Test@1234", "Dan",    "Khan",    "dan.student@test.local",    "student"),
    ("student5",    "Test@1234", "Elsa",   "Wright",  "elsa.student@test.local",   "student"),
    ("instructor1", "Test@1234", "Frank",  "Moore",   "frank.inst@test.local",     "instructor"),
    ("instructor2", "Test@1234", "Gina",   "Park",    "gina.inst@test.local",      "instructor"),
]


class Command(BaseCommand):
    help = "Create a fixed set of test users (students & instructors) with known passwords."

    def add_arguments(self, parser):
        parser.add_argument(
            "--course",
            type=int,
            default=DEFAULT_COURSE_ID,
            help=f"Course id to enroll the test students into (and their chapters). "
                 f"Defaults to {DEFAULT_COURSE_ID}.",
        )
        parser.add_argument(
            "--no-course",
            action="store_true",
            help="Create students without enrolling them in any course.",
        )
        parser.add_argument(
            "--delete",
            action="store_true",
            help="Delete the test users instead of creating them.",
        )

    def handle(self, *args, **options):
        if options["delete"]:
            self._delete_users()
            return

        course_id = None if options["no_course"] else options["course"]
        with transaction.atomic():
            for username, password, first, last, email, user_type in TEST_USERS:
                self._create_user(username, password, first, last, email, user_type, course_id)

        self._print_credentials()

    # ------------------------------------------------------------------ #

    def _create_user(self, username, password, first, last, email, user_type, course_id):
        user, created = User.objects.get_or_create(
            username=username,
            defaults={"first_name": first, "last_name": last, "email": email},
        )
        # Always (re)set the known password so the credentials list stays valid.
        user.first_name = first
        user.last_name = last
        user.email = email
        user.set_password(password)
        user.save()

        UserProfile.objects.update_or_create(
            user=user, defaults={"user_type": user_type}
        )

        if user_type == "instructor":
            Instructor.objects.get_or_create(
                user=user,
                defaults={"v_specialty": "", "v_bio": "", "n_phone": ""},
            )
        elif user_type == "student":
            student, _ = Student.objects.get_or_create(
                user=user,
                defaults={
                    "n_gpa": 3.0,
                    "d_starting_date": timezone.now(),
                    "d_join_date": timezone.now(),
                },
            )
            if course_id is not None:
                self._enroll_student(student, course_id)

        action = "created" if created else "updated"
        self.stdout.write(f"  {action}: {username} ({user_type})")

    def _enroll_student(self, student, course_id):
        try:
            course = Course.objects.get(pk=course_id)
        except Course.DoesNotExist:
            self.stdout.write(self.style.WARNING(
                f"    course {course_id} not found - skipping enrollment"
            ))
            return

        # STUDENT_COURSE has a composite PK (id_student, id_course) and no `id`
        # column, but the StudentCourse model declares no primary key, so the
        # Django ORM emits a broken query. Insert directly to stay correct
        # without modifying the shared model.
        with connection.cursor() as cursor:
            cursor.execute(
                "INSERT IGNORE INTO STUDENT_COURSE (id_student, id_course) VALUES (%s, %s)",
                [student.id_student, course.pk],
            )

        chapters = LearningChapter.objects.filter(instructor=course.instructor)
        for chapter in chapters:
            ChapterStudent.objects.get_or_create(
                student=student,
                learning_chapter=chapter,
                defaults={"d_begin": now().date(), "n_score": 0, "n_ranking": 0, "d_finish": None},
            )

    def _delete_users(self):
        usernames = [u[0] for u in TEST_USERS]
        deleted, _ = User.objects.filter(username__in=usernames).delete()
        self.stdout.write(self.style.SUCCESS(
            f"Deleted test users ({deleted} rows incl. related profiles)."
        ))

    def _print_credentials(self):
        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS("Test users ready. Credentials:"))
        self.stdout.write("  " + "-" * 48)
        self.stdout.write(f"  {'username':<14}{'password':<14}{'role'}")
        self.stdout.write("  " + "-" * 48)
        for username, password, _f, _l, _e, user_type in TEST_USERS:
            self.stdout.write(f"  {username:<14}{password:<14}{user_type}")
        self.stdout.write("  " + "-" * 48)
