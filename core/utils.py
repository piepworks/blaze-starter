from django.core.mail import send_mail
from config.settings import ADMIN_EMAIL_FROM, ADMIN_EMAIL_TO


def send_email_to_admin(subject, message):
    send_mail(
        subject=subject,
        message=message,
        from_email=f"{ADMIN_EMAIL_FROM}",
        recipient_list=[f"{ADMIN_EMAIL_TO}"],
    )
