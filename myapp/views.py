from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login
from django.contrib import messages

from django.conf import settings
from .forms import LoginForm  


#Authentication 
from admin_datta.forms import RegistrationForm, LoginForm, UserPasswordChangeForm, UserPasswordResetForm, UserSetPasswordForm
from django.contrib.auth.views import LoginView, PasswordChangeView, PasswordResetConfirmView, PasswordResetView
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required

#Instuctor Profile

from myapp.forms import InstructorForm, UserForm, StudentForm
from myapp.models import Instructor

from django.contrib.auth.models import User
from myapp.forms import RegistrationForm
from django.utils import timezone
from myapp.models.profile import UserProfile
from myapp.models.instructors import Instructor
from myapp.models.students import Student


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

from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.shortcuts import render, redirect

@login_required
def update_profile(request):
    user = request.user
    type_role = user.userprofile.user_type
    student_form = None
    instructor_form = None
    student = None
    instructor = None

    if request.method == 'POST':
        user_form = UserForm(request.POST, instance=user)

        if type_role == 'instructor':
            instructor = request.user.instructor
            instructor_form = InstructorForm(request.POST, instance=instructor)
            if user_form.is_valid() and instructor_form.is_valid():
                user_form.save()
                instructor_form.save()
                messages.success(request, 'Your profile was updated successfully!')
                return redirect('update_profile')
            else:
                messages.error(request, 'Please correct the error below.')

        elif type_role == 'student':
            student = request.user.student
            student_form = StudentForm(request.POST, instance=student)
            if user_form.is_valid() and student_form.is_valid():
                user_form.save()
                student_form.save()
                messages.success(request, 'Your profile was updated successfully!')
                return redirect('update_profile')
            else:
                messages.error(request, 'Please correct the error below.')

    else:
        user_form = UserForm(instance=user)

        if type_role == 'instructor':
            instructor = request.user.instructor
            instructor_form = InstructorForm(instance=instructor)

        elif type_role == 'student':
            student = request.user.student
            student_form = StudentForm(instance=student)

    return render(request, 'user/edit_profile.html', {
        'user_form': user_form,
        'student_form': student_form,
        'instructor_form': instructor_form,
    })



# Authentication
class UserLoginView(LoginView):
  template_name = 'accounts/login.html'
  form_class = LoginForm
# views.py



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
        Student.objects.create(id_user=user, n_gpa=0.00, d_starting_date=timezone.now(),d_join_date=timezone.now())

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




# Views for Learning Chapter for Instructor and Student

from django.shortcuts import render, redirect, get_object_or_404
from .models import Instructor, LearningChapter, Exercise, Evaluation, MultipleOption, ChapterExercise, ChapterEvaluation, EvaluationExercise
from .forms import ChapterForm, ExerciseForm, EvaluationForm, EvaluationAssignForm
from django.core.exceptions import PermissionDenied

from django.contrib.auth.decorators import login_required
from django.utils import timezone
from datetime import date
from django.contrib import messages

@login_required
def instructor_dashboard(request):
    user = request.user
    try:
        instructor = Instructor.objects.get(user=user)
    except Instructor.DoesNotExist:
        raise PermissionDenied("You must be an instructor to access this page.")

    # Forms
    chapter_form = ChapterForm(request.POST or None)
    exercise_form = ExerciseForm()
    evaluation_form = EvaluationForm()

    # Handle New Chapter
    if request.method == 'POST' and 'create_chapter' in request.POST:
        if chapter_form.is_valid():
            chapter = chapter_form.save(commit=False)
            chapter.instructor = instructor
            chapter.d_created_at = date.today()
            chapter.save()
            messages.success(request, "✅ New learning chapter created successfully.")
            return redirect('chapter_dashboard')

    # Handle New Exercise
    if request.method == 'POST' and 'create_exercise' in request.POST:
        chapter_id = request.POST.get('chapter_id')
        chapter = get_object_or_404(LearningChapter, pk=chapter_id)
        exercise_form = ExerciseForm(request.POST)
        if exercise_form.is_valid():
            exercise = exercise_form.save()
            ChapterExercise.objects.create(id_learningchapter=chapter, id_exercise=exercise)
            for i in range(1, 5):
                opt_text = request.POST.get(f'option_text_{i}')
                is_correct = request.POST.get(f'option_correct_{i}') == 'on'
                if opt_text:
                    MultipleOption.objects.create(
                        id_exercise=exercise,
                        v_option=opt_text,
                        b_iscorrect=is_correct
                    )
            messages.success(request, "📝 Exercise added to chapter.")
            return redirect('chapter_dashboard')

    # Handle New Evaluation
    if request.method == 'POST' and 'create_evaluation' in request.POST:
        chapter_id = request.POST.get('chapter_id')
        chapter = get_object_or_404(LearningChapter, pk=chapter_id)
        evaluation_form = EvaluationForm(request.POST)
        if evaluation_form.is_valid():
            evaluation = evaluation_form.save()
            ChapterEvaluation.objects.create(id_learningchapter=chapter, id_evaluation=evaluation)
            messages.success(request, "📊 Evaluation created and linked to chapter.")
            return redirect('chapter_dashboard')

    # Handle Assign Exercise to Evaluation
    if request.method == 'POST' and 'assign_exercise' in request.POST:
        evaluation_id = request.POST.get('evaluation_id')
        evaluation = get_object_or_404(Evaluation, pk=evaluation_id)
        exercise_id = request.POST.get('id_exercise')
        exercise = get_object_or_404(Exercise, pk=exercise_id)
        EvaluationExercise.objects.create(id_evaluation=evaluation, id_exercise=exercise)
        messages.success(request, "➕ Exercise assigned to evaluation.")
        return redirect('chapter_dashboard')

    # Load Dashboard Data
    chapters = LearningChapter.objects.filter(instructor=instructor)
    for chapter in chapters:
        chapter.exercises = Exercise.objects.filter(
            id_exercise__in=ChapterExercise.objects.filter(id_learningchapter=chapter).values_list('id_exercise', flat=True)
        ).prefetch_related('options')

        chapter.evaluations = Evaluation.objects.filter(
            id_evaluation__in=ChapterEvaluation.objects.filter(id_learningchapter=chapter).values_list('id_evaluation', flat=True)
        )
        for ev in chapter.evaluations:
            ev.exercises = Exercise.objects.filter(
                id_exercise__in=EvaluationExercise.objects.filter(id_evaluation=ev).values_list('id_exercise', flat=True)
            )
            

    return render(request, 'instructor/chapter_dashboard.html', {
        'chapters': chapters,
        'chapter_form': chapter_form,
        'exercise_form': exercise_form,
        'evaluation_form': evaluation_form,
    })
