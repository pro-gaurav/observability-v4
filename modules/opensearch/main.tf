resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.opensearch_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
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

  # --- CORRECTION IS HERE ---
  # Enable Fine-Grained Access Control (FGAC) to meet AWS security requirements.
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  # This policy is now restrictive, only allowing access from within your AWS account.
  # FGAC will handle the fine-grained data access permissions.
  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "es:*",
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
