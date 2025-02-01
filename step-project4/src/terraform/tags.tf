variable "environment" {
  type    = string
  default = "K8S"
}

variable "project" {
  type    = string
  default = "STEP_PROJECT_4"
}

variable "owner" {
  type    = string
  default = "KYSIL"
}

locals {
  # Function to generate unique Name tags for each resource
  dynamic_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

variable "common_tags" {
  description = "Reusable tags that accept unique values per resource"
  type        = map(string)
  default     = {}
}

locals {
  common_tags = merge(local.dynamic_tags, var.common_tags)
}