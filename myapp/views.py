from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login
from django.contrib import messages

from django.conf import settings

from django.shortcuts import render
from .forms import LoginForm  


#Authentication 
from admin_datta.forms import RegistrationForm, LoginForm, UserPasswordChangeForm, UserPasswordResetForm, UserSetPasswordForm
from django.contrib.auth.views import LoginView, PasswordChangeView, PasswordResetConfirmView, PasswordResetView
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required

#Instuctor Profile

from myapp.forms import InstructorForm, UserForm
from myapp.models import Instructor

def home(request):
    return render(request, 'home.html', {'message': 'Welcome to the Home Page'})


def home_view(request):
    return render(request, 'home.html', {'message': 'Welcome to the Home Page'})


def login_view(request):

    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')  # Replace 'home' with your homepage URL name
        else:
            messages.error(request, 'Invalid username or password.')
    return render(request, 'accounts/login.html')


# Profile 

@login_required
def update_profile(request):
    user = request.user
    instructor = get_object_or_404(Instructor, user=user)

    if request.method == 'POST':
        user_form = UserForm(request.POST, instance=user)
        instructor_form = InstructorForm(request.POST, instance=instructor)

        if user_form.is_valid() and instructor_form.is_valid():
            user_form.save()
            instructor_form.save()
            messages.success(request, 'Your profile was updated successfully!')
            return redirect('update_profile')  # Redirect so refresh doesn't resubmit form
        else:
            messages.error(request, 'Please correct the error below.')
    else:
        user_form = UserForm(instance=user)
        instructor_form = InstructorForm(instance=instructor)

    return render(request, 'user/edit_profile.html', {
        'user_form': user_form,
        'instructor_form': instructor_form,
    })


# Authentication
class UserLoginView(LoginView):
  template_name = 'accounts/login.html'
  form_class = LoginForm
# views.py

from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from myapp.forms import RegistrationForm
from myapp.models.profile import UserProfile
from myapp.models.instructors import Instructor
from myapp.models.students import Student


def register(request):
  if request.method == 'POST':
    form = RegistrationForm(request.POST)
    if form.is_valid():
      user = form.save(commit=False)
      user.set_password(form.cleaned_data['password1'])  # 
      user.save()

      user_type = form.cleaned_data['user_type']
      UserProfile.objects.create(user=user, user_type=user_type)

      # Optional: Create role-specific profile
      if user_type == 'instructor':
        Instructor.objects.create(user=user, v_specialty='', v_bio='', n_phone='')
      elif user_type == 'student':
        Student.objects.create(user=user, enrollment_date=None, level='')

      print('Account created successfully!')
      return redirect('/accounts/login/')
    else:
      print("Register failed!")
  else:
    form = RegistrationForm()

  context = { 'form': form }
  return render(request, 'accounts/register.html', context)


def logout_view(request):
  logout(request)
  return redirect('/accounts/login/')

class UserPasswordResetView(PasswordResetView):
  template_name = 'accounts/password_reset.html'
  form_class = UserPasswordResetForm

class UserPasswordResetConfirmView(PasswordResetConfirmView):
  template_name = 'accounts/password_reset_confirm.html'
  form_class = UserSetPasswordForm

class UserPasswordChangeView(PasswordChangeView):
  template_name = 'accounts/password_change.html'
  form_class = UserPasswordChangeForm



def chapter1(request):
    return render(request,'chapter1.html')

def chapter2(request):
    return render(request,'chapter2.html')

def chapter3(request):
    return render(request,'chapter3.html')

def studenthub(request):
    return render(request,'studenthub.html')


# Components
def color(request):
  context = {
    'segment': 'color'
  }
  return render(request, "pages/color.html", context)

def typography(request):
  context = {
    'segment': 'typography'
  }
  return render(request, "pages/typography.html", context)

def icon_feather(request):
  context = {
    'segment': 'feather_icon'
  }
  return render(request, "pages/icon-feather.html", context)

def sample_page(request):
  context = {
    'segment': 'sample_page',
  }
  return render(request, 'pages/sample-page.html', context)