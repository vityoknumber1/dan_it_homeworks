variable "instance_type" {
  description = "The instance type of the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the public subnet where the instance will be placed"
  type        = string
}

variable "list_of_open_ports" {
  description = "A list of ports to be opened on the security group"
  type        = list(number)
}

variable "region" {
  description = "A aws region where resources will be created"
  type        = string
}