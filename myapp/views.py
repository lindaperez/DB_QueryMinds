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
from .models import Instructor, LearningChapter, Exercise, Evaluation, MultipleOption, ChapterExercise, ChapterEvaluation, EvaluationExercise, Answer, ChapterStudent, AnswerMultipleOption, StudentEvaluation, Attempt
from .forms import ChapterForm, ExerciseForm, EvaluationForm, EvaluationAssignForm, AnswerForm, MultipleOptionFormSet
from django.core.exceptions import PermissionDenied
from datetime import date
from decimal import Decimal
from collections import defaultdict
from django.http import JsonResponse
from django.utils.timezone import now
from django.db.models import Count, Avg
from .models import  Course, StudentCourse, ChapterStudent
import json

def home(request):
    return render(request, 'home.html', {'message': 'Welcome to the Home Page'})

def home_view(request):
    user = request.user
    profile =  user.userprofile
    course = Course.objects.get(pk=6) 
    if not user.is_authenticated:
        return redirect('login')

    context = {
        'user': user,
        'profile': profile,
        'course': course,
    }
    
    return render(request, 'home.html', context)


# Log In
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

# Update Profile 
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

# Registration
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
        student = Student.objects.create(user=user, n_gpa=0.00, d_starting_date=timezone.now(),d_join_date=timezone.now())
        course = Course.objects.get(pk=6)  # Replace with your course ID
      
        all_chpters = LearningChapter.objects.filter(instructor=course.instructor)
        for chapter in all_chpters:
            
            # Registering Student to the corresponding Course
            student_course, created = StudentCourse.objects.get_or_create(
                student=student,
                course=course
            )
            if created:
                print(f"StudentCourse created: {student_course}")
            else:
                print(f"StudentCourse already exists: {student_course}")
            # Registering Student to the corresponding Course Learning Chapters
            chapter_student, created = ChapterStudent.objects.get_or_create(
                student=student,
                learning_chapter=chapter,
                defaults={'d_begin': now().date(), 'n_score': 0, 'n_ranking': 0, 'd_finish': None}
            )
            if created:
                print(f"ChapterStudent created: {chapter_student}")
            else:
                print(f"ChapterStudent already exists: {chapter_student}")
                
                
                
      messages.success(request, "✅ Your account has been created successfully!")
      print('Account created successfully!')
      return redirect('/accounts/login/')
    else:
      print("Register failed!")
  else:
    form = RegistrationForm()

  context = { 'form': form }
  return render(request, 'accounts/register.html', context)

# Log out 
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

# Testing for Chapter Views Feiyan
def chapter1(request):
    return render(request,'chapter1.html')

def chapter2(request):
    return render(request,'chapter2.html')

def chapter3(request):
    return render(request,'chapter3.html')

def studenthub(request):
    return render(request,'studenthub.html')
# End Testing for Chapter Views Feiyan

# Instructor 
# Instructor Learning Chapter Dashboard
@login_required
def instructor_dashboard(request):
    
    message_already_handled = False
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
            try:
                chapter.save()
            except Exception as e:
                print("🔥 Save failed:", e)
                
            # 🔽 Create ChapterStudent for all students
            all_students = Student.objects.all()
            for student in all_students:
                obj = ChapterStudent.objects.filter(
                    student=student,
                    learning_chapter=chapter
                ).first()

                if not obj:
                    obj = ChapterStudent.objects.create(
                        student=student,
                        learning_chapter=chapter,
                        d_begin=now(),
                        d_finish=None,
                        n_score=0,
                        n_ranking=0
                    )
            messages.success(request, "✅ New learning chapter created successfully.")
            return redirect('chapter_dashboard')
        # create chapter student for all students 

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

            exercise_form = ExerciseForm(request.POST, instance=exercise)
            if exercise_form.is_valid():
                exercise_form.save()

                # Update options manually
                for option in exercise.options.all():
                    text_key = f'option_text_{option.id_option}'
                    correct_key = f'option_correct_{option.id_option}'

                    option.v_option = request.POST.get(text_key, option.v_option)
                    option.b_iscorrect = correct_key in request.POST
                    option.save()
                    print(option.v_option,option.b_iscorrect)
                if message_already_handled==False:
                    messages.success(request, "✅ Exercise and options updated successfully.") 
                    message_already_handled = True
                chapter.exercises = Exercise.objects.filter(
                    id_exercise__in=ChapterExercise.objects.filter(id_learningchapter=chapter).values_list('id_exercise', flat=True)
                ).prefetch_related('options')
                for ex in chapter.exercises:
                    ex.edit_form = ExerciseForm(instance=ex)
                    ex.option_formset = MultipleOptionFormSet(instance=ex)
                
            else:
                # Loop through field errors
                for field, errors in exercise_form.errors.items():
                    for error in errors:
                        messages.error(request, f"❌ {field}: {error}")
                        
                        
        if request.method == 'POST' and 'remove_exercise' in request.POST:
            exercise_id = request.POST.get('exercise_id')
            chapter_id = request.POST.get('chapter_id')

            # Ensure both IDs are valid
            exercise = get_object_or_404(Exercise, pk=exercise_id)
            chapter = get_object_or_404(LearningChapter, pk=chapter_id)

            # Remove just the relationship
            ChapterExercise.objects.filter(id_exercise=exercise, id_learningchapter=chapter).delete()
            if message_already_handled==False:
                messages.success(request, "🗑️ Exercise removed from chapter.")
                message_already_handled = True
            chapter.exercises = Exercise.objects.filter(
                    id_exercise__in=ChapterExercise.objects.filter(id_learningchapter=chapter).values_list('id_exercise', flat=True)
                ).prefetch_related('options')
            for ex in chapter.exercises:
                ex.edit_form = ExerciseForm(instance=ex)
                ex.option_formset = MultipleOptionFormSet(instance=ex)
                
    return render(request, 'instructor/chapter_dashboard.html', {
    'chapters': chapters,
    'chapter_form': ChapterForm(),             # For creation
    'exercise_form': exercise_form,
    'evaluation_form': evaluation_form,
})


# Student Learning Dashboard 
# Chapter Detail  
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

# Student Learning Path ((Learning Path)) 
@login_required
def student_learning_view(request):
    
    user = request.user
    try:
        student = Student.objects.get(user=user)
    except Student.DoesNotExist:
        raise PermissionDenied("You must be a student to access this page.")

    #  Handle submitted answer (before loading anything else)
    if request.method == "POST" and "submit_answer" in request.POST:

        exercise_id = request.POST.get("exercise_id")
        chapter_id = request.POST.get("chapter_id")

        if not exercise_id or not chapter_id:
            messages.error(request, "Missing required fields.")
            return render(request, "student/learning_path.html", {
                "student": student,
                "chapters": chapter_data,
                "all_chapters": all_chapters
            })

        exercise = get_object_or_404(Exercise, pk=exercise_id)
        chapter = get_object_or_404(LearningChapter, pk=chapter_id)

        # Handle either MCQ or text-based answer
        selected_option_ids = request.POST.getlist("selected_option")
        answer_text = request.POST.get("answer_text", "").strip()
        
        Answer.objects.filter(student=student, exercise=exercise).delete()

        # Check or create Answer
        answer_obj, answer_created = Answer.objects.get_or_create(
            student=student,
            exercise=exercise,
            defaults={"b_iscorrect": False}
        )
        print(f"Answer object: {answer_obj}, Created: {answer_created}")
        
        # Clear old options if any
        AnswerMultipleOption.objects.filter(answer=answer_obj).delete()
        
        if answer_text == "" and selected_option_ids:
            
            selected_ids = set(map(int, selected_option_ids))
            correct_ids = set(
                MultipleOption.objects.filter(id_exercise=exercise, b_iscorrect=True)
                .values_list("id_option", flat=True)
            )

            print(f"Selected: {selected_ids}, Correct: {correct_ids}")
            answer_obj.b_iscorrect = 1 if (selected_ids == correct_ids) else 0
            print(f"Is Correct: {answer_obj.b_iscorrect}")
            # Clear and save new option links
            AnswerMultipleOption.objects.filter(answer=answer_obj).delete()
            
            answer_obj.n_score = 100 if answer_obj.b_iscorrect==1 else 0
            answer_obj.v_answer = ""  # Clear text answer if options are selected

            # Create or update the AnswerMultipleOption

            try:
                answer_obj.save()
                print(f" ✅ Answer object saved: {answer_obj} create {answer_created}")
                # Create or update the AnswerMultipleOption

                print("✅ DB Check:", Answer.objects.filter(id=answer_obj.id).exists())
                # Explicit flush to DB
                from django.db import connection
                connection.commit()

                exists = Answer.objects.filter(pk=answer_obj.pk).exists()
                print("✅ Commit forced. Answer exists:", exists)
            except Exception as e:
                print("🔥 Save failed:", e)
            
            for option_id in selected_option_ids:
                
                AnswerMultipleOption.objects.filter(answer=answer_obj).delete()
                # Get the MultipleOption object
                option = get_object_or_404(MultipleOption, pk=option_id)
                # Create or update the AnswerMultipleOption
                answer_multiple_options, created = AnswerMultipleOption.objects.get_or_create(
                    answer=answer_obj,
                    option=option
                )
                try:
                    answer_multiple_options.save()
                    print(f" ✅ Multiple option saved: {answer_multiple_options} create {created}")
                    
                except Exception as e:
                    print("🔥 Save failed:", e)
                print(f"Saved AnswerMultipleOption: {answer_multiple_options}")
        elif answer_text:
            
            answer_obj.v_answer = answer_text
            answer_obj.b_iscorrect = 0  # or evaluate against a correct answer if available
            correct_option = MultipleOption.objects.filter(
                id_exercise=exercise,
                b_iscorrect=True
            ).first()

            if correct_option:
                print(f"Correct option: ({correct_option.v_option}) and ANSWER TEXT: ({answer_text})")
                correct_text = correct_option.v_option.strip()
                answer_obj.b_iscorrect = 1 if (answer_text.strip().lower() == correct_text.lower()) else 0
                
                # Save the score
            else:
                # No correct option provided in DB (optional fallback)
                answer_obj.b_iscorrect = None
            
            answer_obj.n_score = 100 if answer_obj.b_iscorrect else 0 

            try:
                answer_obj.save()
                print(f" ANSWER OBJECT {answer_obj} create {answer_created}")
                print("✅ Answer saved successfully.")
            
            except Exception as e:
                print("🔥 Save failed:", e)
            print(f"Saved Answer: {answer_obj.pk}, {answer_obj.v_answer}Score: {answer_obj.n_score}, Is Correct: {answer_obj.b_iscorrect}")

        messages.success(request, "✅ Your answer has been submitted.")

    
        # Finish the chapter in case student answer the last question 
        # calculate # exerc per chapter
        # All exercises in this chapter
        exercise_ids = ChapterExercise.objects.filter(id_learningchapter=chapter).values_list('id_exercise', flat=True)

        # All answers from the student for those exercises
        answered_exercise_ids = Answer.objects.filter(
            student=student,
            exercise__in=exercise_ids
        ).values_list('exercise', flat=True).distinct()

        # Now compare
        total_exercises = len(exercise_ids)
        answered_count = len(answered_exercise_ids)

        if total_exercises == answered_count:
            # set chapter student finish date 
            chapter_student = ChapterStudent.objects.filter(student=student, learning_chapter=chapter).update(d_finish=now()) 
            print(f"ChapterStudent object: {chapter_student}")
      
            try:
                chapter_student.save()
            except Exception as e:
                print("🔥 Save failed:", e)
                print(f"ChapterStudent object saved: {chapter_student}")
            print(f"ChapterStudent object saved: {chapter_student}")
            print("✅ ChapterStudent saved successfully.")
    
        return redirect(f"{request.path}?chapter_id={chapter_id}&exercise_id={exercise_id}")

    active_chapter_id = request.GET.get("chapter_id")
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
        #if chapter.completed:
            #messages.success(request, "🎉 You completed this chapter! Great job!")

        chapter.available = is_completed or is_first or prev_completed

        if chapter.available:
            unlocked_chapter_ids.add(chapter.id_learningchapter)
        #else:
            #messages.success(request, "🏁 You've reached the end of your learning path!")

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
        selected_option_ids = set()
        for ex in exercises:
            try:
                answer_text=""
                is_correct = False
                # Get correct option IDs for this exercise
                options_all = set(
                    MultipleOption.objects.filter(id_exercise=ex)
               
                )
                #print(f"Options for exercise {ex.id_exercise}: {options_all}")
                # Fetch the Answer object
                answer = Answer.objects.get(student=student, exercise=ex)
                if answer:
                    # If it's a text input (single-option text question)
                    if len(options_all) == 1:
                        print(f"✅ Answer tex")
                        answer_text = answer.v_answer
                        is_correct = answer.b_iscorrect
                    else:
                        # Get the student's selected option IDs for this exercise                        
                        selected_option_ids = list(
                            AnswerMultipleOption.objects.filter(answer=answer)
                            .values_list('option__id_option', flat=True)
                        )
                        #print(f"Selected Option IDs: {selected_option_ids}")
                        is_correct = (answer.b_iscorrect==1) 
                        # It's a multiple-option answer
                    submitted = True
                else:
                    submitted = False

                    
            except Answer.DoesNotExist:
                submitted = False

            options = MultipleOption.objects.filter(id_exercise=ex)

            exercise_data.append({
                "exercise": ex,
                "answer": answer_text,
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
            "exercises": exercise_data
        })

    return render(request, "student/learning_path.html", {
        "student": student,
        "chapters": chapter_data,
        "all_chapters": all_chapters,
        "active_chapter_id" : request.GET.get("chapter_id")
    })
    


# Mark chapter read 
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


# Instructor Performance Dashboard 
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.db.models import Avg, Count
from decimal import Decimal
from .models import (
    Instructor, Course, LearningChapter, StudentCourse, Student,
    ChapterStudent, StudentEvaluation, ChapterEvaluation, Evaluation,
    Answer, Attempt
)
import json
from decimal import Decimal
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.db.models import Avg, Count
from .models import (
    Instructor, Course, LearningChapter, StudentCourse, Student,
    ChapterStudent, StudentEvaluation, ChapterEvaluation, Evaluation,
    Answer, Attempt
)

@login_required
def course_performance(request):
    instructor = get_object_or_404(Instructor, user=request.user)
    print(f"INSTRUCTOR {instructor}")
    course = get_object_or_404(Course, pk=6)
    print(f"COURSE {course}")
    chapters = LearningChapter.objects.filter(instructor=instructor)
    print(f"CHAPTERS {chapters}")
    student_ids = StudentCourse.objects.filter(course=course).values_list('student', flat=True).distinct()
    students = Student.objects.filter(pk__in=student_ids)
    print(f"STUDENTS {student_ids.count()}")
    all_exercises = Exercise.objects.filter(
    chapterexercise__id_learningchapter__in=chapters).distinct()
    total_exercises = all_exercises.count()
    
    for stu in students:
        first_student = stu
        chapter_score = Decimal(0)
        chapter_stu_qs = ChapterStudent.objects.filter(student=stu, d_finish__isnull=False)
        # Calculating the student progress
        
         # 2. Count unique exercises student attempted (excluding evaluations)
        attempted_exercises = (
            Answer.objects
            .filter(student=stu, exercise__in=all_exercises)
            .values('exercise')
            .distinct()
            .count()
        )

        # 3. Compute progress %
        if total_exercises > 0:
            progress = round((attempted_exercises / total_exercises) * 100)
            print(f"Progress for {stu}: {progress}%")
        else:
            progress = 0
        
        # Attach progress to student
        stu.progress = progress
        
        for chapter_student in chapter_stu_qs:
            chp = chapter_student.learning_chapter
            if chp and chapter_student.n_score is not None:
                chapter_score += Decimal(chapter_student.n_score / Decimal(100) * chp.f_weight)
        stu.chapter_score = round(chapter_score, 2)

    total_students = students.count()
    print(f"TOTAL STUDENTS {total_students}")
    total_chapters = chapters.count()
    print(f"TOTAL CHAPTERS {total_chapters}")

    completed = ChapterStudent.objects.filter(
        learning_chapter__in=chapters,
        student__in=students,
        d_finish__isnull=False
    )
    completed_chapters = completed.count()
    #print(f"COMPLETED CHAPTERS total chapters:{total_chapters} completed:{completed_chapters},totalstudents* totalchapters: {total_students*total_chapters}, {(completed_chapters/(total_students*total_chapters)*100)}totalchaptertes - completedchapters {total_chapters - completed_chapters}")


    # Chapter performance
    chapter_scores = ChapterStudent.objects.filter(
        learning_chapter__in=chapters,
        student__in=students,
        n_score__isnull=False,
        d_finish__isnull=False,
    )
    avg_chapter_score = round(chapter_scores.aggregate(avg=Avg("n_score"))["avg"] or 0, 2)

    # Evaluation performance
    eval_scores = StudentEvaluation.objects.filter(student__in=students, f_score__isnull=False)
    avg_eval_score = round(eval_scores.aggregate(avg=Avg("f_score"))["avg"] or 0, 2)

    # Completion Rate
    completed_chapter_count = chapter_scores.count()
    total_chapter_count = chapters.count() * total_students
    completion_rate = round((completed_chapter_count / total_chapter_count) * 100, 2) if total_chapter_count else 0

    # Chapter avg scores
    chapter_labels = []
    chapter_avg_scores = []
    for ch in chapters:
        chapter_labels.append(f"Ch {ch.id_learningchapter}")
        avg_score = ChapterStudent.objects.filter(
            learning_chapter=ch,
            d_finish__isnull=False
        ).aggregate(avg=Avg("n_score"))["avg"] or 0
        chapter_avg_scores.append(round(avg_score, 2))

    # Eval performance
    eval_labels = []
    eval_avg_scores = []
    evaluation_ids = ChapterEvaluation.objects.filter(id_learningchapter__in=chapters).values_list('id_evaluation', flat=True)
    evaluations = Evaluation.objects.filter(pk__in=evaluation_ids).distinct()
    for ev in evaluations:
        eval_labels.append(f"Eval {ev.id_evaluation}")
        avg_score = StudentEvaluation.objects.filter(evaluation=ev).aggregate(avg=Avg("f_score"))["avg"] or 0
        eval_avg_scores.append(round(avg_score, 2))

    # Attempt distribution
    answers = Answer.objects.filter(student__in=students)
    attempt_counts = Attempt.objects.filter(answer__in=answers).values('n_attempt_number').annotate(count=Count('n_attempt_number'))

    attempt_data = {
        "1 Attempt": 0,
        "2 Attempts": 0,
        "3+ Attempts": 0
    }
    for item in attempt_counts:
        if item["n_attempt_number"] == 1:
            attempt_data["1 Attempt"] += item["count"]
        elif item["n_attempt_number"] == 2:
            attempt_data["2 Attempts"] += item["count"]
        else:
            attempt_data["3+ Attempts"] += item["count"]

    # ✅ JSON-safe chart data
    total_completition = 0
    if total_students*total_chapters>0:
        total_completition = completed_chapters/(total_students*total_chapters)
        
    dashboard_data = json.dumps({
        "chapterLabels": chapter_labels,
        "chapterScores": [float(score) for score in chapter_avg_scores],
        "evalLabels": eval_labels,
        "evalScores": [float(score) for score in eval_avg_scores],
        "completionLabels": ['Completed %', 'In Progress %'],
        "completionValues": [int(completed_chapter_count), int(total_chapter_count - completed_chapter_count)],
        "studentcompletionValues": [total_completition*100, abs(1-total_completition)*100],
        "attemptLabels": list(attempt_data.keys()),
        "attemptValues": list(attempt_data.values()),
    })

    context = {
        'total_students': total_students,
        'total_chapters': total_chapters,
        'completed_chapters': completed_chapters,
        'avg_chapter_score': avg_chapter_score,
        'avg_eval_score': avg_eval_score,
        'completion_rate': completion_rate,
        'students': students,
        'dashboard_json': dashboard_data,
    }

    return render(request, 'instructor/course_performance.html', context)

#Instructor Student Detail View
@login_required
def instructor_student_detail_view(request):
    student = get_object_or_404(Student, pk=student_id)

    # Chapter performance
    chapter_scores = ChapterStudent.objects.filter(id_student=student).select_related('id_learningchapter')

    # Evaluation scores
    evaluations = StudentEvaluation.objects.filter(id_student=student).select_related('id_evaluation')

    # Raw answers
    answers = Answer.objects.filter(id_student=student)

    context = {
        'student': student,
        'chapter_scores': chapter_scores,
        'evaluations': evaluations,
        'answers': answers,
    }

    return render(request, 'instructor/student_performance.html', context)

from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect, get_object_or_404
from django.db.models import Q
from django.contrib import messages as django_messages

from .forms import MessageForm
from .models.message import Message


@login_required
def inbox_view(request):
    current_user = request.user.username
    active_user = request.GET.get("active")

    messages = Message.objects.filter(
        Q(sender=current_user) | Q(receiver=current_user)
    ).order_by("timestamp")

    conversations = {}
    for msg in messages:
        other = msg.receiver if msg.sender == current_user else msg.sender
        conversations.setdefault(other, []).append(msg)

    return render(request, "user/inbox.html", {
        "conversations": conversations,
        "current_user": current_user,
        "active_user": active_user
    })


@login_required
def send_message_view(request):
    initial = {}
    if 'to' in request.GET:
        initial['receiver'] = request.GET['to']

    if request.method == 'POST':
        form = MessageForm(request.POST)
        if form.is_valid():
            message = form.save(commit=False)
            message.sender = request.user.username
            message.save()

            # 🧠 Detect if it's an AJAX fetch request
            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                return JsonResponse({'status': 'ok'})

            # Fallback for regular form
            messages.success(request, "Message sent successfully!")
            return redirect(f'/inbox/?active={message.receiver}')

    else:
        form = MessageForm(initial=initial)

    return render(request, 'user/send_message.html', {'form': form})


@login_required
def reply_message_view(request, message_id):
    original = get_object_or_404(Message, pk=message_id)
    if request.method == 'POST':
        form = MessageForm(request.POST)
        if form.is_valid():
            reply = form.save(commit=False)
            reply.sender = request.user.username
            reply.receiver = original.sender
            reply.save()
            django_messages.success(request, "Reply sent!")
            return redirect(f'/inbox/?active={message.receiver}')

    else:
        form = MessageForm(initial={'receiver': original.sender})

    return render(request, 'user/reply_message.html', {
        'form': form,
        'original': original
    })

from django.template.loader import render_to_string
from django.http import HttpResponse
from .models.message import Message
from django.db.models import Q

@login_required
def fetch_messages_view(request):
    current_user = request.user.username
    other_user = request.GET.get("user")
    
    messages = Message.objects.filter(
        Q(sender=current_user, receiver=other_user) |
        Q(sender=other_user, receiver=current_user)
    ).order_by("timestamp")

    return HttpResponse(render_to_string("partials/chat_messages.html", {
        "messages": messages,
        "current_user": current_user
    }))
