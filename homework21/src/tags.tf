variable "environment" {
  type    = string
  default = "STAGE"
}

variable "project" {
  type    = string
  default = "HW_21"
}

variable "owner" {
  type    = string
  default = "KYSIL"
}

locals {
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