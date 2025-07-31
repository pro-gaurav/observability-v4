output "s3_bucket_id" {
  description = "The name of the S3 bucket."
  value       = module.s3_bucket.bucket_id
}

output "opensearch_domain_endpoint" {
  description = "The endpoint of the OpenSearch domain."
  value       = module.opensearch_domain.domain_endpoint
}

output "opensearch_ingestion_pipeline_arn" {
  description = "The ARN of the OpenSearch Ingestion pipeline."
  value       = module.opensearch_ingestion.pipeline_arn
}
