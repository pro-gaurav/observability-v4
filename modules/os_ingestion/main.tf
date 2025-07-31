resource "aws_opensearch_ingestion_pipeline" "this" {
  name        = var.ingestion_name
  destination = var.target_opensearch

  # customize sources, processing, and destination config here
  # use variables to allow customizability

  tags = {
    Environment = "Observability"
    Region      = var.region
  }
}
