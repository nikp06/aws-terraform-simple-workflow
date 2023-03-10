# Variables
# define these secret variable values via command line
# export TF_VAR_aws_profile=bar

# or in terraform.tfvars file
# aws_profile = "bar"

# or when prompted after terraform commands

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

# Modules
module "lambda" {
  source          = "./modules/lambda"
}

module "stepfunction" {
  source              = "./modules/stepfunction"
  lambda_arn = module.lambda.lambda_arn
  topic_arn = module.sns.topic_arn
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  stepfunction_arn = module.stepfunction.stepfunction_arn
  bucket_arn = module.s3.bucket_arn
}

module "sns" {
  source          = "./modules/sns"
  email_address = var.email_address
}

module "s3" {
  source          = "./modules/s3"
}

# Outputs
output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "topic_arn" {
  value = module.sns.topic_arn
}

output "stepfunction_arn" {
  value = module.stepfunction.stepfunction_arn
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}


# output "aws_cloudwatch_event_rule_arn" {
# value = module.aws_cloudwatch_event.aws_cloudwatch_event_rule_arn
# }