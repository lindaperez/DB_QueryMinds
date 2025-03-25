# myapp/forms.py
from django import forms
from django.contrib.auth.forms import AuthenticationForm

from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm, UsernameField, PasswordResetForm, SetPasswordForm
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _
from .models import Instructor

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
                'placeholder': 'Your phone number'
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
from django.contrib.auth.models import User
from myapp.models.profile import UserProfile


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


