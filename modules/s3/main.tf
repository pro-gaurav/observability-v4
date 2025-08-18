resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name

  tags = {
    Name      = "Observability Log Bucket"
    ManagedBy = "Terraform"
  }
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
