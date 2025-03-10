from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),  # Root URL
    path('login/', views.login_view, name='login'),
    path('chapter1/',views.chapter1,name='chapter1'),
    path('chapter2/',views.chapter2,name='chapter2'),
    path('chapter3/', views.chapter3, name='chapter3'),
    path('studenthub/',views.studenthub,name='studenthub'),

]

