import httpretty
import pytest


@pytest.fixture(autouse=True)
def cleanup_httpretty_after_each_test():
    yield
    httpretty.reset()


@pytest.fixture(autouse=True)
def enable_httpretty_before_test_session():
    httpretty.enable(allow_net_connect=False)
    yield
