terraform installation
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

terraform with sso fix
add sso_region and sso_start_url to your profile
https://github.com/hashicorp/terraform-provider-aws/issues/28263
```bash
aws sso login --profile AdministratorAccess-XXXXXXXXXXXXXXXXX
```

put your secret variables in a file called terraform.tfvars
```
aws_region  = "foo"
aws_profile = "bar"
email_address = "baz"
```

```bash
terraform init
terraform plan
terraform apply
```