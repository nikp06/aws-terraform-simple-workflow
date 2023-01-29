variable "aws_region" {
  description = "aws region to deploy resources in"
  type        = string
  default     = "eu-central-1"
  sensitive   = true
}

variable "aws_profile" {
  description = "the aws profile to use for the credentials"
  type        = string
  sensitive   = true
}

variable "email_address" {
  description = "the email address where sns sends failure messages to"
  type        = string
  sensitive   = true
}

# command line
# export TF_VAR_aws_region=foo
# export TF_VAR_aws_profile=bar

# or in terraform.tfvars file
# aws_region  = "foo"
# aws_profile = "bar"