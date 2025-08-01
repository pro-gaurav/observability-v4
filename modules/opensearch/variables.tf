variable "domain_name" { type = string }
variable "opensearch_version" { type = string }
variable "instance_type" { type = string }
variable "instance_count" { type = number }
variable "master_user_name" {
  description = "The username for the OpenSearch master user."
  type        = string
  sensitive   = true
}

variable "master_user_password" {
  description = "The password for the OpenSearch master user. Must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character."
  type        = string
  sensitive   = true
}
