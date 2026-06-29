from django.db import models
from apps.core.models import TimeStampedModel

class PaymentTransaction(TimeStampedModel):
    TRANSACTION_TYPES = (
        ('disbursement', 'Disbursement'),
        ('repayment', 'Repayment'),
    )
    
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('processing', 'Processing'),
        ('success', 'Success'),
        ('failed', 'Failed'),
    )
    
    loan = models.ForeignKey('loans.Loan', on_delete=models.CASCADE, related_name='transactions')
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    
    paychangu_ref = models.CharField(max_length=100, unique=True)
    paychangu_response = models.JSONField(null=True, blank=True)
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    payment_link = models.URLField(blank=True, null=True)
    
    completed_date = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"{self.type} - {self.amount} - {self.status}"
