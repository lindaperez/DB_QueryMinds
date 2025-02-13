from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib import messages



from django.shortcuts import render

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
    return render(request, 'login.html')
