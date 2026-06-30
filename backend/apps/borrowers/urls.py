from django.urls import path
from .views import BorrowerListCreateView, BorrowerDetailView

urlpatterns = [
    path('', BorrowerListCreateView.as_view(), name='borrower-list-create'),
    path('<int:pk>/', BorrowerDetailView.as_view(), name='borrower-detail'),
]
