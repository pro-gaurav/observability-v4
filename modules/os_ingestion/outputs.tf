output "pipeline_arn" {
  description = "The ARN of the OpenSearch Ingestion pipeline."
  # CORRECTION: This now references the correctly named resource 'aws_osis_pipeline'.
  value = aws_osis_pipeline.this.pipeline_arn
}
