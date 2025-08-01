# The primary resource for the OpenSearch Ingestion Pipeline
resource "aws_osis_pipeline" "this" {
  pipeline_name = var.pipeline_name

  # Corrected pipeline configuration body.
  pipeline_configuration_body = <<-EOT
version: "2"
s3-log-pipeline:
  source:
    s3:
      notification_type: "sqs"
      codec:
        newline: {}
      aws:
        region: "${var.aws_region}"
        sts_role_arn: "${aws_iam_role.ingestion_role.arn}"
  processor:
    - date:
        from_time_received: true
        destination: "@timestamp"
  sink:
    - opensearch:
        hosts: [ "https://${var.opensearch_endpoint}" ]
        # --- CORRECTION IS HERE ---
        # The syntax for date formatting refers to the @timestamp field set in the processor.
        # We must escape the dollar sign with another dollar sign ($$) to prevent
        # Terraform from trying to interpret it as a variable.
        index: "s3-logs-$${@timestamp:yyyy-MM-dd}"
        aws:
          region: "${var.aws_region}"
          sts_role_arn: "${aws_iam_role.ingestion_role.arn}"
EOT

  min_units = 1
  max_units = 4

  tags = {
    Name      = "S3 to OpenSearch Ingestion Pipeline"
    ManagedBy = "Terraform"
  }

  # Ensure the policy is attached before the pipeline is created
  depends_on = [
    aws_iam_role_policy.ingestion_policy
  ]
}

# IAM Role for the Ingestion Pipeline to assume
resource "aws_iam_role" "ingestion_role" {
  name = "${var.pipeline_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "osis-pipelines.amazonaws.com"
      }
    }]
  })
}

# Corrected and expanded IAM Policy
resource "aws_iam_role_policy" "ingestion_policy" {
  name = "${var.pipeline_name}-policy"
  role = aws_iam_role.ingestion_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = "es:ESHttpPost",
        Resource = "${var.opensearch_domain_arn}/*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:PutBucketNotificationConfiguration",
        Resource = var.s3_bucket_arn
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:CreateQueue",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:SetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        Resource = "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:Data-Ingestion-*"
      }
    ]
  })
}
