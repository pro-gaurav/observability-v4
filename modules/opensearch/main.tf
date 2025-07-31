resource "aws_opensearch_domain" "this" {
  domain_name           = var.opensearch_domain
  engine_version        = var.opensearch_version
  cluster_config {
    instance_type = "m5.large.search"    # Use variable if you want to parametrize
    instance_count = 2                   # Use variable if you want to parametrize
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 100
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  tags = {
    Environment = "Observability"
    Region      = var.region
  }
}
