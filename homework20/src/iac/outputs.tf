output "instance_ip" {
  description = "Instance ip"
  value       = aws_instance.nginx_instance.public_ip
}