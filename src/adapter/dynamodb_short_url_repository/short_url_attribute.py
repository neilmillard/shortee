from typing import Union


class ShortUrlAttribute:
    def __init__(self, name: str, data_type: str, data_value: Union[str, dict]) -> None:
        self.name = name
        self.data_type = data_type
        self.data_value = data_value
