variable "aws_region" {
  default = "eu-central-1"
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

variable "spot_instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)"
  default     = "ami-08eb150f611ca277f"
}

#variable "spot_price" {
#type        = string
#default     = "0.016"
#description = "Maximum price to pay for spot instance"
#}
#variable "spot_type" {
#type        = string
#default     = "one-time"
#description = "Spot instance type, this value only applies for spot instance type."
#}

variable "key_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "myKey"
}

variable "ssh_public_key" {
  default = "public_key"
}