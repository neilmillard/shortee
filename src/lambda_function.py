import logging

from aws_lambda_typing.context import Context

from src.use_case.create_short_url import CreateShortUrl
from src.use_case.perform_health_check import PerformHealthCheck


def lambda_handler(event: dict = None, context: Context = None):
    if event is None:
        event = {}
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    requested_use_case = event.get("use_case")
    use_case_mapping = {
        # "GetShortUrl": GetShortUrl(logger),
        "CreateShortUrl": CreateShortUrl(logger, ""),
        "PerformHealthCheck": PerformHealthCheck(logger),
    }
    use_case = use_case_mapping.get(requested_use_case)

    response = {"success": False, "message": "use_case not found"}
    if use_case:
        try:
            response = use_case(event)
        except BaseException as e:
            message = f"Exception Detected\n{e}"
            logger.error(message)
            response["message"] = message
    return response
