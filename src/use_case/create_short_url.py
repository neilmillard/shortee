import logging


class CreateShortUrl:
    def __init__(
        self, logger: logging.Logger, short_url_repository: "ShortUrlRepository"
    ) -> None:
        self.logger = logger
        self.short_url_repository = short_url_repository

    def __call__(self, target_url: str) -> "UseCaseResponse":
        pass
