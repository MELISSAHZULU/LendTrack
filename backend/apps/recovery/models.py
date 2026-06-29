from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel

class OverdueLoan(TimeStampedModel):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('in_progress', 'In Progress'),
        ('resolved', 'Resolved'),
        ('written_off', 'Written Off'),
    )
    
    loan = models.OneToOneField('loans.Loan', on_delete=models.CASCADE, related_name='overdue_record')
    days_past_due = models.IntegerField()
    total_overdue_amount = models.DecimalField(max_digits=15, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    assigned_to = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)
    last_contact_date = models.DateTimeField(null=True, blank=True)
    next_contact_date = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"Overdue - {self.loan.borrower.full_name} - {self.days_past_due} days"

class RecoveryActivity(TimeStampedModel):
    ACTIVITY_TYPES = (
        ('call', 'Phone Call'),
        ('sms', 'SMS'),
        ('email', 'Email'),
        ('visit', 'Visit'),
        ('legal', 'Legal Action'),
    )
    
    overdue_loan = models.ForeignKey(OverdueLoan, on_delete=models.CASCADE, related_name='activities')
    activity_type = models.CharField(max_length=20, choices=ACTIVITY_TYPES)
    description = models.TextField()
    performed_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    outcome = models.CharField(max_length=255, blank=True, null=True)
    follow_up_date = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"{self.activity_type} - {self.overdue_loan.loan.borrower.full_name}"
