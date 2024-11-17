resource "aws_security_group" "nginx_sg" {
  name_prefix = "viktor-kysil-nginx-sg-"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.list_of_open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SG-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Create EC2
resource "aws_instance" "nginx_instance" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              systemctl start nginx
              EOF

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EC2-INSTANCE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}