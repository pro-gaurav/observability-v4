resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.opensearch_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
    zone_awareness_enabled = var.instance_count > 1 ? true : false
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }
  
  # WARNING: This access policy allows public access. 
  # For production, restrict this to specific IPs or VPCs.
  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "es:*",
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"
      }
    ]
  })

  tags = {
    Name      = "Observability Domain"
    ManagedBy = "Terraform"
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
