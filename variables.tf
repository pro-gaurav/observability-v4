variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
}

variable "aws_account_id" {
  description = "Your AWS Account ID, needed for IAM policy creation."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing logs."
  type        = string
}

variable "opensearch_domain_name" {
  description = "The name for the Amazon OpenSearch domain."
  type        = string
}

variable "opensearch_version" {
  description = "The engine version for the OpenSearch domain."
  type        = string
  default     = "OpenSearch_2.11" # Note: 2.19 is not a valid version, 2.11 is a recent, stable one.
}

variable "opensearch_instance_type" {
  description = "The instance type for the OpenSearch data nodes."
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "The number of data nodes in the OpenSearch cluster."
  type        = number
  default     = 1
}

variable "ingestion_pipeline_name" {
  description = "The name for the OpenSearch Ingestion pipeline."
  type        = string
}

variable "opensearch_master_username" {
  description = "The master username for the OpenSearch domain."
  type        = string
  sensitive   = true
}

variable "opensearch_master_password" {
  description = "The master password for the OpenSearch domain."
  type        = string
  sensitive   = true
}
