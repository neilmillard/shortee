import logging
import os

from aws_lambda_typing.context import Context
from src.lambda_function import LambdaHandler


def lambda_handler(event: dict = None, context: Context = None):
    if event is None:
        event = {}
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    handler = LambdaHandler(logger)
    response = handler.run(os.environ, event, context)
    return response
