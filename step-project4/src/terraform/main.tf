provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-danit-devops5"
    key    = "viktor-kysil/iac_sp_4.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-VPS-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-INTERNET_GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_eip" "nat" {
  # vpc = true
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EIP-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT_GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-ROUTE_TABLE_PUBLIC-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-ROUTE_TABLE_PRIVATE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_1-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_2-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1c"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_3-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1a"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_1-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-central-1b"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_2-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-central-1c"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_3-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "STEP_PROJECT_4_EKS_CLUSTER_ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-IAM_CLUSTER_ROLE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "node_instance_role" {
  name = "STEP_PROJECT_4_EKS_NODE_INSTANCE_ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-IAM_NODE_ROLE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_iam_role_policy_attachment" "node_eks_worker_policy_attachment" {
  role       = aws_iam_role.node_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni_policy_attachment" {
  role       = aws_iam_role.node_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ec2_container_registry_policy_attachment" {
  role       = aws_iam_role.node_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "STEP_PROJECT_4_CLUSTER"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.public_3.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id,
      aws_subnet.private_3.id,
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
  ]

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EKS_CLUSTER-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "STEP_PROJECT_4_CLUSTER_NODE_GROUP"
  node_role_arn   = aws_iam_role.node_instance_role.arn
  subnet_ids      = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_eks_worker_policy_attachment,
    aws_iam_role_policy_attachment.node_cni_policy_attachment,
    aws_iam_role_policy_attachment.node_ec2_container_registry_policy_attachment,
  ]


  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EKS_NODE_GROUP-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "${aws_eks_cluster.eks_cluster.name}-ebs-csi-driver-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EBS_CSI_DRIVER_ROLE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_iam_policy_attachment" "ebs_csi_driver_policy_attachment" {
  name       = "ebs-csi-driver-policy-attachment"
  roles      = [aws_iam_role.ebs_csi_driver_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks_cluster.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.38.1-eksbuild.2"
  service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EBS_CSI_DRIVER-%s-%s", var.owner, var.environment, var.project)
    }
  )

  depends_on = [aws_iam_policy_attachment.ebs_csi_driver_policy_attachment]
}