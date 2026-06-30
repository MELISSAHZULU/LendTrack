from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel, SoftDeleteModel

class Borrower(TimeStampedModel, SoftDeleteModel):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='borrower_profile',
        null=True,
        blank=True,
    )
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    email = models.EmailField(unique=True)
    address = models.TextField(blank=True, null=True)
    national_id = models.CharField(max_length=50, blank=True, null=True)
    is_verified = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name='created_borrowers',
    )
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return self.full_name
