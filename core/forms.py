from django import forms
from django_registration.forms import RegistrationForm
from .models import User


class RegisterForm(RegistrationForm):
    email = forms.EmailField()

    class Meta(RegistrationForm.Meta):
        model = User
        fields = ("email", "password1", "password2")
