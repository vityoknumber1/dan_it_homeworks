data "aws_availability_zones" "available" {
  state = "available"
}


output "list_of_az" {
  description = "List of availability zones"
  value       = data.aws_availability_zones.available[*].names
}