resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true
    expiration {
      days = 90
    }
  }

  tags = {
    Environment = "Observability"
    Region      = var.aws_region
  }
}
