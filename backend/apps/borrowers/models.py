from django.db import models
from django.conf import settings
from apps.core.models import TimeStampedModel, SoftDeleteModel

class Borrower(TimeStampedModel, SoftDeleteModel):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE,
        related_name='borrower_profile'
    )
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    address = models.TextField()
    date_of_birth = models.DateField(null=True, blank=True)
    
    national_id = models.CharField(max_length=50, blank=True, null=True)
    id_front_url = models.URLField(blank=True, null=True)
    id_back_url = models.URLField(blank=True, null=True)
    selfie_url = models.URLField(blank=True, null=True)
    
    is_verified = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name='created_borrowers'
    )
    
    def __str__(self):
        return self.full_name
