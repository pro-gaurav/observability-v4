output "bucket_id" {
  value = aws_s3_bucket.log_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket, used for IAM policies."
  value       = aws_s3_bucket.log_bucket.arn
}
