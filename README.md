## Pre-requisites

Ensure you already have pyenv installed on your machine.

## Setup

1. Run `pyenv install`
2. Run `make installpoetry` and restart your shell
3. Run `make install`

## Testing

```bash
make test
```

## Manually uploading a lambda artefact

First you need to build the distributable package:

```bash
make build
```

Then this will push the distributable package

```bash
ACCOUNT_ID="Your AWS ACCOUNT_ID"
aws lambda update-function-code --function-name arn:aws:lambda:eu-west-2:${ACCOUNT_ID}:function:proxy-lambda --zip-file fileb://distributable_lambda.zip --publish
```
