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
        
        
