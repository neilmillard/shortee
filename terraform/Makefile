SHELL := /bin/bash

.PHONY: clean
clean:
	rm -rf .terraform

.PHONY: init
init:
	terraform init -reconfigure -backend-config="bucket=terraform-shortie"
