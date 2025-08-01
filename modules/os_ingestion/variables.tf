variable "pipeline_name" { type = string }
variable "opensearch_domain_arn" { type = string }
variable "opensearch_endpoint" { type = string }
variable "s3_bucket_arn" { type = string }
variable "aws_region" { type = string }
variable "aws_account_id" { type = string }
variable "s3_bucket_id" {
  description = "The ID (name) of the S3 bucket."
  type        = string
}
