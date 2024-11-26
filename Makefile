# PYTHON_VERSION used by poetry
PYTHON_VERSION := $(shell cat .python-version)
LAMBDA_ZIP_NAME := dist_lambda.zip
ACCOUNT_NUMBER := $(shell cat .account_id)

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

.PHONY: deploy
deploy: build
	# We need to know that terraform is ready, so we check for the api_public_hostname that is output
	aws lambda update-function-code \
	  --function-name arn:aws:lambda:eu-west-2:${ACCOUNT_NUMBER}:function:web-lambda \
	  --zip-file fileb://${LAMBDA_ZIP_NAME} \
	  --publish
	# Wait for lambda function update to complete
	until aws lambda get-function --function-name arn:aws:lambda:eu-west-2:${ACCOUNT_NUMBER}:function:web-lambda | jq --exit-status '.Configuration.LastUpdateStatus == "Successful"'; do
	  sleep 1s
	done
	export API_PUBLIC_HOSTNAME=$(cat ./.api_public_hostname)
	JSON_OUTPUT=$(curl -s -S -XPOST -H 'Content-Type: application/json' -H "Host:${API_PUBLIC_HOSTNAME}" "${EXECUTE_API_VPC_ENDPOINT_URL}/v1/PerformHealthcheck")
	echo "${JSON_OUTPUT}" | jq --exit-status '.success == true'
