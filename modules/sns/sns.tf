variable "email_address" {}

resource "aws_sns_topic" "failure_topic" {
  name = "TfFailureTopic"
}

resource "aws_sns_topic_subscription" "failure_topic_target" {
  topic_arn = aws_sns_topic.failure_topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}

# outputs
output "topic_arn" {
  value = aws_sns_topic.failure_topic.arn
}