import os
from unittest import mock
from unittest.mock import patch

import pytest

from src.lambda_function import lambda_handler


@pytest.fixture
def mock_healthcheck(mocker):
    with patch(
        "src.use_case.perform_health_check.PerformHealthCheck.__call__"
    ) as mock_healthcheck:
        yield mock_healthcheck


@pytest.fixture()
def set_env_var(monkeypatch):
    with mock.patch.dict(os.environ, clear=True):
        envvars = {
            "API_ID": "a1234",
        }
        for k, v in envvars.items():
            monkeypatch.setenv(k, v)
        yield  # This is the magical bit which restore the environment after


def test_no_matching_use_case_found(set_env_var):
    result = lambda_handler({})
    assert not result["success"]
    assert result["message"] == "use_case not found"


def test_use_case_mapping(set_env_var):
    result = lambda_handler({"use_case": "PerformHealthCheck"})
    assert result["success"]


def test_thrown_exception(mock_healthcheck, caplog, set_env_var):
    mock_healthcheck.side_effect = Exception("A big error happened")
    result = lambda_handler({"use_case": "PerformHealthCheck"})

    assert "big error happened" in caplog.text

    assert not result["success"]
