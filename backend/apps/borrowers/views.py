from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Borrower
from .serializers import BorrowerSerializer

class BorrowerListCreateView(generics.ListCreateAPIView):
    queryset = Borrower.objects.all()
    serializer_class = BorrowerSerializer
    permission_classes = [permissions.IsAuthenticated]

class BorrowerDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Borrower.objects.all()
    serializer_class = BorrowerSerializer
    permission_classes = [permissions.IsAuthenticated]
