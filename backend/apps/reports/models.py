from django.db import models
from apps.core.models import TimeStampedModel

class Report(TimeStampedModel):
    REPORT_TYPES = (
        ('financial', 'Financial Report'),
        ('portfolio', 'Portfolio Analysis'),
        ('cashflow', 'Cash Flow Report'),
        ('overdue', 'Overdue Report'),
        ('custom', 'Custom Report'),
    )
    
    name = models.CharField(max_length=255)
    report_type = models.CharField(max_length=20, choices=REPORT_TYPES)
    date_range_start = models.DateField()
    date_range_end = models.DateField()
    generated_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True)
    file_url = models.URLField(blank=True, null=True)
    data = models.JSONField(default=dict)
    
    def __str__(self):
        return f"{self.name} - {self.report_type}"
