from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel

class Loan(TimeStampedModel):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('active', 'Active'),
        ('completed', 'Completed'),
        ('defaulted', 'Defaulted'),
        ('rejected', 'Rejected'),
    )
    
    borrower = models.ForeignKey('borrowers.Borrower', on_delete=models.CASCADE, related_name='loans')
    admin = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=2, default=10.00)
    term_months = models.IntegerField(default=6)
    outstanding_balance = models.DecimalField(max_digits=15, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    
    purpose = models.TextField(blank=True, null=True)
    due_date = models.DateField()
    approved_date = models.DateTimeField(null=True, blank=True)
    disbursed_date = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"Loan #{self.id} - {self.borrower.full_name}"
