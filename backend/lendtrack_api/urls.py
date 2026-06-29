from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    
    # App endpoints
    path('api/users/', include('apps.users.urls')),
    path('api/borrowers/', include('apps.borrowers.urls')),
    path('api/loans/', include('apps.loans.urls')),
    path('api/payments/', include('apps.payments.urls')),
    path('api/recovery/', include('apps.recovery.urls')),
    path('api/reports/', include('apps.reports.urls')),
]