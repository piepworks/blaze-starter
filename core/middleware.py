import pytz
from django.utils import timezone
from django.conf import settings


class TimezoneMiddleware:
    """
    Automatically set the timezone to what the user has chosen.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.user.is_authenticated:
            tzname = request.user.timezone
            if tzname:
                timezone.activate(pytz.timezone(tzname))
            else:
                timezone.activate(pytz.timezone(settings.TIME_ZONE))
        else:
            timezone.deactivate()

        return self.get_response(request)
