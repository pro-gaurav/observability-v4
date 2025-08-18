# 1. Create the SQS queue for S3 event notifications.
resource "aws_sqs_queue" "ingestion_queue" {
  name = "${var.pipeline_name}-queue"
  tags = {
    Name      = "OSIS Ingestion Queue"
    ManagedBy = "Terraform"
  }
}

# 2. Create a policy that explicitly allows the S3 service to send messages to our new queue.
resource "aws_sqs_queue_policy" "allow_s3_to_write" {
  queue_url = aws_sqs_queue.ingestion_queue.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = "sqs:SendMessage",
      Effect   = "Allow",
      Resource = aws_sqs_queue.ingestion_queue.arn,
      Principal = {
        Service = "s3.amazonaws.com"
      },
      Condition = {
        ArnEquals = { "aws:SourceArn" = var.s3_bucket_arn }
      }
    }]
  })
}

# 3. Configure the S3 bucket to send "object created" events to our SQS queue.
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  queue {
    queue_arn = aws_sqs_queue.ingestion_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.allow_s3_to_write]
}

# 4. IAM Role for the Ingestion Pipeline to assume.
resource "aws_iam_role" "ingestion_role" {
  name = "${var.pipeline_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "osis-pipelines.amazonaws.com" }
    }]
  })
}

# 5. IAM Policy for the pipeline's role.
resource "aws_iam_role_policy" "ingestion_policy" {
  name = "${var.pipeline_name}-policy"
  role = aws_iam_role.ingestion_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = aws_sqs_queue.ingestion_queue.arn
      },
      {
        Effect   = "Allow",
        Action   = "es:ESHttpPost",
        Resource = "${var.opensearch_domain_arn}/*"
      },
      # --- CORRECTION IS HERE ---
      # This statement adds the specific permission required by the validation error.
      # It allows the pipeline to check the status of the domain itself.
      {
        Effect   = "Allow",
        Action   = "es:DescribeDomain",
        Resource = var.opensearch_domain_arn
      }
    ]
  })
}

# 6. The OpenSearch Ingestion Pipeline resource.
resource "aws_osis_pipeline" "this" {
  pipeline_name = var.pipeline_name

  pipeline_configuration_body = <<-EOT
version: "2"
s3-log-pipeline:
  source:
    s3:
      notification_type: "sqs"
      sqs:
        queue_url: "${aws_sqs_queue.ingestion_queue.url}"
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
        index: "s3-logs-%{yyyy.MM.dd}"
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

  depends_on = [
    aws_iam_role_policy.ingestion_policy,
    aws_s3_bucket_notification.bucket_notification
  ]
}
