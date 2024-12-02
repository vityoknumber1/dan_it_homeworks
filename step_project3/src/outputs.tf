output "public_instance_ip" {
  value = aws_instance.kysil_public_instance.public_ip
}

output "private_instance_ip" {
  value = aws_instance.kysil_private_instance.private_ip
}
