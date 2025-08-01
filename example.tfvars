# -----------------------------------------------------------
# AWS Configuration
# -----------------------------------------------------------
aws_region     = "us-east-1"
aws_account_id = "123456789012" # <--- IMPORTANT: Replace with your actual AWS Account ID

# -----------------------------------------------------------
# S3 Bucket Configuration
# -----------------------------------------------------------
s3_bucket_name = "my-unique-observability-logs-2025" # <--- IMPORTANT: S3 bucket names must be globally unique

# -----------------------------------------------------------
# OpenSearch Domain Configuration
# -----------------------------------------------------------
opensearch_domain_name = "observability-domain"
opensearch_instance_type = "t3.medium.search" # t3.small is good for testing, t3.medium for light use
opensearch_instance_count = 2 # For multi-AZ, use 2 or more

# -----------------------------------------------------------
# OpenSearch Ingestion Pipeline Configuration
# -----------------------------------------------------------
ingestion_pipeline_name = "s3-to-opensearch-pipeline"
