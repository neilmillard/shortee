from typing import TYPE_CHECKING

from src.domain.short_url_repository import ShortUrlRepository

if TYPE_CHECKING:
    pass


class ShortUrl:
    def __init__(
        self,
        base_url: str,
        target_url: str,
        slug: str,
    ):
        self.base_url = base_url
        self.target_url = target_url
        self.slug = slug

    def save(self, short_url_repository: "ShortUrlRepository"):
        short_url_repository.save(self)

    def __str__(self):
        return self.base_url + self.slug

    def to_json(self):
        return {
            "target_url": self.target_url,
            "short_url": str(self),
            "slug": self.slug,
        }
