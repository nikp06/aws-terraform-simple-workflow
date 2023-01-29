# variables
variable "lambda_arn" {}
variable "topic_arn" {}

resource "aws_iam_role" "role_for_sfn" {
  name = "role_for_sfn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_sfn" {
  name        = "policy_for_sfn"
  path        = "/"
  description = "My policy for sfn"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "lambda:InvokeFunction",
            "Resource": [
                "${var.lambda_arn}",
                "${var.lambda_arn}:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": "sns:Publish",
            "Resource": "${var.topic_arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.role_for_sfn.name
 policy_arn  = aws_iam_policy.policy_for_sfn.arn
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "TfStateMachine"
  role_arn = aws_iam_role.role_for_sfn.arn

  definition = <<EOF
{
  "StartAt": "TfSubmitJob",
  "States": {
    "TfSubmitJob": {
      "End": true,
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "TfPublishMessage"
        }
      ],
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${var.lambda_arn}",
        "Payload.$": "$"
      }
    },
    "TfPublishMessage": {
      "Next": "TaskFailed",
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "${var.topic_arn}",
        "Message.$": "$.Cause"
      }
    },
    "TaskFailed": {
      "Type": "Fail"
    }
  }
}
EOF
}

# outputs
output "stepfunction_arn" {
  value = aws_sfn_state_machine.sfn_state_machine.arn
}