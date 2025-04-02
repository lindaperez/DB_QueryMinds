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

from .forms import InstructorForm, UserForm, StudentForm

from django.contrib.auth.models import User
from myapp.forms import RegistrationForm
from django.utils import timezone
from myapp.models.profile import UserProfile

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

from .models import Instructor, LearningChapter, Exercise, Evaluation, MultipleOption, ChapterExercise, ChapterEvaluation, EvaluationExercise, Answer, ChapterStudent, AnswerMultipleOption
from .forms import ChapterForm, ExerciseForm, EvaluationForm, EvaluationAssignForm, AnswerForm, MultipleOptionFormSet
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

        for ex in chapter.exercises:
            ex.edit_form = ExerciseForm(instance=ex)
            ex.option_formset = MultipleOptionFormSet(instance=ex)
        
        chapter.evaluations = Evaluation.objects.filter(
            id_evaluation__in=ChapterEvaluation.objects.filter(id_learningchapter=chapter).values_list('id_evaluation', flat=True)
        )
        for ev in chapter.evaluations:
            ev.exercises = Exercise.objects.filter(
                id_exercise__in=EvaluationExercise.objects.filter(id_evaluation=ev).values_list('id_exercise', flat=True)
            )
        if not hasattr(chapter, 'edit_form'):
            chapter.edit_form = ChapterForm(instance=chapter, auto_id=f"id_%s_{chapter.id_learningchapter}")


    # Handle Chapter Edit
    
    # Create one edit form per chapter
    if request.method == 'POST' and 'edit_chapter' in request.POST:
        print("✅ Edit chapter request received!")

        chapter_id = request.POST.get('chapter_edit_id')
        
        print("Chapter ID:", chapter_id)

        chapter = get_object_or_404(LearningChapter, pk=chapter_id)
        print("Chapter instance loaded:",chapter)
        
        edit_chapter_form = ChapterForm(request.POST, instance=chapter)
        print(" ✅ Form",edit_chapter_form)
        
        if edit_chapter_form.is_valid():
            edit_chapter_form.save()
            messages.success(request, "✏️ Chapter updated successfully.")
            return redirect('chapter_dashboard')
        else:
            chapter.edit_form = edit_chapter_form  
            print("❌ Chapter form errors:")
            for field, errors in edit_chapter_form.errors.items():
                for error in errors:
                    print(f"  - {field}: {error}")
            
            print("🧾 Raw POST data:")
            for key, value in request.POST.items():
                print(f"  {key}: {value}")

            print("📋 Form cleaned data (may be missing if invalid):")
            for field in edit_chapter_form.fields:
                value = edit_chapter_form.data.get(field, '[not submitted]')
                print(f"  {field}: {value}")

    # Handle Exercise Edit
    
    # Create one edit form per exercise
    if request.method == 'POST' and 'edit_exercise' in request.POST:
        exercise_id = request.POST.get('exercise_id')
        exercise = get_object_or_404(Exercise, pk=exercise_id)

        # Update exercise fields
        exercise.description = request.POST.get('edit_exercise_desc', exercise.description)
        exercise.f_weight = request.POST.get('edit_exercise_weight', exercise.f_weight)
        exercise.d_deadline = request.POST.get('edit_exercise_deadline', exercise.d_deadline)
        exercise.n_max_attempts = request.POST.get('edit_exercise_attempts', exercise.n_max_attempts)
        exercise.save()

        # Update options manually
        for option in exercise.options.all():
            text_key = f'option_text_{option.id_option}'
            correct_key = f'option_correct_{option.id_option}'

            option.v_option = request.POST.get(text_key, option.v_option)
            option.b_iscorrect = correct_key in request.POST
            option.save()
            print(option.v_option,option.b_iscorrect)
        messages.success(request, "✅ Exercise and options updated successfully.")
        return redirect('chapter_dashboard')
    


    return render(request, 'instructor/chapter_dashboard.html', {
    'chapters': chapters,
    'chapter_form': ChapterForm(),             # For creation
    'exercise_form': exercise_form,
    'evaluation_form': evaluation_form,
})


#Student Learning Views 


from datetime import date


@login_required
def chapter_detail(request, chapter_id):
    user = request.user
    if not user.is_authenticated:
        return redirect('login')
    if user.userprofile.user_type != 'student':
        return render(request, 'access_denied.html')
    if user.is_authenticated:
        try:
            student = get_object_or_404(Student, id_user=request.user)
        except Student.DoesNotExist:
            return render(request, 'access_denied.html')
    if student is None:
        return render(request, 'access_denied.html')

    chapter = get_object_or_404(LearningChapter, id_learningchapter=chapter_id)

    is_enrolled = chapter.courselearnchapter_set.filter(
        course__studentcourse__student=student
    ).exists()
    if not is_enrolled:
        return render(request, 'access_denied.html')

    exercises = Exercise.objects.filter(chapterexercise__chapter=chapter)
    exercise_forms = []

    if request.method == 'POST':
        form = AnswerForm(request.POST)
        if form.is_valid():
            exercise_id = form.cleaned_data['exercise_id']
            exercise = get_object_or_404(Exercise, id_exercise=exercise_id)

            attempt_count = Answer.objects.filter(student=student, exercise=exercise).count()
            if attempt_count < exercise.max_attempts:
                Answer.objects.create(
                    student=student,
                    exercise=exercise,
                    v_answer=form.cleaned_data['answer']
                )
                messages.success(request, 'Answer submitted!')
                return redirect('chapter_detail', chapter_id=chapter_id)
            else:
                messages.error(request, 'Maximum attempts reached.')

    for ex in exercises:
        attempts = Answer.objects.filter(student=student, exercise=ex)
        can_answer = attempts.count() < ex.max_attempts

        form = AnswerForm(initial={'exercise_id': ex.id}) if can_answer else None

        exercise_forms.append({
            'exercise': ex,
            'form': form,
            'attempts': attempts,
            'can_answer': can_answer
        })

    return render(request, 'student/chapter_detail.html', {
        'chapter': chapter,
        'exercise_forms': exercise_forms
    })

# Student Learning 

@login_required
def student_learning_view(request):
    user = request.user
    try:
        student = Student.objects.get(user=user)
    except Student.DoesNotExist:
        raise PermissionDenied("You must be a student to access this page.")

    # Get all chapters and sort them
    all_chapters_qs = LearningChapter.objects.order_by("id_learningchapter")
    all_chapters = list(all_chapters_qs)  # Convert to list for index-based operations

    # Get completed chapter IDs
    completed_chapter_ids = set(
        ChapterStudent.objects.filter(
            student=student,
            d_finish__isnull=False
        ).values_list("learning_chapter", flat=True)
    )

    # Annotate each chapter with `.completed` and `.available`
    unlocked_chapter_ids = set()
    for i, chapter in enumerate(all_chapters):
        is_completed = chapter.id_learningchapter in completed_chapter_ids
        is_first = (i == 0)
        prev_completed = all_chapters[i - 1].id_learningchapter in completed_chapter_ids if i > 0 else False

        chapter.completed = is_completed
        chapter.available = is_completed or is_first or prev_completed

        if chapter.available:
            unlocked_chapter_ids.add(chapter.id_learningchapter)

    # Ensure at least the first chapter is unlocked
    if not unlocked_chapter_ids and all_chapters:
        unlocked_chapter_ids.add(all_chapters[0].id_learningchapter)

    # Collect structured chapter data for the template
    chapter_data = []
    for chapter in all_chapters:
        is_completed = chapter.id_learningchapter in completed_chapter_ids
        is_unlocked = chapter.id_learningchapter in unlocked_chapter_ids

        exercise_ids = ChapterExercise.objects.filter(
            id_learningchapter=chapter
        ).values_list("id_exercise", flat=True)

        exercises = Exercise.objects.filter(
            pk__in=exercise_ids
        ).order_by("pk")

        exercise_data = []

        for ex in exercises:
            try:
                answer = Answer.objects.get(student=student, exercise=ex.pk)
                submitted = True
                is_correct = answer.b_iscorrect

                # Get selected options (many-to-many from ANSWER_MULTIPLE_OPTION)
                selected_option_ids = list(
                    AnswerMultipleOption.objects.filter(answer=answer.pk).values_list("option", flat=True)
                )
            except Answer.DoesNotExist:
                submitted = False
                is_correct = None
                selected_option_ids = []


            options = MultipleOption.objects.filter(id_exercise=ex)

            exercise_data.append({
                "exercise": ex,
                "submitted": submitted,
                "is_correct": is_correct,
                "options": options,
                "selected_option_ids": selected_option_ids,
                "f_weight" : ex.f_weight,
                "d_deadline" : ex.d_deadline,
                "id_difficultylevel" : ex.id_difficultylevel,
                "n_max_attempts" : ex.n_max_attempts,
                "description" : ex.description
            })

        chapter_data.append({
            "chapter": chapter,
            "is_completed": is_completed,
            "is_unlocked": is_unlocked,
            "exercises": exercise_data,
        })

    return render(request, "student/learning_path.html", {
        "student": student,
        "chapters": chapter_data,
        "all_chapters": all_chapters
    })
    
    
@login_required
def submit_answer(request):
    if request.method == 'POST':
        user = request.user
        try:
            student = Student.objects.get(user=user)
        except Student.DoesNotExist:
            raise PermissionDenied("Student account not found.")

        exercise_id = request.POST.get('exercise_id')
        exercise = get_object_or_404(Exercise, pk=exercise_id)

        selected_option_id = request.POST.get(f'selected_option_{exercise.pk}')
        answer_text = request.POST.get('answer_text', '').strip()

        # Initialize placeholders
        v_answer = ''
        is_correct = False

        if selected_option_id:
            # Multiple choice case
            selected_option = get_object_or_404(MultipleOption, pk=selected_option_id)
            v_answer = selected_option.v_option
            is_correct = selected_option.b_iscorrect

        elif answer_text:
            # Open-ended case
            v_answer = answer_text
            is_correct = False  # or use NLP for semantic validation

        else:
            messages.error(request, "❌ No answer was submitted.")
            return redirect('student_learning_view')

        # Save or update the answer
        answer, created = Answer.objects.update_or_create(
            student=student,
            exercise=exercise,
            defaults={
                'v_answer': v_answer,
                'b_iscorrect': is_correct,
                'n_score': 100.00 if is_correct else 0.00,
            }
        )

        # Save selection for MCQ options
        if selected_option_id:
            AnswerMultipleOption.objects.update_or_create(answer=answer, option=selected_option)

        messages.success(request, "✅ Answer submitted!")
        print("✅ Answer submitted!")
        return redirect('student_learning_view')

    return redirect('student_learning_view')

from django.http import JsonResponse
from django.utils.timezone import now
from .models import ChapterStudent, LearningChapter, Student
from django.http import JsonResponse
from django.utils.timezone import now
from .models import ChapterStudent, LearningChapter, Student
from django.contrib.auth.decorators import login_required

@login_required
def mark_chapter_read(request):
    if request.method == 'POST':
        chapter_id = request.POST.get('chapter_id')
        user = request.user
        try:
            student = Student.objects.get(user=user)
            chapter = LearningChapter.objects.get(pk=chapter_id)
        except (Student.DoesNotExist, LearningChapter.DoesNotExist):
            return JsonResponse({'success': False, 'message': 'Invalid student or chapter.'})

        # Use correct field names from your model
        chapter_student, created = ChapterStudent.objects.get_or_create(
            id_student=student,
            id_learningchapter=chapter,
            defaults={'d_begin': now().date()}
        )

        if not chapter_student.d_finish:
            chapter_student.d_finish = now().date()
            chapter_student.save()

        return JsonResponse({'success': True})

    return JsonResponse({'success': False, 'message': 'Invalid request method.'})
