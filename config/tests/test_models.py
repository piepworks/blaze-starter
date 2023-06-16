import pytest


@pytest.fixture
def create_user(django_user_model):
    def inner_function(email, password):
        return django_user_model.objects.create_user(email, password)

    return inner_function


@pytest.fixture
def create_superuser(django_user_model):
    def inner_function(email, password, **extra_fields):
        return django_user_model.objects.create_superuser(
            email, password, **extra_fields
        )

    return inner_function


def test_user_without_email(create_user):
    with pytest.raises(ValueError):
        create_user("", "")


@pytest.mark.django_db
def test_user_creation(create_user):
    user = create_user("user@example.com", "")
    assert str(user) == "user@example.com"


def test_superuser_creation(create_superuser):
    superuser = create_superuser("superuser@example.com", "")
    assert str(superuser) == "superuser@example.com"


def test_superuser_not_staff(create_superuser):
    with pytest.raises(ValueError):
        create_superuser("superuser@example.com", "", is_staff=False)


def test_superuser_not_superuser(create_superuser):
    with pytest.raises(ValueError):
        create_superuser("superuser@example.com", "", is_superuser=False)
