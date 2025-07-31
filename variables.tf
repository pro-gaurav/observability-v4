variable "aws_region" { 
    description = "AWS region to deploy in" 
    }

variable "s3_bucket_name" { 
    description = "S3 Bucket name" 
    }

variable "opensearch_domain" { 
    description = "OpenSearch Domain name" 
    }

variable "opensearch_version" { 
    description = "OpenSearch Version" 
    default = "OpenSearch_2.19" 
    }

variable "ingestion_name" { 
    description = "Name for the OS ingestion pipeline" 
    }
