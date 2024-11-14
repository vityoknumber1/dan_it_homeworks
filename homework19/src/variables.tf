variable "aws_region" {
  default = "eu-north-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)"
  default     = "ami-08eb150f611ca277f"
}

variable "key_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "myKey"
}
