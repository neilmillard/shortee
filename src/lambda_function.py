from logging import Logger
from typing import MutableMapping

from aws_lambda_typing.context import Context

from src.use_case.create_short_url import CreateShortUrl
from src.use_case.perform_health_check import PerformHealthCheck


class LambdaHandler:
    def __init__(self, logger: Logger):
        self.logger = logger

    def run(
        self,
        environment: MutableMapping = None,
        event: dict = None,
        context: Context = None,
    ):
        if environment is None:
            environment = {}
        if event is None:
            event = {}

        requested_use_case = event.get("use_case")
        use_case_mapping = {
            # "GetShortUrl": GetShortUrl(logger),
            "CreateShortUrl": CreateShortUrl(self.logger, ""),
            "PerformHealthCheck": PerformHealthCheck(self.logger),
        }
        use_case = use_case_mapping.get(requested_use_case)

        response = {"success": False, "message": "use_case not found"}
        if use_case:
            try:
                response = use_case(event)
            except BaseException as e:
                message = f"Exception Detected\n{e}"
                self.logger.error(message)
                response["message"] = message
        return response
