output "domain_arn" {
  description = "The ARN of the OpenSearch domain, used for IAM policies."
  value = aws_opensearch_domain.this.arn
}

output "domain_endpoint" {
  description = "The endpoint of the OpenSearch domain, for the ingestion pipeline to connect to."
  value = aws_opensearch_domain.this.endpoint
}
