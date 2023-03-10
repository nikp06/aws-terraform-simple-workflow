data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/scripts/test_failure.py"
  output_path = "${path.module}/scripts/test_failure.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_failure_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/scripts/test_failure.zip"
  function_name = "TfFailureLambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "test_failure.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #   source_code_hash = filebase64sha256("sc.zip")
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256

  runtime = "python3.9"
}

# outputs
output "lambda_arn" {
  value = aws_lambda_function.test_failure_lambda.arn
}