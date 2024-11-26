# Terraform

## install
ensure tfenv is installed https://github.com/tfutils/tfenv
tfenv will use the .terraform_version in the root of this repo.

```bash
tfenv install
```

## credentials

The aws provider documentation give several choices for credentials. https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

### environment vars
Environment vars can be set prior to running the terraform commands

```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-west-2"
terraform plan
```

### shared config
if you have the aws cli, shared configuration can be configured. The code looks for the "default" profile.

check the `provider.tf` file.

refs: 
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html


