# PYTHON_VERSION used by poetry
PYTHON_VERSION := $(shell cat .python-version)
LAMBDA_ZIP_NAME = dist_lambda.zip

.PHONY: test
test: install black
	@poetry run pytest tests/

.PHONY: fast-test
fast-test:
	@poetry run pytest --no-cov tests/

.PHONY: install
install:
	@poetry install

.PHONY: installpoetry
installpoetry:
	@curl -sSL https://install.python-poetry.org | python

.PHONY: black
black:
	poetry run black . --config=./pyproject.toml

.PHONY: build
build:
	@rm -rf ./dist/
	@rm -f ${LAMBDA_ZIP_NAME}
	@mkdir ./dist
	@cp -r ./src ./dist/
	@cp ./lambda_function.py ./dist/
	@poetry export -f requirements.txt --output requirements.txt
	@pip install --no-deps -r requirements.txt --target dist
	@cd ./dist && zip -qr9 ../${LAMBDA_ZIP_NAME} .
