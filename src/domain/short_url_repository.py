import abc

from src.domain.short_url import ShortUrl


class ShortUrlRepository(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def load(
        self,
        slug: str,
    ) -> ShortUrl:
        raise NotImplementedError

    @abc.abstractmethod
    def save(self, short_url: ShortUrl) -> None:
        raise NotImplementedError
