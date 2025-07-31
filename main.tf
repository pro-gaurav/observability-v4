# Defines the required Terraform version and the AWS provider.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configures the AWS provider with the region specified in your variables.
provider "aws" {
  region = var.aws_region
}

# -----------------------------------------------------------------------------
# MODULE: S3 Bucket
# This calls the S3 module to create the log storage bucket.
# -----------------------------------------------------------------------------
module "s3_bucket" {
  source = "./modules/s3"

  # Provides the `bucket_name` variable that the S3 module requires.
  bucket_name = var.s3_bucket_name
}

# -----------------------------------------------------------------------------
# MODULE: OpenSearch Domain
# This calls the OpenSearch module to create the cluster.
# -----------------------------------------------------------------------------
module "opensearch_domain" {
  source = "./modules/opensearch"

  # Provides the required variables from your terraform.tfvars file.
  domain_name        = var.opensearch_domain_name
  opensearch_version = var.opensearch_version
  instance_type      = var.opensearch_instance_type
  instance_count     = var.opensearch_instance_count
}

# -----------------------------------------------------------------------------
# MODULE: OpenSearch Ingestion Pipeline
# This calls the ingestion module and connects everything together.
# -----------------------------------------------------------------------------
module "opensearch_ingestion" {
  source = "./modules/os_ingestion"

  # --- Variables from terraform.tfvars ---
  pipeline_name  = var.ingestion_pipeline_name
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id

  # --- Outputs from other modules ---
  # These lines connect the modules by passing resource details created
  # by one module as inputs to another. This is key to making them work together.
  opensearch_domain_arn = module.opensearch_domain.domain_arn
  opensearch_endpoint   = module.opensearch_domain.domain_endpoint
  s3_bucket_arn         = module.s3_bucket.bucket_arn
}
