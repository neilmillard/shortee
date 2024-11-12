PYTHON_VERSION := $(shell cat .python-version)

.PHONY: test
test: install black
	poetry run pytest tests/

.PHONY: fast-test
fast-test:
	poetry run pytest --no-cov tests/

.PHONY: install
install:
	poetry install

.PHONY: installpoetry
installpoetry:
	@curl -sSL https://install.python-poetry.org | python

.PHONY: black
black:
	poetry run black . --config=./pyproject.toml
