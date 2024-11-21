variable "aws_region" {
  default = "eu-north-1"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.1.0.0/17"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "myKey"
}