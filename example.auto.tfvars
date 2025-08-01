# -----------------------------------------------------------
# AWS Configuration
# -----------------------------------------------------------
aws_region     = "us-east-1"
aws_account_id = "995673420636" # <--- IMPORTANT: Replace with your actual AWS Account ID

# -----------------------------------------------------------
# S3 Bucket Configuration
# -----------------------------------------------------------
s3_bucket_name = "my-unique-observability-logs-2025" # <--- IMPORTANT: S3 bucket names must be globally unique

# -----------------------------------------------------------
# OpenSearch Domain Configuration
# -----------------------------------------------------------
opensearch_domain_name    = "observability-domain"
opensearch_instance_type  = "t3.medium.search" # t3.small is good for testing, t3.medium for light use
opensearch_instance_count = 2                  # For multi-AZ, use 2 or more
# -----------------------------------------------------------
# OpenSearch Master User Credentials
# IMPORTANT: Choose a strong password.
# -----------------------------------------------------------
opensearch_master_username = "admin"
opensearch_master_password = "YourStrongPassword123!" # <--- CHANGE THIS to a secure password


# -----------------------------------------------------------
# OpenSearch Ingestion Pipeline Configuration
# -----------------------------------------------------------
ingestion_pipeline_name = "s3-to-opensearch-pipeline"
