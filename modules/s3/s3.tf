resource "aws_s3_bucket" "bucket" {
  bucket = "tf-simple-workflow-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  eventbridge = true
}

# outputs
output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}