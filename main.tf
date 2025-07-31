provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source      = "../modules/s3"
  bucket_name = var.s3_bucket_name
  region      = var.aws_region
}

module "opensearch" {
  source                  = "../modules/opensearch"
  domain_name             = var.opensearch_domain
  region                  = var.aws_region
  opensearch_version      = var.opensearch_version
}

module "opensearch_ingestion" {
  source                  = "../modules/os_ingestion"
  ingestion_name          = var.ingestion_name
  target_opensearch       = module.opensearch.endpoint
  region                  = var.aws_region
}
