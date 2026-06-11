"""
Comprehensive test suite for the LOGIN use case.

Covered scenarios (per the QA request):
  1. The user does NOT exist.
  2. The user exists (happy path / successful login).
  3. The password is wrong.
  4. The user wants to recover their password (password reset flow).

Run with:
    python manage.py test myapp --settings=query_minds_project_web_app.test_settings -v 2
"""
from django.test import TestCase, TransactionTestCase, Client
from django.urls import reverse
from django.db import connection
from django.contrib.auth.models import User
from django.core import mail

from myapp.models.profile import UserProfile
from myapp.models.courses import Course
from myapp.models.students import Student


def ensure_table(model):
    """
    Create the DB table for an unmanaged model in the (throwaway) test database.

    Most domain models in this project use `managed = False`, so Django's test
    runner never creates their tables. The home page hit right after login
    queries COURSE, so we materialise an empty table to exercise the real view.
    """
    if model._meta.db_table in connection.introspection.table_names():
        return
    with connection.schema_editor() as editor:
        editor.create_model(model)


class LoginTestBase(TestCase):
    """Shared fixtures for every login scenario."""

    USERNAME = "alice"
    PASSWORD = "S3cret-Pass-123"
    EMAIL = "alice@example.com"

    def setUp(self):
        self.client = Client()
        self.login_url = reverse("login")           # /accounts/login/
        self.logout_url = reverse("logout")         # /accounts/logout/
        self.reset_url = reverse("password_reset")  # /accounts/password-reset/

        # A fully-provisioned, valid user (User + linked UserProfile, like register() builds).
        self.user = User.objects.create_user(
            username=self.USERNAME,
            email=self.EMAIL,
            password=self.PASSWORD,
        )
        UserProfile.objects.create(user=self.user, user_type="student")

    def _is_authenticated(self):
        """True if the test client currently holds an authenticated session."""
        return "_auth_user_id" in self.client.session


# ---------------------------------------------------------------------------
# Scenario 1: user does NOT exist
# ---------------------------------------------------------------------------
class UserDoesNotExistTests(LoginTestBase):

    def test_login_page_renders(self):
        """The login page itself must load (GET 200)."""
        resp = self.client.get(self.login_url)
        self.assertEqual(resp.status_code, 200)
        self.assertTemplateUsed(resp, "accounts/login.html")

    def test_nonexistent_user_is_rejected(self):
        resp = self.client.post(
            self.login_url,
            {"username": "ghost", "password": "whatever-123"},
        )
        # Should re-render the login page (200), NOT redirect.
        self.assertEqual(resp.status_code, 200)
        self.assertFalse(self._is_authenticated())

    def test_nonexistent_user_sees_error_message(self):
        resp = self.client.post(
            self.login_url,
            {"username": "ghost", "password": "whatever-123"},
        )
        form = resp.context["form"]
        self.assertTrue(form.errors)
        # Django's default invalid-login message must not leak whether the user exists.
        self.assertContains(
            resp,
            "Please enter a correct username and password",
            status_code=200,
        )


# ---------------------------------------------------------------------------
# Scenario 2: user exists -> successful login (happy path)
# ---------------------------------------------------------------------------
class ValidLoginTests(LoginTestBase):

    def test_valid_credentials_authenticate(self):
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": self.PASSWORD},
        )
        # LoginView redirects (302) to LOGIN_REDIRECT_URL on success.
        self.assertEqual(resp.status_code, 302)
        self.assertTrue(self._is_authenticated())

    def test_valid_login_redirects_to_home(self):
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": self.PASSWORD},
        )
        self.assertRedirects(resp, "/", fetch_redirect_response=False)

    def test_next_parameter_is_honored(self):
        """A ?next= target should be respected after login."""
        resp = self.client.post(
            self.login_url + "?next=/user/profile/",
            {"username": self.USERNAME, "password": self.PASSWORD},
        )
        self.assertRedirects(resp, "/user/profile/", fetch_redirect_response=False)


class HomeAfterLoginTests(TransactionTestCase):
    """
    Regression guard: a *successful* login lands the user on '/' (home_view),
    so that page must never 500. Before the fix, home_view did
    `Course.objects.get(pk=6)` (and `user.userprofile` directly), which raised
    Course.DoesNotExist / RelatedObjectDoesNotExist for many real users.

    Uses TransactionTestCase because creating the unmanaged COURSE table needs
    a schema edit outside the per-test atomic block that TestCase opens.
    """

    def test_home_page_loads_when_course_missing(self):
        ensure_table(Course)   # unmanaged models; tables absent by default in tests
        ensure_table(Student)  # a student's home page reads request.user.student
        self.assertFalse(Course.objects.filter(pk=6).exists())

        user = User.objects.create_user(username="bob", password="S3cret-Pass-123")
        UserProfile.objects.create(user=user, user_type="student")

        self.client.force_login(user)
        resp = self.client.get("/")
        self.assertEqual(resp.status_code, 200)

    def test_home_page_loads_when_user_has_no_profile(self):
        """Superusers created via createsuperuser have no UserProfile row."""
        ensure_table(Course)
        user = User.objects.create_superuser(
            username="root", email="root@example.com", password="S3cret-Pass-123"
        )
        self.client.force_login(user)
        resp = self.client.get("/")
        self.assertEqual(resp.status_code, 200)


# ---------------------------------------------------------------------------
# Scenario 3: wrong password
# ---------------------------------------------------------------------------
class WrongPasswordTests(LoginTestBase):

    def test_wrong_password_is_rejected(self):
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": "totally-wrong"},
        )
        self.assertEqual(resp.status_code, 200)
        self.assertFalse(self._is_authenticated())

    def test_wrong_password_shows_error(self):
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": "totally-wrong"},
        )
        self.assertTrue(resp.context["form"].errors)

    def test_empty_password_is_rejected(self):
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": ""},
        )
        self.assertEqual(resp.status_code, 200)
        self.assertFalse(self._is_authenticated())

    def test_inactive_user_cannot_login(self):
        self.user.is_active = False
        self.user.save()
        resp = self.client.post(
            self.login_url,
            {"username": self.USERNAME, "password": self.PASSWORD},
        )
        self.assertFalse(self._is_authenticated())


# ---------------------------------------------------------------------------
# Scenario 4: password recovery (reset) flow
# ---------------------------------------------------------------------------
class PasswordRecoveryTests(LoginTestBase):

    def test_reset_page_renders(self):
        """The 'Forgot Password?' page must load."""
        resp = self.client.get(self.reset_url)
        self.assertEqual(resp.status_code, 200)

    def test_reset_sends_email_for_known_user(self):
        resp = self.client.post(self.reset_url, {"email": self.EMAIL})
        # Should redirect to password_reset_done.
        self.assertEqual(resp.status_code, 302)
        self.assertEqual(len(mail.outbox), 1)
        self.assertIn(self.EMAIL, mail.outbox[0].to)

    def test_reset_for_unknown_email_does_not_leak(self):
        """
        Posting an unknown email must behave identically (redirect, no error)
        so attackers can't enumerate registered emails. No email is sent.
        """
        resp = self.client.post(self.reset_url, {"email": "nobody@example.com"})
        self.assertEqual(resp.status_code, 302)
        self.assertEqual(len(mail.outbox), 0)

    def test_login_page_links_to_reset(self):
        """The login page must expose the recovery entry point."""
        resp = self.client.get(self.login_url)
        self.assertContains(resp, self.reset_url)


# ---------------------------------------------------------------------------
# Scenario 4 (TDD): the team's CUSTOM password templates must exist & render.
#
# These tests are RED on purpose right now. They target the custom hyphenated
# routes wired to UserPasswordReset/Confirm/Change views, whose templates
# (accounts/password_*.html) do not exist yet -> the views currently 500 with
# TemplateDoesNotExist. Each test turns GREEN as its template is created.
#
# We hit the hyphenated paths directly (not via reverse()) because of the
# URL-name collision documented in PasswordResetUrlNameCollisionTests below:
# reverse('password_reset') resolves to Django's built-in flow, not these.
# ---------------------------------------------------------------------------
class CustomPasswordTemplateTDDTests(LoginTestBase):

    def setUp(self):
        super().setUp()
        # Don't raise the rendering exception; we want a clean 500-vs-200
        # assertion failure rather than an error while the template is missing.
        self.client = Client(raise_request_exception=False)

    def _assert_renders(self, url, template):
        resp = self.client.get(url)
        self.assertEqual(
            resp.status_code, 200,
            f"{url} should render 200 once {template} exists (got {resp.status_code}).",
        )
        self.assertTemplateUsed(resp, template)

    def test_password_reset_form_template(self):
        self._assert_renders(
            "/accounts/password-reset/", "accounts/password_reset.html"
        )

    def test_password_reset_done_template(self):
        self._assert_renders(
            "/accounts/password-reset-done/", "accounts/password_reset_done.html"
        )

    def test_password_reset_confirm_template(self):
        # An invalid token still renders the confirm template (validlink=False),
        # which is enough to prove the template exists.
        self._assert_renders(
            "/accounts/password-reset-confirm/MQ/invalid-token/",
            "accounts/password_reset_confirm.html",
        )

    def test_password_reset_complete_template(self):
        self._assert_renders(
            "/accounts/password-reset-complete/",
            "accounts/password_reset_complete.html",
        )

    def test_password_change_template(self):
        # password change is login-required.
        self.client.force_login(self.user)
        self._assert_renders(
            "/accounts/password-change/", "accounts/password_change.html"
        )

    def test_password_change_done_template(self):
        self.client.force_login(self.user)
        self._assert_renders(
            "/accounts/password-change-done/", "accounts/password_change_done.html"
        )


# ---------------------------------------------------------------------------
# Defect #4 (TDD): the 'password_reset*' URL names collide.
#
# django.contrib.auth.urls is included at the project level, so reverse() for
# these names returns Django's built-in (admin-themed) URLs instead of the
# team's custom hyphenated ones. The login page's "Forgot Password?" link uses
# {% url 'password_reset' %}, so it never reaches the custom flow.
#
# RED now; turns GREEN once the collision is resolved (e.g. by removing the
# duplicate include or namespacing one set of routes).
# ---------------------------------------------------------------------------
class PasswordResetUrlNameCollisionTests(TestCase):

    def test_password_reset_name_points_to_custom_route(self):
        self.assertEqual(reverse("password_reset"), "/accounts/password-reset/")

    def test_password_change_name_points_to_custom_route(self):
        self.assertEqual(reverse("password_change"), "/accounts/password-change/")


# ---------------------------------------------------------------------------
# Production readiness: password-recovery email must be *deliverable*.
#
# The app correctly GENERATES the reset email, but whether it reaches a real
# inbox depends on EMAIL_BACKEND. The project currently defaults to the console
# backend, which only prints to the server log -> users never get the email.
#
# These tests inspect the PRODUCTION settings module directly (not
# django.conf.settings, which the test settings override to an in-memory
# backend), so they reflect what a real deployment would actually use.
#
# RED until a real SMTP/provider backend + host credentials are configured
# (e.g. via env vars). This is the deployment gate that flags "still on console".
# ---------------------------------------------------------------------------
class ProductionEmailDeliveryConfigTests(TestCase):

    NON_DELIVERING_BACKENDS = {
        "django.core.mail.backends.console.EmailBackend",
        "django.core.mail.backends.dummy.EmailBackend",
        "django.core.mail.backends.locmem.EmailBackend",
        "django.core.mail.backends.filebased.EmailBackend",
    }

    def _prod_settings(self):
        # The production module keeps its own resolved values even though
        # django.conf.settings is pointed at test_settings during the run.
        from query_minds_project_web_app import settings as prod
        return prod

    def test_email_backend_actually_delivers(self):
        backend = getattr(self._prod_settings(), "EMAIL_BACKEND", "")
        import sys; sys.stderr.write(f"\n[DEBUG] backend seen at runtime = {backend!r}\n")
        self.assertNotIn(
            backend, self.NON_DELIVERING_BACKENDS,
            f"EMAIL_BACKEND={backend!r} does not deliver real email. "
            "Configure an SMTP/provider backend so password-recovery emails "
            "actually reach users.",
        )
        self.assertIn(
            "smtp", backend.lower(),
            f"Expected an SMTP-based EMAIL_BACKEND for real delivery, got {backend!r}.",
        )

    def test_smtp_host_credentials_present(self):
        prod = self._prod_settings()
        host = getattr(prod, "EMAIL_HOST", "") or ""
        user = getattr(prod, "EMAIL_HOST_USER", "") or ""
        password = getattr(prod, "EMAIL_HOST_PASSWORD", "") or ""

        self.assertTrue(
            host and host != "localhost",
            "EMAIL_HOST is unset/localhost; set your mail server host.",
        )
        self.assertTrue(user, "EMAIL_HOST_USER is empty; set the SMTP username.")
        self.assertTrue(password, "EMAIL_HOST_PASSWORD is empty; set the SMTP password.")

    def test_default_from_email_is_branded(self):
        """A real From address should be set (not Django's webmaster@localhost)."""
        sender = getattr(self._prod_settings(), "DEFAULT_FROM_EMAIL", "")
        self.assertTrue(sender and "localhost" not in sender,
                        f"DEFAULT_FROM_EMAIL looks unconfigured: {sender!r}.")
