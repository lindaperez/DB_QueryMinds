from django.db import models

from django.contrib.auth.models import User

class Message(models.Model):
    id_message = models.AutoField(primary_key=True)
    sender = models.ForeignKey(User, related_name='sent_messages', on_delete=models.RESTRICT, db_column='id_sender')
    receiver = models.ForeignKey(User, related_name='received_messages', on_delete=models.RESTRICT, db_column='id_receiver')
    v_text = models.TextField()
    d_sent_at = models.DateTimeField()
    n_read_status = models.BooleanField(default=False)