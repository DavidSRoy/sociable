import pytest


def pytest_addoption(parser):
    parser.addoption("--auth", action="store", help="pass in auth token")


def pytest_generate_tests(metafunc):
    if "auth" in metafunc.fixturenames:
        metafunc.parametrize("auth_token", metafunc.config.getoption("--auth"))

@pytest.fixture
def auth_token(request):
    return request.config.getoption("--auth")