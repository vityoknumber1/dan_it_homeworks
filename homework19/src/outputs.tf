output "public_instance_ip" {
  value = aws_instance.kysil_public_instance.public_ip
}

output "public_instance_id" {
  value = aws_instance.kysil_public_instance.id
}

output "private_instance_id" {
  value = aws_instance.kysil_private_instance.id
}
