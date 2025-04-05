from django.urls import path
from . import views
from .views import student_learning_view  # Import student_learning_view
from django.contrib.auth import views as auth_views
from .forms import CustomLoginForm  # Import CustomLoginForm

# Feiyan add LLM part views
from . import LLMStudent
from . import LLMInstructor

urlpatterns = [
    path('', views.home_view, name='home'),  # Home page
    path('home', views.home_view, name='home'),  # Home page
    path('index', views.home_view, name='home'), 
    path('index/', views.home_view, name='home'), 
 
    path('user/profile/', views.update_profile, name='update_profile'),

    path(
        'accounts/login/',
        auth_views.LoginView.as_view(
            template_name='accounts/login.html',
            authentication_form=CustomLoginForm
        ),
        name='login'
    ),
    path('chapter1/',views.chapter1,name='chapter1'),
    path('chapter2/',views.chapter2,name='chapter2'),
    path('chapter3/', views.chapter3, name='chapter3'),
    path('studenthub/',views.studenthub,name='studenthub'),
    
    
    
    #Authentication 
    path('accounts/logout/', views.logout_view, name='logout'),
    path('accounts/register/', views.register, name='register'),
    path('accounts/password-change/', views.UserPasswordChangeView.as_view(), name='password_change'),
    path('accounts/password-change-done/', auth_views.PasswordChangeDoneView.as_view(
        template_name='accounts/password_change_done.html'
    ), name="password_change_done"),
    path('accounts/password-reset/', views.UserPasswordResetView.as_view(), name='password_reset'),
    path('accounts/password-reset-confirm/<uidb64>/<token>/', 
        views.UserPasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('accounts/password-reset-done/', auth_views.PasswordResetDoneView.as_view(
        template_name='accounts/password_reset_done.html'
    ), name='password_reset_done'),
    path('accounts/password-reset-complete/', auth_views.PasswordResetCompleteView.as_view(
        template_name='accounts/password_reset_complete.html'
        ), name='password_reset_complete'),
  
    
    # Manage Learning Path for Instructor and Student
    
     path('dashboard/', views.instructor_dashboard, name='chapter_dashboard'),
     path('instructor/course_performance/', views.course_performance, name='course_performance'),
     
     path('instructor/student/<int:student_id>/', views.instructor_student_detail_view, name='instructor_student_detail_view'),
    #  Student Learning
    path("learning-path/", views.student_learning_view, name="student_learning_view"),

    path('student/mark_chapter_read/', views.mark_chapter_read, name='mark_chapter_read'),


    # LLM urls by Feiyan
    path('llmexe',LLMStudent.llm_interact, name='llm_interact_student'),
    path('llmexe/view/', LLMStudent.view_tasks, name="view_tasks_student"),
    path('llmexe/clear/', LLMStudent.clear_tasks, name='clear_tasks_student'),
    path('llmexe/generate_from_keyword/', LLMStudent.generate_tests_from_keyword, name='generate_from_keyword'),
    path('llmexe/submit_answer/', LLMStudent.submit_answer, name='submit_answer'),
    path("llmexe/submit_final_score/", LLMStudent.submit_final_score, name="submit_final_score"),
    path("llmexe/record/", LLMStudent.llm_view_record, name="llm_view_record"),
    path('llmins/onestu/', LLMInstructor.llm_view_record, name='llm_view_record_ins'),
    path('llmins/aiassist/', LLMInstructor.llm_view_AIassist, name='llm_AIassist'),

]


