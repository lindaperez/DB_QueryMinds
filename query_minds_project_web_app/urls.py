"""
URL configuration for query_minds_project_web_app project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
from myapp.forms import CustomLoginForm  # Import CustomLoginForm


urlpatterns = [
    path('', include('myapp.urls')),  # Include your app’s URLs for the root path
    path('admin/', admin.site.urls),
    # NOTE: django.contrib.auth.urls is intentionally NOT included here. It
    # registers the same URL names (password_reset, password_change, ...) that
    # myapp.urls already defines for our custom hyphenated routes. Because it
    # was included after myapp.urls, reverse('password_reset') resolved to
    # Django's built-in route instead of ours (defect #4). All those names are
    # provided by myapp.urls, so dropping this include resolves the collision.
    path('accounts/login/', auth_views.LoginView.as_view(template_name='accounts/login.html', authentication_form=CustomLoginForm), name='login'),

]
