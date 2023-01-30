# terraform installation
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

# Usage

### authentication
- login via `aws configure sso` or `aws sso login`
- put your secret variables in a file called terraform.tfvars

```
aws_region  = "foo"
aws_profile = "bar"
email_address = "baz"
```

#### terraform with sso fix (if you have troubles with credentials)
- add sso_region and sso_start_url to your profile
https://github.com/hashicorp/terraform-provider-aws/issues/28263
```bash
aws sso login --profile AdministratorAccess-XXXXXXXXXXXXXXXXX
```

### deployment

```bash
terraform init
terraform plan
terraform apply
```

### testing the stack

- confirm email subscription (should have received an email during deployment)
- upload an example file to the new s3 bucket 
- see if you receive an email - done