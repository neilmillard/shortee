from logging import Logger


class PerformHealthCheck:
    def __init__(self, logger: Logger):
        self.logger = logger

    def __call__(self, event: dict) -> dict:
        self.logger.info(event)
        return {"success": True}
