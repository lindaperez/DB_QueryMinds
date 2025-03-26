# myapp/forms.py
from django import forms
from django.contrib.auth.forms import AuthenticationForm

from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm, UsernameField, PasswordResetForm, SetPasswordForm
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _
from .models import Instructor

from .models import Student  
from myapp.models.profile import UserProfile #RegisterForm


class CustomLoginForm(AuthenticationForm):
    username = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Username',
        })
    )
    password = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Password',
        })
    )
    
    
class LoginForm(AuthenticationForm):
  username = UsernameField(label=_("Your Username"), widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Username"}))
  password = forms.CharField(
      label=_("Your Password"),
      strip=False,
      widget=forms.PasswordInput(attrs={"class": "form-control", "placeholder": "Password"}),
  )


# Instructor Form Profile 
class InstructorForm(forms.ModelForm):
    class Meta:
        model = Instructor
        fields = ['n_phone', 'v_specialty', 'v_bio']
        widgets = {
            'n_phone': forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': '+1 (555) 123-4567',
            'type': 'tel',  # use telephone input for mobile support
            'pattern': r'^\+?[0-9\s\-\(\)]{7,20}$',  # simple pattern for validation
            'title': 'Enter a valid phone number (e.g., +1 (555) 123-4567)'
            }),
            'v_specialty': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Your specialty'
            }),
            'v_bio': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 4,
                'placeholder': 'Write something about yourself'
            }),
        }
        labels = {
            'n_phone': 'Phone',
            'v_specialty': 'Specialty',
            'v_bio': 'Bio',
        }

# User form 
class UserForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']
        widgets = {
            'first_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'First Name',
            }),
            'last_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Last Name',
            }),
            'email': forms.EmailInput(attrs={
                'class': 'form-control',
                'placeholder': 'Email Address',
            }),
        }
        
# Register Users as 

# myapp/forms.py
class RegistrationForm(UserCreationForm):
    user_type = forms.ChoiceField(choices=UserProfile.USER_TYPE_CHOICES)

    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'username', 'email', 'password1', 'password2', 'user_type']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in self.fields:
            self.fields[field_name].widget.attrs.update({
                'class': 'form-control',
                'placeholder': self.fields[field_name].label
            })
    def clean_user_type(self):
        user_type = self.cleaned_data.get('user_type')
        if user_type == '':
            raise forms.ValidationError("Please select a valid role.")
        return user_type


class StudentForm(forms.ModelForm):
    class Meta:
        model = Student
        fields = ['n_gpa', 'd_starting_date', 'd_join_date']
        widgets = {
            'n_gpa': forms.NumberInput(attrs={
                'class': 'form-control',
                'step': '0.01',
                'placeholder': 'Your GPA (e.g. 3.75)'
            }),
            'd_starting_date': forms.DateInput(attrs={
                'class': 'form-control',
                'type': 'date'
            }),
            'd_join_date': forms.DateInput(attrs={
                'class': 'form-control',
                'type': 'date'
            }),
        }
        labels = {
            'n_gpa': 'GPA',
            'd_starting_date': 'Starting Date',
            'd_join_date': 'Join Date',
        }
        

# forms for the Instuctor create a Learning Path
from django import forms
from .models import LearningChapter
from django_quill.widgets import QuillWidget

class ChapterForm(forms.ModelForm):
    class Meta:
        model = LearningChapter
        fields = ['v_content', 'd_deadline', 'f_weight']
        
        widgets = {
           'v_content': QuillWidget(), 
            'd_deadline': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'f_weight': forms.NumberInput(attrs={'class': 'form-control'}),
        }
        labels = {
            'v_content': 'Chapter Content',
            'd_deadline': 'Deadline',
            'f_weight': 'Weight (%)',
        }

from .models import Exercise

class ExerciseForm(forms.ModelForm):
    class Meta:
        model = Exercise
        fields = ['description', 'f_weight', 'd_deadline', 'id_difficultylevel', 'n_max_attempts']
        widgets = {
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
          
            'f_weight': forms.NumberInput(attrs={'class': 'form-control'}),
            'd_deadline': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'id_difficultylevel': forms.Select(attrs={'class': 'form-control'}),
            'n_max_attempts': forms.NumberInput(attrs={'class': 'form-control'}),
        }
        labels = {
            'description': 'Question / Description',
            'f_weight': 'Weight (%)',
            'd_deadline': 'Deadline',
            'id_difficultylevel': 'Difficulty Level',
            'n_max_attempts': 'Max Attempts',
        }

from .models import Evaluation

class EvaluationForm(forms.ModelForm):
    class Meta:
        model = Evaluation
        fields = ['f_weight', 'd_deadline']
        widgets = {
            'f_weight': forms.NumberInput(attrs={'class': 'form-control'}),
            'd_deadline': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
        }
        labels = {
            'f_weight': 'Evaluation Weight (%)',
            'd_deadline': 'Deadline',
        }
class EvaluationAssignForm(forms.Form):
    id_exercise = forms.IntegerField(widget=forms.Select(attrs={'class': 'form-control'}))

    def __init__(self, *args, **kwargs):
        exercises = kwargs.pop('exercises')
        super().__init__(*args, **kwargs)
        self.fields['id_exercise'].widget.choices = [(e.id_exercise, e.description[:60]) for e in exercises]
