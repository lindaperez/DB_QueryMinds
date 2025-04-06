from django.db import models

class Message(models.Model):
    sender = models.CharField(max_length=100)
    receiver = models.CharField(max_length=100)
    subject = models.CharField(max_length=255, blank=True)
    content = models.TextField()
    is_read = models.BooleanField(default=False)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender} to {self.receiver}"

