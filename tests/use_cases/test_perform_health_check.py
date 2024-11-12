import logging
from unittest.mock import Mock, call

from src.use_case.perform_health_check import PerformHealthCheck

logger = logging.getLogger()


def test_returns_success_true():
    event = {}
    assert PerformHealthCheck(logger)(event)["success"]


def test_logs_the_event():
    mock_logger = Mock()
    event = {"use_case": "PerformHealthCheck"}
    PerformHealthCheck(mock_logger)(event)
    mock_logger.assert_has_calls([call.info(event)])
