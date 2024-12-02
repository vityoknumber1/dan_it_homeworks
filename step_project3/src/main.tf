provider "aws" {
  region = var.aws_region
  #profile = "default"
}

resource "aws_vpc" "kysil_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-VPC-%s-%s", var.owner, var.environment, var.project)
    }
  )
}


resource "aws_subnet" "kysil_public_subnet" {
  vpc_id                  = aws_vpc.kysil_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-SUBNET-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "kysil_private_subnet" {
  vpc_id     = aws_vpc.kysil_vpc.id
  cidr_block = var.private_subnet_cidr_block

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-SUBNET-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_internet_gateway" "kysil_igw" {
  vpc_id = aws_vpc.kysil_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-IGW-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table" "kysil_public_rt" {
  vpc_id = aws_vpc.kysil_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-RT-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_eip" "kysil_nat_eip" {
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT-EIP-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_nat_gateway" "kysil_nat_gw" {
  allocation_id = aws_eip.kysil_nat_eip.id
  subnet_id     = aws_subnet.kysil_public_subnet.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT-GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route" "kysil_public_route" {
  route_table_id         = aws_route_table.kysil_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kysil_igw.id
}

resource "aws_route_table_association" "kysil_public_subnet_association" {
  subnet_id      = aws_subnet.kysil_public_subnet.id
  route_table_id = aws_route_table.kysil_public_rt.id
}

resource "aws_route_table" "kysil_private_rt" {
  vpc_id = aws_vpc.kysil_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-RT-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route" "kysil_private_route" {
  route_table_id         = aws_route_table.kysil_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.kysil_nat_gw.id

}

resource "aws_route_table_association" "kysil_private_subnet_association" {
  subnet_id      = aws_subnet.kysil_private_subnet.id
  route_table_id = aws_route_table.kysil_private_rt.id
}

resource "aws_security_group" "kysil_public_sg" {
  vpc_id = aws_vpc.kysil_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
      Name = format("%s-PUBLIC-SG-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_security_group" "kysil_private_sg" {
  vpc_id = aws_vpc.kysil_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.kysil_public_sg.id]
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
      Name = format("%s-PRIVATE-SG-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey" # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "kysil_public_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.kysil_public_subnet.id
  vpc_security_group_ids = [aws_security_group.kysil_public_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-INSTANCE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_instance" "kysil_private_instance" {
  ami           = data.aws_ami.cheap_spot.id
  instance_type = var.instance_type
  #spot_price             = var.spot_price
  #spot_type              = var.spot_type
  subnet_id              = aws_subnet.kysil_private_subnet.id
  vpc_security_group_ids = [aws_security_group.kysil_private_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 2.0
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-INSTANCE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}


resource "aws_instance" "jenkins_slave" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.kysil_public_subnet.id
  vpc_security_group_ids = [aws_security_group.kysil_public_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-JENKINS-SLAVE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

#resource "local_file" "ansible_inventory" {
#filename = "../ansible/hosts.ini"
#content  = <<-EOT
#[master]
#JENKINS_MASTER ansible_host=${aws_instance.kysil_public_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/dan_it_aws_id_rsa
#[slave]
#JENKINS_SLAVE ansible_host=${aws_instance.jenkins_slave.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/dan_it_aws_id_rsa
#EOT
#}

resource "null_resource" "inventory" {
  #depends_on = [aws_instance.kysil_ec2_instance]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
cat > ${path.module}/ansible/hosts.ini <<EOF
[master]
${join("\n", slice(aws_instance.kysil_public_instance[*].public_ip, 0, 1))}
[slave]
${join("\n", slice(aws_instance.jenkins_slave[*].public_ip, 0, 1))}
EOF
EOT
  }
}
