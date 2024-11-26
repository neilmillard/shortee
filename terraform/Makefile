SHELL := /bin/bash
TERRAFORM_VERSION := $(shell cat ../.terraform-version)
ACCOUNT_NUMBER=$(shell cat ../account_id)

.PHONY: clean
clean:
	rm -rf .terraform

.PHONY: init
init:
	terraform init -reconfigure # -backend-config="bucket=your-terraform-state-bucket"

.PHONY: installterraform
installterraform:
	curl -Lo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	unzip -o terraform.zip -d /usr/local/bin/

.PHONY: build
build:
	if [ ${ACCOUNT_NUMBER} -eq 12345678; then; echo "You need to add YOUR AWS account number. See README" && exit 1; fi
	make init
	terraform workspace select prod
	terraform plan -out=terraform.plan -lock-timeout=30s
	terraform apply terraform.plan
	export API_PUBLIC_HOSTNAME=$(terraform output -raw api_public_hostname)
	echo -n ${API_PUBLIC_HOSTNAME} > ../.api_public_hostname


