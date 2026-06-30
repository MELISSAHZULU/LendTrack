from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('apps.users.urls')),
    path('api/borrowers/', include('apps.borrowers.urls')),
    path('api/loans/', include('apps.loans.urls')),
    path('api/payments/', include('apps.payments.urls')),
]
