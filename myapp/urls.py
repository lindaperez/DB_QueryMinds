from django.urls import path
from . import views
from .views import student_learning_view  # Import student_learning_view
from django.contrib.auth import views as auth_views
from .forms import CustomLoginForm  # Import CustomLoginForm

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
    # Components
    path('color/', views.color, name='color'),
    path('typography/', views.typography, name='typography'),
    path('feather-icon/', views.icon_feather, name='icon_feather'),
    path('sample-page/', views.sample_page, name='sample_page'),
    
    # Manage Learning Path for Instructor and Student
    
     path('dashboard/', views.instructor_dashboard, name='chapter_dashboard'),

    #  Student Learning
   
    path("learning-path/", views.student_learning_view, name="student_learning_view"),
    path('submit-answer/', views.submit_answer, name='submit_answer'),
    path('student/mark_chapter_read/', views.mark_chapter_read, name='mark_chapter_read'),

   
   
    #path('student/chapter/<int:chapter_id>/', views.chapter_detail, name='chapter_detail'), 

    # Student learning interface
    #path('learning/', views.student_learning_path, name='student_learning_path'),

    # API endpoint for submitting answers (can be AJAX)
    #path('learning/submit-answer/', views.submit_answer, name='submit_answer'),

    # Chapter progress
    #path('learning/chapter-progress/', views.chapter_progress, name='chapter_progress'),

    # Messaging (if needed)
    #path('messages/', views.message_center, name='message_center'),

    # Instructor course management (optional depending on progress)
    #path('instructor/courses/', views.instructor_courses, name='instructor_courses'),

    # Student course enrollment
    #path('student/enroll/', views.enroll_course, name='enroll_course'),

    # View course details
    #path('course/<int:course_id>/', views.course_detail, name='course_detail'),
    
]


